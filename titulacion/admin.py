from django.contrib import admin
from .models import Alumnos, Areas, DocumentosAlumno, DocumentosRequeridosModalidad, Empleados, ModalidadesTitulacion, ObservacionesDocumentos, ProcesosTitulacion, SeguimientoTitulacion, TiposDocumentos, Usuario

# Register your models here.
admin.site.register(Alumnos)
admin.site.register(Areas)
admin.site.register(DocumentosAlumno)
admin.site.register(DocumentosRequeridosModalidad)
admin.site.register(Empleados)
admin.site.register(ModalidadesTitulacion)
admin.site.register(ObservacionesDocumentos)
admin.site.register(ProcesosTitulacion)
admin.site.register(SeguimientoTitulacion)
admin.site.register(TiposDocumentos)
admin.site.register(Usuario)