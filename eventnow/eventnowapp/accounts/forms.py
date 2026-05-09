from django import forms
from allauth.account.forms import SignupForm

class SignUpForm(SignupForm):
    ROLE_CHOICES = [
        ('Organiser', 'I am an organiser'),
        ('Attendee', 'I am an attendee'),
    ]

    first_name = forms.CharField(label='First Name', max_length=255, required=True)
    last_name = forms.CharField(label='Last Name', max_length=255, required=True)
    username = forms.CharField(label='Username', max_length=100, required=True)
    role = forms.ChoiceField(
        choices=ROLE_CHOICES,
        widget=forms.RadioSelect,
        initial='Attendee',
    )

    field_order = ['first_name', 'last_name', 'username', 'email', 'password1', 'password2', 'role']

    def save(self, request):
        user = super().save(request)
        user.first_name = self.cleaned_data['first_name']
        user.last_name = self.cleaned_data['last_name']
        user.username = self.cleaned_data['username']
        user.role = self.cleaned_data['role']
        user.save()
        return user