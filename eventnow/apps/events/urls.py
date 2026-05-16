from django.urls import path
from . import views

urlpatterns = [
    # Landing Page
    path('',                            views.index,            name='index'),              # Done

    # Public Event Page
    path('events/',                     views.event_list,       name='event_list'),         # Done
    path('events/suggest/',             views.event_suggest,    name='event_suggest'),      # Done
    path('events/suggest/results/',     views.suggest_results,  name='suggest_results'),    # Done

    path('events/create/',              views.event_create,     name='event_create'),
    path('events/<slug:slug>/',         views.event_detail,     name='event_detail'),       # Done
    path('events/<slug:slug>/edit/',    views.event_edit,       name='event_edit'),
    path('events/<slug:slug>/delete/',  views.event_delete,     name='event_delete'),

    # Tracks (nested under event slug)
    path('events/<slug:slug>/tracks/create/',
         views.track_create, name='track_create'),
    path('events/<slug:slug>/tracks/<int:track_pk>/edit/',
         views.track_edit,   name='track_edit'),
    path('events/<slug:slug>/tracks/<int:track_pk>/delete/',
         views.track_delete, name='track_delete'),

    # Sessions (nested under event slug)
    path('events/<slug:slug>/sessions/create/',
         views.session_create, name='session_create'),
    path('events/<slug:slug>/sessions/<int:session_pk>/edit/',
         views.session_edit,   name='session_edit'),
    path('events/<slug:slug>/sessions/<int:session_pk>/delete/',
         views.session_delete, name='session_delete'),
]
