from django.urls import path
from . import views

urlpatterns = [
    path('dashboard/',           views.dashboard,            name='dashboard'),
    path('dashboard/organiser/', views.organiser_dashboard,  name='organiser_dashboard'),
    path('dashboard/attendee/',  views.attendee_dashboard,   name='attendee_dashboard'),
    path('profile/',             views.profile,              name='profile'),
    path('profile/edit/',        views.profile_edit,         name='profile_edit'),
]
