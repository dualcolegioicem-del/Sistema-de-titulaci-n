# This is an auto-generated Django model module.
# You'll have to do the following manually to clean this up:
#   * Rearrange models' order
#   * Make sure each model has one field with primary_key=True
#   * Make sure each ForeignKey and OneToOneField has `on_delete` set to the desired behavior
#   * Remove `managed = False` lines if you wish to allow Django to create, modify, and delete the table
# Feel free to rename the models, but don't rename db_table values or field names.
from django.db import models


class Alumnos(models.Model):
    id_alumno = models.AutoField(primary_key=True)
    id_usuario = models.ForeignKey('Usuario', models.DO_NOTHING, db_column='id_usuario')
    matricula = models.CharField(unique=True, max_length=30, blank=True, null=True)
    apellido_paterno = models.CharField(max_length=80, blank=True, null=True)
    apellido_materno = models.CharField(max_length=80, blank=True, null=True)
    nombre = models.CharField(max_length=80, blank=True, null=True)
    estatus_academico = models.CharField(max_length=8, blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'alumnos'


class Areas(models.Model):
    id_area = models.AutoField(primary_key=True)
    nombre_area = models.CharField(max_length=100)
    descripcion = models.TextField(blank=True, null=True)
    estatus = models.CharField(max_length=8, blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'areas'


class DocumentosAlumno(models.Model):
    id_documento_alumno = models.AutoField(primary_key=True)
    id_proceso_titulacion = models.ForeignKey('ProcesosTitulacion', models.DO_NOTHING, db_column='id_proceso_titulacion')
    id_tipo_documento = models.ForeignKey('TiposDocumentos', models.DO_NOTHING, db_column='id_tipo_documento')
    nombre_archivo = models.CharField(max_length=255, blank=True, null=True)
    ruta_archivo = models.CharField(max_length=255, blank=True, null=True)
    fecha_subida = models.DateTimeField(blank=True, null=True)
    estado_revision = models.CharField(max_length=11, blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'documentos_alumno'


class DocumentosRequeridosModalidad(models.Model):
    id_documento_requerido = models.AutoField(primary_key=True)
    id_modalidad = models.ForeignKey('ModalidadesTitulacion', models.DO_NOTHING, db_column='id_modalidad')
    id_tipo_documento = models.ForeignKey('TiposDocumentos', models.DO_NOTHING, db_column='id_tipo_documento')
    obligatorio = models.IntegerField(blank=True, null=True)
    orden_visualizacion = models.IntegerField(blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'documentos_requeridos_modalidad'


class Empleados(models.Model):
    id_empleado = models.AutoField(primary_key=True)
    id_usuario = models.ForeignKey('Usuario', models.DO_NOTHING, db_column='id_usuario')
    id_area = models.ForeignKey(Areas, models.DO_NOTHING, db_column='id_area')
    nombre = models.CharField(max_length=80, blank=True, null=True)
    apellido_paterno = models.CharField(max_length=80, blank=True, null=True)
    apellido_materno = models.CharField(max_length=80, blank=True, null=True)
    telefono = models.CharField(max_length=20, blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'empleados'


class ModalidadesTitulacion(models.Model):
    id_modalidad = models.AutoField(primary_key=True)
    id_area = models.ForeignKey(Areas, models.DO_NOTHING, db_column='id_area')
    nombre_modalidad = models.CharField(max_length=120, blank=True, null=True)
    descripcion = models.TextField(blank=True, null=True)
    requisitos = models.TextField(blank=True, null=True)
    estatus = models.CharField(max_length=8, blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'modalidades_titulacion'


class ObservacionesDocumentos(models.Model):
    id_observacion = models.AutoField(primary_key=True)
    id_documento_alumno = models.ForeignKey(DocumentosAlumno, models.DO_NOTHING, db_column='id_documento_alumno')
    id_empleado = models.ForeignKey(Empleados, models.DO_NOTHING, db_column='id_empleado')
    observacion = models.TextField()
    fecha_observacion = models.DateTimeField(blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'observaciones_documentos'


class ProcesosTitulacion(models.Model):
    id_proceso_titulacion = models.AutoField(primary_key=True)
    id_alumno = models.ForeignKey(Alumnos, models.DO_NOTHING, db_column='id_alumno')
    id_modalidad = models.ForeignKey(ModalidadesTitulacion, models.DO_NOTHING, db_column='id_modalidad')
    fecha_inicio = models.DateTimeField(blank=True, null=True)
    estado_general = models.CharField(max_length=11, blank=True, null=True)
    observaciones_generales = models.TextField(blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'procesos_titulacion'


class SeguimientoTitulacion(models.Model):
    id_seguimiento = models.AutoField(primary_key=True)
    id_proceso_titulacion = models.ForeignKey(ProcesosTitulacion, models.DO_NOTHING, db_column='id_proceso_titulacion')
    estado_anterior = models.CharField(max_length=50, blank=True, null=True)
    estado_nuevo = models.CharField(max_length=50, blank=True, null=True)
    comentario = models.TextField(blank=True, null=True)
    id_usuario = models.ForeignKey('Usuario', models.DO_NOTHING, db_column='id_usuario')
    fecha_registro = models.DateTimeField(blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'seguimiento_titulacion'


class TiposDocumentos(models.Model):
    id_tipo_documento = models.AutoField(primary_key=True)
    nombre_documento = models.CharField(max_length=150)
    descripcion = models.TextField(blank=True, null=True)
    formato_permitido = models.CharField(max_length=100, blank=True, null=True)
    tamano_maximo_mb = models.DecimalField(max_digits=5, decimal_places=2, blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'tipos_documentos'


class Usuario(models.Model):
    id_usuario = models.AutoField(primary_key=True)
    correo = models.CharField(unique=True, max_length=120)
    contrasena = models.CharField(max_length=255)
    tipo_usuario = models.CharField(max_length=8, blank=True, null=True)
    estatus = models.CharField(max_length=8, blank=True, null=True)
    fecha_registro = models.DateTimeField(blank=True, null=True)
    ultimo_acceso = models.DateTimeField(blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'usuario'


class MensajesProceso(models.Model):
    id_mensaje = models.AutoField(primary_key=True)
    id_proceso_titulacion = models.ForeignKey('ProcesosTitulacion', models.DO_NOTHING, db_column='id_proceso_titulacion')
    autor = models.CharField(max_length=20)
    texto = models.TextField()
    fecha = models.DateTimeField(blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'mensajes_proceso'