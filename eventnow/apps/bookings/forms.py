from django import forms

_INPUT = "w-full border border-border rounded-xl px-4 py-3 text-sm text-ink bg-card focus:outline-none focus:ring-2 focus:ring-primary/20 focus:border-primary transition-colors"


class EventRegistrationForm(forms.Form):
    guest_first_name = forms.CharField(
        label='First name',
        max_length=255,
        widget=forms.TextInput(attrs={'class': _INPUT}),
    )
    guest_last_name = forms.CharField(
        label='Last name',
        max_length=255,
        widget=forms.TextInput(attrs={'class': _INPUT}),
    )
    guest_email = forms.EmailField(
        label='Email',
        widget=forms.EmailInput(attrs={'class': _INPUT}),
    )
