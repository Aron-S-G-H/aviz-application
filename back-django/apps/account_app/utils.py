from .models import CustomUser
from rest_framework_simplejwt.tokens import RefreshToken, AccessToken


def get_tokens(user: CustomUser) -> dict[str, str]:
    access = AccessToken.for_user(user=user)
    refresh = RefreshToken.for_user(user=user)
    return {
        'refresh': str(refresh),
        'access': str(access),
    }
