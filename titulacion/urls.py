from django.conf import settings
from django.conf.urls.static import static
from django.urls import path
from . import views

urlpatterns = [
    path('', views.inicio, name='inicio'),
    path('cerrar-sesion/', views.cerrar_sesion, name='cerrar_sesion'),
    path('modalidad/', views.modalidad_view, name='modalidad'),
    path('documentos/<str:tipo>/', views.documentos, name='documentos'),
    path('seguimiento/', views.seguimiento, name='seguimiento'),
    path('seguimiento/reenviar/', views.reenviar_documento, name='reenviar_documento'),
    path('documentos-alumno/<int:id_proceso>/', views.ver_documentos, name='ver_documentos'),
    path('panel-coordinacion/', views.panel_coordinacion, name='panel_coordinacion'),
    path('proceso/<int:id_proceso>/', views.detalle_proceso, name='detalle_proceso'),
    path('chat-coordinacion/<int:id_proceso>/', views.chat_coordinacion, name='chat_coordinacion'),
    path('registrar-alumno/', views.registrar_alumno, name='registrar_alumno'),
]


if settings.DEBUG:
    urlpatterns += static(settings.MEDIA_URL, document_root=settings.MEDIA_ROOT)

