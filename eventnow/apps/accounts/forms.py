from django import forms
from apps.accounts.models import User


class SignUpForm(forms.Form):
    ROLE_CHOICES = [
        ('organiser', 'I am an organiser'),
        ('attendee', 'I am an attendee'),
    ]

    first_name = forms.CharField(label='First Name', max_length=255, required=True)
    last_name = forms.CharField(label='Last Name', max_length=255, required=True)
    role = forms.ChoiceField(
        choices=ROLE_CHOICES,
        widget=forms.RadioSelect,
        initial='attendee',
    )

    field_order = ['first_name', 'last_name', 'username', 'email', 'password1', 'password2', 'role']

    def signup(self, request, user):
        user.first_name = self.cleaned_data['first_name']
        user.last_name = self.cleaned_data['last_name']
        user.username = self.cleaned_data['username']
        user.role = self.cleaned_data['role']
        user.save()


class ProfileEditForm(forms.ModelForm):
    class Meta:
        model = User
        fields = ['first_name', 'last_name', 'username', 'avatar_url']
