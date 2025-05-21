from django import forms
from .models import Aviz


class AvizForm(forms.ModelForm):
    class Meta:
        model = Aviz
        fields = '__all__'

    def clean_year_of_construction(self):
        year_of_construction = self.cleaned_data['year_of_construction']
        if year_of_construction < 1360 or year_of_construction > 1404:
            raise forms.ValidationError('سال ساخت باید بین 1360 و 1404 باشد.')
        return year_of_construction