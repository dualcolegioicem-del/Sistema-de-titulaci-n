from django.contrib import messages
from django.core.exceptions import ValidationError
from django.core.files.storage import FileSystemStorage
from django.core.validators import validate_email
from django.db import transaction
from django.db.models import Count, Q
from django.shortcuts import render, redirect, get_object_or_404
from django.urls import reverse
from django.utils import timezone

from .models import (
    Usuario, Alumnos, Empleados, ModalidadesTitulacion,
    ProcesosTitulacion, TiposDocumentos, DocumentosAlumno,
    SeguimientoTitulacion, ObservacionesDocumentos, MensajesProceso,
)


DOCS_DIRECTA = {
    'acta': 'Acta de nacimiento',
    'carta': 'Carta de pasante',
    'certificado_prepa': 'Certificado de preparatoria',
    'curp': 'CURP',
    'ine': 'INE',
    'certificado_lic': 'Certificado de licenciatura',
    'comprobante': 'Comprobante de domicilio',
    'fotos': 'Fotografías',
    'cv': 'Currículum vitae (CV)',
}

DOCS_EXPERIENCIA = {
    'caso': 'Caso de éxito',
    'acta': 'Acta de nacimiento',
    'certificado_prepa': 'Certificado de preparatoria',
    'curp': 'CURP',
    'ine': 'INE',
    'cv': 'Currículum vitae (CV)',
    'constancia_laboral': 'Constancia laboral',
    'comprobante': 'Comprobante de domicilio',
    'fotos': 'Fotografías',
}

DOCS_PROYECTO = {
    'proyecto': 'Proyecto',
    'acta': 'Acta de nacimiento',
    'certificado_prepa': 'Certificado de preparatoria',
    'curp': 'CURP',
    'ine': 'INE',
    'cv': 'Currículum vitae (CV)',
    'constancia_laboral': 'Constancia laboral',
    'comprobante': 'Comprobante de domicilio',
    'fotos': 'Fotografías',
}

MAX_MB = 5

DOCS = {
    'directa': DOCS_DIRECTA,
    'experiencia': DOCS_EXPERIENCIA,
    'proyecto': DOCS_PROYECTO,
}

ETAPAS_PROYECTO = [
    'Entrega de documentos', 'Revisión', 'Proyecto',
    'Examen', 'Emisión del título', 'Entrega',
]

NOMBRES_ETAPAS = {
    'directa': [
        'Entrega de documentos', 'Revisión', 'Equivalencia de materias',
        'Emisión del título', 'Entrega',
    ],
    'experiencia': ETAPAS_PROYECTO,
    'proyecto': ETAPAS_PROYECTO,
}


def etapas_de(modalidad):
    """Devuelve las etapas según el nombre de la modalidad."""
    clave = _clave_modalidad(modalidad) or 'directa'
    nombres = NOMBRES_ETAPAS[clave]
    total = len(nombres)

    return [
        {
            'numero': i,
            'nombre': n,
            'porcentaje': 5 * round(i * 100 / total / 5),
        }
        for i, n in enumerate(nombres, start=1)
    ]


# Nombres de etapa de todas las modalidades, sin repetir y en orden (para el filtro del panel)
TODOS_LOS_ESTADOS = list(dict.fromkeys(n for lista in NOMBRES_ETAPAS.values() for n in lista))


def _clave_modalidad(nombre_modalidad):
    """'directa' / 'experiencia' / 'proyecto' según el nombre de la modalidad."""
    nombre = (nombre_modalidad or '').lower()
    for clave in DOCS:
        if clave in nombre:
            return clave
    return None


def _total_docs_modalidad(nombre_modalidad):
    clave = _clave_modalidad(nombre_modalidad)
    return len(DOCS[clave]) if clave else 0


def _nombre_completo(persona):
    """Alumnos y Empleados: nombre + apellidos."""
    partes = [persona.nombre, persona.apellido_paterno, persona.apellido_materno]
    return ' '.join(p for p in partes if p)


def _iniciales(nombre):
    return ''.join(parte[0] for parte in (nombre or '').split()[:2]).upper()


def _local(fecha):
    return timezone.localtime(fecha) if timezone.is_aware(fecha) else fecha


def _formato(fecha, patron='%d/%m/%Y %H:%M'):
    return _local(fecha).strftime(patron) if fecha else ''


