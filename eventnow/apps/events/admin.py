from django.contrib import admin
from apps.events.models import Venue, Event, Track, Session


@admin.register(Venue)
class VenueAdmin(admin.ModelAdmin):
    list_display  = ('name', 'city', 'country', 'address')
    search_fields = ('name', 'city', 'country')
    ordering      = ('name',)


@admin.register(Event)
class EventAdmin(admin.ModelAdmin):
    list_display  = ('title', 'organiser', 'status', 'starts_at', 'venue')
    list_filter   = ('status',)
    search_fields = ('title', 'slug')
    prepopulated_fields = {'slug': ('title',)}


@admin.register(Track)
class TrackAdmin(admin.ModelAdmin):
    list_display  = ('name', 'event')
    search_fields = ('name',)


@admin.register(Session)
class SessionAdmin(admin.ModelAdmin):
    list_display  = ('title', 'event', 'track', 'speaker_name', 'starts_at')
    list_filter   = ('event',)
    search_fields = ('title', 'speaker_name')
