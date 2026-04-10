from django.contrib import admin
from django.urls import path, include
from django.conf import settings
from django.conf.urls.static import static
from django.http import HttpResponse

def home_view(request):
    return HttpResponse("<h1>WayToFresh API is running!</h1><p>Visit <a href='/admin/'>/admin/</a> for the Dashboard or <a href='/api/home/'>/api/home/</a> for the endpoints.</p>")

urlpatterns = [
    path('', home_view, name='root_home'),
    path('admin/', admin.site.urls),
    path('api/', include('api.urls')),
] + static(settings.MEDIA_URL, document_root=settings.MEDIA_ROOT)

# Admin site customization
admin.site.site_header = "WayToFresh Admin"
admin.site.site_title = "WayToFresh Portal"
admin.site.index_title = "Welcome to WayToFresh Admin Dashboard"