def _estados_actuales():
    """{id_proceso: nombre de la etapa más reciente} en una sola consulta."""
    actuales = {}
    for s in SeguimientoTitulacion.objects.order_by('-fecha_registro', '-pk'):
        actuales.setdefault(s.id_proceso_titulacion_id, s.estado_nuevo)
    return actuales


def _datos_proceso(p, estado='', enviados=0):
    """Convierte un ProcesosTitulacion en el diccionario que usan los templates.

    `estado` es el nombre de la última etapa registrada; el número y el porcentaje
    se calculan con las etapas de la modalidad de ese proceso.
    """
    alumno = p.id_alumno
    modalidad = p.id_modalidad.nombre_modalidad
    nombre = _nombre_completo(alumno) or alumno.matricula or ''

    etapas = etapas_de(modalidad)
    actual = next((e for e in etapas if e['nombre'] == estado), None)

    return {
        'id': p.pk,
        'nombre': nombre,
        'iniciales': _iniciales(nombre),
        'matricula': alumno.matricula,
        'correo': alumno.id_usuario.correo,
        'modalidad': modalidad,
        'docs_enviados': enviados,
        'docs_total': _total_docs_modalidad(modalidad),
        'etapa': actual['numero'] if actual else 0,
        'total_etapas': len(etapas),
        'porcentaje': actual['porcentaje'] if actual else 0,
        'estado': actual['nombre'] if actual else (p.estado_general or 'pendiente'),
    }


def _proceso_queryset():
    return ProcesosTitulacion.objects.select_related('id_alumno__id_usuario', 'id_modalidad')


def _datos_un_proceso(id_proceso):
    """Devuelve (modelo, diccionario) de un proceso, o 404."""
    p = get_object_or_404(_proceso_queryset(), pk=id_proceso)
    ultimo = SeguimientoTitulacion.objects.filter(id_proceso_titulacion=p) \
        .order_by('-fecha_registro', '-pk').first()
    estado = ultimo.estado_nuevo if ultimo else ''
    enviados = DocumentosAlumno.objects.filter(id_proceso_titulacion=p).count()
    return p, _datos_proceso(p, estado=estado, enviados=enviados)


def _proceso_del_alumno(request):
    """Proceso de titulación del alumno en sesión (el de la sesión o el más reciente).

    Siempre verifica que el proceso pertenezca al alumno que inició sesión.
    """
    alumno = Alumnos.objects.filter(id_usuario=request.session.get('id_usuario')).first()
    if not alumno:
        return None

    id_proceso = request.session.get('id_proceso')
    if id_proceso:
        p = ProcesosTitulacion.objects.filter(pk=id_proceso, id_alumno=alumno).first()
        if p:
            return p

    p = ProcesosTitulacion.objects.filter(id_alumno=alumno).order_by('-pk').first()
    if p:
        request.session['id_proceso'] = p.pk
    return p


def _docs_completos(proceso):
    """True si el alumno ya subió todos los documentos de su modalidad."""
    clave = _clave_modalidad(proceso.id_modalidad.nombre_modalidad)
    if not clave:
        return False
    enviados = set(
        DocumentosAlumno.objects
        .filter(id_proceso_titulacion=proceso)
        .values_list('id_tipo_documento__nombre_documento', flat=True)
    )
    return all(nombre in enviados for nombre in DOCS[clave].values())


def inicio(request):
    if request.method == 'POST':
        dato = request.POST.get('usuario', '').strip()
        password = request.POST.get('password', '')

        usuario = Usuario.objects.filter(correo=dato).first()
        if not usuario:
            alumno = Alumnos.objects.filter(matricula=dato).first()
            usuario = alumno.id_usuario if alumno else None

        if usuario and usuario.contrasena == password:
            tipo = (usuario.tipo_usuario or '').strip().lower()

            request.session['id_usuario'] = usuario.id_usuario
            request.session['tipo_usuario'] = tipo
            request.session.pop('id_proceso', None)  
            if tipo == 'empleado':
                return redirect('panel_coordinacion')

            proceso = _proceso_del_alumno(request)
            if proceso and _docs_completos(proceso):
                return redirect('seguimiento')
            return redirect('modalidad')

        return render(request, 'inicio_sesion1.html', {'error': 'Credenciales incorrectas'})

    return render(request, 'inicio_sesion1.html')


def cerrar_sesion(request):
    request.session.flush()
    return redirect('inicio')


