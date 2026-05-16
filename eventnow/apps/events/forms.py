from django import forms
from django.utils.text import slugify

from apps.events.models import Event, Track, Session, Venue

# Shared Tailwind input classes
_INPUT  = "w-full border border-border rounded-xl px-4 py-3 text-sm text-ink bg-card focus:outline-none focus:ring-2 focus:ring-primary/20 focus:border-primary transition-colors"
_SELECT = "w-full border border-border rounded-xl px-4 py-3 text-sm text-ink bg-card focus:outline-none focus:ring-2 focus:ring-primary/20 focus:border-primary transition-colors"
_AREA   = "w-full border border-border rounded-xl px-4 py-3 text-sm text-ink bg-card focus:outline-none focus:ring-2 focus:ring-primary/20 focus:border-primary transition-colors resize-none"

STATUS_CHOICES = [
    ('draft',     'Draft'),
    ('published', 'Published'),
    ('cancelled', 'Cancelled'),
    ('completed', 'Completed'),
]


class EventForm(forms.ModelForm):
    status = forms.ChoiceField(
        choices=STATUS_CHOICES,
        initial='draft',
        widget=forms.Select(attrs={'class': _SELECT}),
    )

    class Meta:
        model  = Event
        fields = [
            'title', 'slug', 'description', 'venue',
            'cover_image_url', 'starts_at', 'ends_at',
            'status', 'max_capacity',
        ]
        widgets = {
            'title':           forms.TextInput(attrs={'class': _INPUT}),
            'slug':            forms.TextInput(attrs={'class': _INPUT, 'placeholder': 'auto-filled from title'}),
            'description':     forms.Textarea(attrs={'class': _AREA, 'rows': 4}),
            'venue':           forms.Select(attrs={'class': _SELECT}),
            'cover_image_url': forms.URLInput(attrs={'class': _INPUT, 'placeholder': 'https://...'}),
            'starts_at':       forms.DateTimeInput(
                attrs={'class': _INPUT, 'type': 'datetime-local'},
                format='%Y-%m-%dT%H:%M',
            ),
            'ends_at': forms.DateTimeInput(
                attrs={'class': _INPUT, 'type': 'datetime-local'},
                format='%Y-%m-%dT%H:%M',
            ),
            'max_capacity': forms.NumberInput(attrs={'class': _INPUT, 'min': 1}),
        }

    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)
        self.fields['slug'].required = False
        self.fields['cover_image_url'].required = False
        self.fields['starts_at'].input_formats = ['%Y-%m-%dT%H:%M']
        self.fields['ends_at'].input_formats   = ['%Y-%m-%dT%H:%M']
        self.fields['venue'].empty_label = 'Select a venue'

    def save(self, commit=True):
        instance = super().save(commit=False)
        if not instance.slug:
            instance.slug = slugify(instance.title)
        if commit:
            instance.save()
        return instance


class TrackForm(forms.ModelForm):
    class Meta:
        model  = Track
        fields = ['name', 'description']
        widgets = {
            'name':        forms.TextInput(attrs={'class': _INPUT}),
            'description': forms.Textarea(attrs={'class': _AREA, 'rows': 3}),
        }


class SessionForm(forms.ModelForm):
    class Meta:
        model  = Session
        fields = [
            'track', 'title', 'description',
            'speaker_name', 'room',
            'starts_at', 'ends_at', 'max_capacity',
        ]
        widgets = {
            'track':        forms.Select(attrs={'class': _SELECT}),
            'title':        forms.TextInput(attrs={'class': _INPUT}),
            'description':  forms.Textarea(attrs={'class': _AREA, 'rows': 3}),
            'speaker_name': forms.TextInput(attrs={'class': _INPUT}),
            'room':         forms.TextInput(attrs={'class': _INPUT}),
            'starts_at':    forms.DateTimeInput(
                attrs={'class': _INPUT, 'type': 'datetime-local'},
                format='%Y-%m-%dT%H:%M',
            ),
            'ends_at': forms.DateTimeInput(
                attrs={'class': _INPUT, 'type': 'datetime-local'},
                format='%Y-%m-%dT%H:%M',
            ),
            'max_capacity': forms.NumberInput(attrs={'class': _INPUT, 'min': 1}),
        }

    def __init__(self, event, *args, **kwargs):
        super().__init__(*args, **kwargs)
        self.fields['track'].queryset      = Track.objects.filter(event=event)
        self.fields['starts_at'].input_formats = ['%Y-%m-%dT%H:%M']
        self.fields['ends_at'].input_formats   = ['%Y-%m-%dT%H:%M']
