from django.contrib import admin
from .models import Category, SubCategory, AvizFacilities, Aviz, AvizPoster
from .forms import AvizForm

admin.site.register(Category)
admin.site.register(AvizFacilities)


@admin.register(SubCategory)
class SubCategoryAdmin(admin.ModelAdmin):
    list_display = ('title', 'general_category', 'parent_category')
    list_filter = ('general_category',)
    search_fields = ('title', 'general_category__title')


class AvizPosterAdmin(admin.StackedInline):
    model = AvizPoster
    readonly_fields = ('poster_width', 'poster_height', 'size')
    extra = 1


@admin.register(Aviz)
class AvizAdmin(admin.ModelAdmin):
    inlines = [AvizPosterAdmin]
    form = AvizForm
    readonly_fields = ['created_at']
    filter_horizontal = ['facilities']
    # search_fields = ('title', 'subcategory__title', 'subcategory__general_category__title')
    autocomplete_fields = ['category']