def modalidad_view(request):
    if request.session.get('tipo_usuario') != 'alumno':
        return redirect('inicio')

    if request.method == 'GET':
        proceso_actual = _proceso_del_alumno(request)
        if proceso_actual and _docs_completos(proceso_actual):
            return redirect('seguimiento')

    if request.method == 'POST':
        tipo = request.POST.get('modalidad')
        alumno = Alumnos.objects.get(id_usuario=request.session['id_usuario'])
        modalidad = ModalidadesTitulacion.objects.get(nombre_modalidad__icontains=tipo)

        proceso, _ = ProcesosTitulacion.objects.get_or_create(
            id_alumno=alumno,
            id_modalidad=modalidad,
            defaults={'fecha_inicio': timezone.now(), 'estado_general': 'pendiente'},
        )
        request.session['id_proceso'] = proceso.id_proceso_titulacion
        return redirect('documentos', tipo=tipo)

    return render(request, 'modalidad.html')


def documentos(request, tipo):
    if request.session.get('tipo_usuario') != 'alumno':
        return redirect('inicio')

    docs = DOCS.get(tipo)
    if not docs:
        return redirect('modalidad')

    proceso = _proceso_del_alumno(request)
    contexto = {}

    if request.method == 'GET' and proceso and _docs_completos(proceso):
        return redirect('seguimiento')

    if request.method == 'POST':
        if not proceso:
            return redirect('modalidad')

        fs = FileSystemStorage()
        subidos, faltantes, rechazados = [], [], []

        for campo, nombre_doc in docs.items():
            archivo = request.FILES.get(campo)

            if not archivo:
                faltantes.append(nombre_doc)
                continue

            if archivo.size > MAX_MB * 1024 * 1024:
                rechazados.append(f'{nombre_doc} (pesa más de {MAX_MB} MB)')
                continue

            tipo_doc, _ = TiposDocumentos.objects.get_or_create(nombre_documento=nombre_doc)
            ruta = fs.save(f'documentos/{proceso.id_proceso_titulacion}/{archivo.name}', archivo)

            DocumentosAlumno.objects.update_or_create(
                id_proceso_titulacion=proceso,
                id_tipo_documento=tipo_doc,
                defaults={
                    'nombre_archivo': archivo.name,
                    'ruta_archivo': ruta,
                    'fecha_subida': timezone.now(),
                    'estado_revision': 'pendiente',
                },
            )
            subidos.append(nombre_doc)

        contexto.update({'subidos': subidos, 'faltantes': faltantes, 'rechazados': rechazados})

        if subidos and not faltantes and not rechazados:
            contexto['exito'] = 'Documentos enviados correctamente.'
        elif subidos:
            contexto['advertencia'] = 'Se enviaron algunos documentos, pero todavía faltan otros.'
        else:
            contexto['error'] = 'No se envió ningún documento. Selecciona al menos un archivo.'

        if _docs_completos(proceso):
            messages.success(
                request,
                'Documentos enviados correctamente. Aquí verás la revisión de tu coordinador.',
            )
            return redirect('seguimiento')

    enviados = set()
    if proceso:
        enviados = set(
            DocumentosAlumno.objects
            .filter(id_proceso_titulacion=proceso)
            .values_list('id_tipo_documento__nombre_documento', flat=True)
        )
    contexto['estado'] = {campo: nombre in enviados for campo, nombre in docs.items()}
    contexto['total_enviados'] = sum(contexto['estado'].values())
    contexto['total_docs'] = len(docs)

    return render(request, f'documentos_{tipo}.html', contexto)


def panel_coordinacion(request):
    if request.session.get('tipo_usuario') != 'empleado':
        return redirect('inicio')

    q = request.GET.get('q', '').strip()
    estado_filtro = request.GET.get('estado', '').strip()

    qs = _proceso_queryset()
    if q:
        qs = qs.filter(
            Q(id_alumno__matricula__icontains=q) |
            Q(id_alumno__nombre__icontains=q) |
            Q(id_alumno__apellido_paterno__icontains=q) |
            Q(id_alumno__apellido_materno__icontains=q)
        )

    enviados_por_proceso = {
        fila['id_proceso_titulacion']: fila['n']
        for fila in DocumentosAlumno.objects
        .values('id_proceso_titulacion')
        .annotate(n=Count('pk'))
    }
    estados_actuales = _estados_actuales()

    procesos = []
    for p in qs:
        datos = _datos_proceso(
            p,
            estado=estados_actuales.get(p.pk, ''),
            enviados=enviados_por_proceso.get(p.pk, 0),
        )
        if estado_filtro and datos['estado'].lower() != estado_filtro.lower():
            continue
        procesos.append(datos)

    estados = ['pendiente'] + [n.lower() for n in TODOS_LOS_ESTADOS]

    resumen = {
        'total': len(procesos),
        'por_revisar': DocumentosAlumno.objects.filter(estado_revision='pendiente').count(),
        'completados': sum(
            1 for p in procesos if p['etapa'] and p['etapa'] == p['total_etapas']
        ),
    }

    return render(request, 'panel_coordinacion.html', {
        'procesos': procesos,
        'resumen': resumen,
        'q': q,
        'estados': estados,
        'estado_filtro': estado_filtro,
    })


