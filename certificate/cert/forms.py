from django.forms import ModelForm, MultipleChoiceField, CheckboxSelectMultiple, DateField
from cert.models import AffiliateManager
from cert.settings import STATES
from .settings import DATE_INPUT_FORMATS


class AffiliateManagerForm(ModelForm):
    last_contact = DateField(input_formats=DATE_INPUT_FORMATS)

    class Meta:
        model = AffiliateManager
        fields = '__all__'
