from drf_spectacular.utils import extend_schema, OpenApiExample, OpenApiParameter, OpenApiTypes
from . import serializer
# from utils.custom_decorator import custom_decorator


genre_list_decorator = extend_schema(
    responses=serializer.CategorySerializer(many=True),
    methods=['GET'],
    summary='List of Ads general categories',
)