def _correo_valido(correo):
    try:
        validate_email(correo)
        return True
    except ValidationError:
        return False


def registrar_alumno(request):
    if request.session.get('tipo_usuario') != 'empleado':
        return redirect('inicio')

    datos = {}
    error = ''

    if request.method == 'POST':
        campos = ('nombre', 'apellido_paterno', 'apellido_materno', 'matricula', 'correo')
        datos = {c: request.POST.get(c, '').strip() for c in campos}
        password = request.POST.get('password', '').strip()

        if not (datos['nombre'] and datos['apellido_paterno'] and datos['matricula']
                and datos['correo'] and password):
            error = 'Completa los campos obligatorios.'
        elif not _correo_valido(datos['correo']):
            error = 'El correo no tiene un formato válido.'
        elif Usuario.objects.filter(correo__iexact=datos['correo']).exists():
            error = 'Ya existe un usuario con ese correo.'
        elif Alumnos.objects.filter(matricula=datos['matricula']).exists():
            error = 'Ya existe un alumno con esa matrícula.'
        else:
            with transaction.atomic():
                usuario = Usuario.objects.create(
                    correo=datos['correo'],
                    contrasena=password,
                    tipo_usuario='alumno',
                    estatus='activo',
                    fecha_registro=timezone.now(),
                )
                Alumnos.objects.create(
                    id_usuario=usuario,
                    matricula=datos['matricula'],
                    nombre=datos['nombre'],
                    apellido_paterno=datos['apellido_paterno'],
                    apellido_materno=datos['apellido_materno'] or None,
                    estatus_academico='activo',
                )

    return render(request, 'registrar_alumno.html', {'datos': datos, 'error': error})


def detalle_proceso(request, id_proceso):
    if request.session.get('tipo_usuario') != 'empleado':
        return redirect('inicio')

    p, proceso = _datos_un_proceso(id_proceso)
    
    etapas = etapas_de(proceso['modalidad'])
    nombre_por_numero = {e['numero']: e['nombre'] for e in etapas}
    numero_por_nombre = {e['nombre']: e['numero'] for e in etapas}

    if request.method == 'POST':
        try:
            etapa = int(request.POST.get('etapa', 0))
        except ValueError:
            etapa = 0
        comentario = request.POST.get('comentario', '').strip()

        if etapa in nombre_por_numero:
            SeguimientoTitulacion.objects.create(
                id_proceso_titulacion=p,
                estado_anterior=nombre_por_numero.get(proceso['etapa'], 'Pendiente'),
                estado_nuevo=nombre_por_numero[etapa],
                comentario=comentario,
                id_usuario_id=request.session['id_usuario'],
                fecha_registro=timezone.now(),
            )
            messages.success(request, 'Avance registrado correctamente.')
        else:
            messages.error(request, 'Selecciona una etapa válida.')
        return redirect('detalle_proceso', id_proceso=id_proceso)

    registros = list(
        SeguimientoTitulacion.objects
        .filter(id_proceso_titulacion=p)
        .order_by('-fecha_registro', '-pk')
    )
    autores = {
        e.id_usuario_id: _nombre_completo(e)
        for e in Empleados.objects.filter(id_usuario__in=[r.id_usuario_id for r in registros])
    }
    historial = []
    for h in registros:
        numero = numero_por_nombre.get(h.estado_nuevo)
        historial.append({
            'fecha': _formato(h.fecha_registro),
            'etapa': f'{numero}. {h.estado_nuevo}' if numero else (h.estado_nuevo or ''),
            'comentario': h.comentario,
            'autor': autores.get(h.id_usuario_id, ''),
        })

    return render(request, 'detalle_proceso.html', {
        'proceso': proceso,
        'etapas': etapas,
        'historial': historial,
    })


