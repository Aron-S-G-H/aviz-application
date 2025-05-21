from . import views
from rest_framework.routers import SimpleRouter

app_name = 'add'

router = SimpleRouter()
router.register('category', views.CategoryViewSet, basename='category')
router.register('aviz', views.AvizViewSet, basename='aviz')

urlpatterns = router.urls
