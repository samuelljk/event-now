from django.urls import path
from . import views

urlpatterns = [
    path('events/<slug:slug>/register/',          views.event_register,  name='event_register'),
    path('bookings/<int:registration_id>/',        views.booking_detail,  name='booking_detail'),   # Done
    path('bookings/<int:registration_id>/cancel/', views.booking_cancel,  name='booking_cancel'),   # Done
]