def ver_documentos(request, id_proceso):
    if request.session.get('tipo_usuario') != 'empleado':
        return redirect('inicio')

    p, proceso = _datos_un_proceso(id_proceso)

    if request.method == 'POST':
        accion = request.POST.get('accion')
        id_doc = request.POST.get('id_documento', '')
        doc = DocumentosAlumno.objects.filter(
            pk=id_doc, id_proceso_titulacion=p,
        ).first() if id_doc.isdigit() else None

        if doc and accion in ('aprobado', 'rechazado'):
            doc.estado_revision = accion
            doc.save(update_fields=['estado_revision'])

            observacion = request.POST.get('observaciones', '').strip()
            if observacion:
                empleado = Empleados.objects.filter(id_usuario=request.session['id_usuario']).first()
                if empleado:
                    ObservacionesDocumentos.objects.create(
                        id_documento_alumno=doc,
                        id_empleado=empleado,
                        observacion=observacion,
                        fecha_observacion=timezone.now(),
                    )
                else:
                    messages.warning(request, 'Tu usuario no tiene registro de empleado; la observación no se guardó.')
            messages.success(request, f'Documento {accion} correctamente.')
        else:
            messages.error(request, 'No se pudo actualizar el documento.')
        return redirect('ver_documentos', id_proceso=id_proceso)

    fs = FileSystemStorage()
    registros = list(
        DocumentosAlumno.objects
        .filter(id_proceso_titulacion=p)
        .select_related('id_tipo_documento')
        .order_by('id_tipo_documento__nombre_documento')
    )

    ultima_observacion = {}
    for o in (ObservacionesDocumentos.objects
              .filter(id_documento_alumno__in=registros)
              .order_by('fecha_observacion', 'pk')):
        ultima_observacion[o.id_documento_alumno_id] = o.observacion

    lista = [
        {
            'id': d.pk,
            'tipo': d.id_tipo_documento.nombre_documento,
            'nombre_archivo': d.nombre_archivo,
            'url': fs.url(d.ruta_archivo) if d.ruta_archivo else '',
            'fecha': _formato(d.fecha_subida),
            'estado': d.estado_revision or 'pendiente',
            'observaciones': ultima_observacion.get(d.pk, ''),
        }
        for d in registros
    ]

    clave = _clave_modalidad(proceso['modalidad'])
    enviados = {d['tipo'] for d in lista}
    faltantes = [n for n in DOCS[clave].values() if n not in enviados] if clave else []

    resumen = {
        'total': proceso['docs_total'] or len(lista),
        'aprobados': sum(1 for d in lista if d['estado'].lower() == 'aprobado'),
    }

    return render(request, 'ver_documentos.html', {
        'proceso': proceso,
        'documentos': lista,
        'resumen': resumen,
        'faltantes': faltantes,
    })


def chat_coordinacion(request, id_proceso):
    if request.session.get('tipo_usuario') != 'empleado':
        return redirect('inicio')

    p, proceso = _datos_un_proceso(id_proceso)

    if request.method == 'POST':
        texto = request.POST.get('mensaje', '').strip()
        if texto:
            MensajesProceso.objects.create(
                id_proceso_titulacion=p,
                autor='coordinacion',
                texto=texto,
                fecha=timezone.now(),
            )
        return redirect('chat_coordinacion', id_proceso=id_proceso)

    mensajes = [
        {
            'autor': m.autor,
            'texto': m.texto,
            'fecha': _formato(m.fecha, '%d/%m/%Y'),
            'hora': _formato(m.fecha, '%H:%M'),
        }
        for m in MensajesProceso.objects.filter(id_proceso_titulacion=p).order_by('fecha', 'pk')
    ]

    return render(request, 'chat_coordinacion.html', {
        'proceso': proceso,
        'mensajes': mensajes,
    })


