from django.utils.crypto import get_random_string
from rest_framework.decorators import action
from rest_framework.viewsets import ViewSet
from rest_framework.response import Response
from rest_framework.exceptions import APIException
from rest_framework.permissions import IsAuthenticated
from rest_framework import status, viewsets
from .serializer import UserSerializer, UserLoginSerializer, UserRegisterSerializer
from drf_spectacular.utils import extend_schema
from rest_framework_simplejwt.views import TokenRefreshView
from django.core.cache import cache
from utils.email import send_verification_code
from .utils import get_tokens
from . import decorators


@extend_schema(tags=['Authentication and Authorization'])
class UserAuthenticationViewSet(ViewSet):
    @decorators.user_login_decorator
    def login(self, request):
        serializer = UserLoginSerializer(data=request.data)
        if serializer.is_valid(raise_exception=True):
            user = serializer.validated_data
            print(user)
            tokens = get_tokens(user)
            return Response({
                **tokens,
                'user': UserSerializer(user).data
            }, status=status.HTTP_200_OK)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

    @decorators.user_register_decorator
    def register(self, request):
        serializer = UserRegisterSerializer(data=request.data)
        if serializer.is_valid(raise_exception=True):
            data = serializer.validated_data
            user_data = {
                'username': data['username'],
                'email': data['email'],
                'password': data['password'],
            }
            verification_code = get_random_string(length=4, allowed_chars='0123456789')
            print(verification_code)
            send_verification_code.apply_async(
                (verification_code, data['email']),
                retry=False,
                ignore_result=True,
                expires=90,
            )
            cache.set(verification_code, user_data, timeout=70)
            return Response({
                'success': True,
                "message": "OTP successfully sent"
            }, status=status.HTTP_200_OK)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

    @decorators.user_verify_register_decorator
    def verify_register(self, request):
        code = request.data.get('code')
        if code and len(code) == 4:
            user_data = cache.get(code)
            if user_data:
                serializer = UserRegisterSerializer()
                user = serializer.create(user_data)
                tokens = get_tokens(user)
                cache.delete(code)
                return Response({
                    **tokens,
                    'user': UserSerializer(user).data
                }, status=status.HTTP_200_OK)
        raise APIException('کد نامعتبر و یا منقضی شده است', code=status.HTTP_400_BAD_REQUEST)

    @decorators.token_refresh_decorator
    def token_refresh(self, request):
        return TokenRefreshView.as_view()(request._request)


@extend_schema(tags=['User'])
class UserViewSet(viewsets.ViewSet):
    permission_classes = [IsAuthenticated]

    @extend_schema(
        operation_id="api_user_info",
        description="Retrieve authenticated user's information",
        responses={200: UserSerializer},
    )
    @action(detail=False, methods=['get'], url_path='info')
    def get_user_info(self, request):
        print(request.user)
        serializer = UserSerializer(request.user, context={'request': request})
        return Response(serializer.data, status=status.HTTP_200_OK)

    @action(detail=False, methods=['patch'], url_path='update-info')
    def update_info(self, request):
        user = request.user
        serializer = UserSerializer(user, data=request.data, partial=True, context={'request': request})
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=status.HTTP_200_OK)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)