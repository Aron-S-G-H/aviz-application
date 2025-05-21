from . import views
from rest_framework.routers import SimpleRouter

app_name = 'account'

router = SimpleRouter()
router.register('auth', views.UserAuthenticationViewSet, basename='category')
router.register('user', views.UserViewSet, basename='user')

urlpatterns = router.urls