def seguimiento(request):
    """Pantalla del alumno: avance, comentarios del coordinador y estado de cada documento."""
    if request.session.get('tipo_usuario') != 'alumno':
        return redirect('inicio')

    proceso = _proceso_del_alumno(request)
    if not proceso:
        return redirect('modalidad')


    if not _docs_completos(proceso):
        clave = _clave_modalidad(proceso.id_modalidad.nombre_modalidad)
        return redirect('documentos', tipo=clave) if clave else redirect('modalidad')


    if request.method == 'POST':
        texto = request.POST.get('mensaje', '').strip()
        if texto:
            MensajesProceso.objects.create(
                id_proceso_titulacion=proceso,
                autor='alumno',
                texto=texto,
                fecha=timezone.now(),
            )
        return redirect(f"{reverse('seguimiento')}#seccion-chat")

    p, datos = _datos_un_proceso(proceso.pk)
    etapas = etapas_de(datos['modalidad'])


    fs = FileSystemStorage()
    registros = list(
        DocumentosAlumno.objects
        .filter(id_proceso_titulacion=p)
        .select_related('id_tipo_documento')
        .order_by('id_tipo_documento__nombre_documento')
    )
    ultima_observacion = {}
    for o in (ObservacionesDocumentos.objects
              .filter(id_documento_alumno__in=registros)
              .order_by('fecha_observacion', 'pk')):
        ultima_observacion[o.id_documento_alumno_id] = o.observacion

    documentos_lista = []
    for d in registros:
        estado = (d.estado_revision or 'pendiente').lower()
        documentos_lista.append({
            'id': d.pk,
            'tipo': d.id_tipo_documento.nombre_documento,
            'nombre_archivo': d.nombre_archivo,
            'url': fs.url(d.ruta_archivo) if d.ruta_archivo else '',
            'fecha': _formato(d.fecha_subida),
            'estado': estado,
            'observacion': ultima_observacion.get(d.pk, '') if estado != 'pendiente' else '',
            'puede_reenviar': estado == 'rechazado',
        })

    resumen = {
        'total': len(documentos_lista),
        'aprobados': sum(1 for d in documentos_lista if d['estado'] == 'aprobado'),
        'rechazados': sum(1 for d in documentos_lista if d['estado'] == 'rechazado'),
    }


    avances = list(
        SeguimientoTitulacion.objects
        .filter(id_proceso_titulacion=p)
        .exclude(comentario__isnull=True).exclude(comentario='')
        .order_by('-fecha_registro', '-pk')
    )
    autores = {
        e.id_usuario_id: _nombre_completo(e)
        for e in Empleados.objects.filter(id_usuario__in=[a.id_usuario_id for a in avances])
    }
    comentarios = [
        {
            'fecha': _formato(a.fecha_registro),
            'etapa': a.estado_nuevo or '',
            'comentario': a.comentario,
            'autor': autores.get(a.id_usuario_id, ''),
        }
        for a in avances
    ]


    mensajes = [
        {
            'autor': m.autor,
            'texto': m.texto,
            'fecha': _formato(m.fecha, '%d/%m/%Y'),
            'hora': _formato(m.fecha, '%H:%M'),
        }
        for m in MensajesProceso.objects.filter(id_proceso_titulacion=p).order_by('fecha', 'pk')
    ]

    return render(request, 'seguimiento_alumno.html', {
        'proceso': datos,
        'mensajes': mensajes,
        'etapas': etapas,
        'documentos': documentos_lista,
        'resumen': resumen,
        'comentarios': comentarios,
        'max_mb': MAX_MB,
    })


def reenviar_documento(request):
    """El alumno vuelve a subir solo un documento rechazado, sin tocar los demás."""
    if request.session.get('tipo_usuario') != 'alumno':
        return redirect('inicio')
    if request.method != 'POST':
        return redirect('seguimiento')

    proceso = _proceso_del_alumno(request)
    id_doc = request.POST.get('id_documento', '')
    archivo = request.FILES.get('archivo')

    doc = None
    if proceso and id_doc.isdigit():
        doc = DocumentosAlumno.objects.filter(
            pk=id_doc, id_proceso_titulacion=proceso,
        ).select_related('id_tipo_documento').first()

    if not doc:
        messages.error(request, 'No se encontró el documento.')
    elif (doc.estado_revision or '').lower() != 'rechazado':
        messages.error(request, 'Solo puedes volver a subir los documentos rechazados.')
    elif not archivo:
        messages.error(request, 'Selecciona un archivo para volver a subir el documento.')
    elif archivo.size > MAX_MB * 1024 * 1024:
        messages.error(request, f'El archivo pesa más de {MAX_MB} MB.')
    else:
        fs = FileSystemStorage()
        ruta = fs.save(f'documentos/{proceso.pk}/{archivo.name}', archivo)
        doc.nombre_archivo = archivo.name
        doc.ruta_archivo = ruta
        doc.fecha_subida = timezone.now()
        doc.estado_revision = 'pendiente'
        doc.save(update_fields=['nombre_archivo', 'ruta_archivo', 'fecha_subida', 'estado_revision'])
        messages.success(
            request,
            f'«{doc.id_tipo_documento.nombre_documento}» se envió de nuevo y quedó pendiente de revisión.',
        )

    return redirect('seguimiento')