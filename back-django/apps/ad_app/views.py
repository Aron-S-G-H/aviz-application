from .models import Category, Aviz, AvizPoster, AvizFacilities, SubCategory
from .serializer import CategorySerializer, SubCategorySerializer, AvizSerializer, AvizFacilitiesSerializer, \
    CreateAvizSerializer
from rest_framework.viewsets import ViewSet
from rest_framework import status
from django.db.models import Prefetch
from rest_framework.decorators import action
from rest_framework.response import Response
from rest_framework.exceptions import APIException
from drf_spectacular.utils import extend_schema, OpenApiParameter
from rest_framework.permissions import IsAuthenticated

from .service import create_aviz


@extend_schema(tags=['Category'])
class CategoryViewSet(ViewSet):
    permission_classes = [IsAuthenticated]
    def list(self, request):
        queryset = Category.objects.all()
        serializer = CategorySerializer(queryset, many=True)
        return Response(serializer.data, status=status.HTTP_200_OK)

    @action(detail=True, methods=['get'], url_path='subcategory')
    def retrieve_subcategories(self, request, pk=None):
        sub_categories = SubCategory.objects.filter(general_category_id=pk)
        serializer = SubCategorySerializer(sub_categories, many=True)
        return Response(serializer.data, status=status.HTTP_200_OK)


@extend_schema(tags=['Aviz'])
class AvizViewSet(ViewSet):
    @extend_schema(operation_id="api_ad_avizs_list")
    def list(self, request):
        queryset = Aviz.objects.prefetch_related(
            Prefetch('posters', queryset=AvizPoster.objects.only('poster'))
        ).all()

        if request.query_params.get('hot') == 'true':
            queryset = queryset.filter(is_hot=True)
        if request.query_params.get('recent') == 'true':
            queryset = queryset[:10]
        if request.query_params.get('search'):
            queryset = queryset.filter(title__icontains=request.query_params.get('search'))

        serializer = AvizSerializer(queryset, many=True, context={'request': request, 'is_list': True})
        return Response(serializer.data, status=status.HTTP_200_OK)

    @extend_schema(operation_id="api_ad_avizs_retrieve")
    def retrieve(self, request, pk=None):
        queryset = Aviz.objects.get(id=pk)
        serializer = AvizSerializer(queryset, context={'request': request, 'is_list': False})
        return Response(serializer.data, status=status.HTTP_200_OK)

    @action(detail=False, methods=['get'], url_path='facility')
    def get_facilities(self, request):
        queryset = AvizFacilities.objects.all()
        serializer = AvizFacilitiesSerializer(queryset, many=True)
        return Response(serializer.data, status=status.HTTP_200_OK)

    @extend_schema(
        operation_id="api_ad_avizs_search",
        parameters=[
            OpenApiParameter(name='search', type=str, description='Search by title', required=True),
        ]
    )
    @action(detail=False, methods=['get'], url_path='search')
    def search(self, request):
        search_query = request.query_params.get('search')
        if not search_query:
            return Response([], status=status.HTTP_200_OK)

        queryset = Aviz.objects.prefetch_related(
            Prefetch('posters', queryset=AvizPoster.objects.only('poster'))
        ).filter(title__icontains=search_query)

        serializer = AvizSerializer(queryset, many=True, context={'request': request, 'is_list': True})
        return Response(serializer.data, status=status.HTTP_200_OK)

    def create(self, request):
        create_serializer = CreateAvizSerializer(data=request.data)
        if create_serializer.is_valid(raise_exception=True):
            data = create_serializer.validated_data
            print(data)
            try:
                create_aviz(data)
                return Response({'message': 'aviz created'}, status=status.HTTP_201_CREATED)
            except Exception as e:
                print(e)
        return Response({'message': 'aviz creation failed'}, status=status.HTTP_400_BAD_REQUEST)