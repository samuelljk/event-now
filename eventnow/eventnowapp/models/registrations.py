from django.db import models
from . import User, Event, Session

class EventRegistration(models.Model):
    id = models.AutoField(primary_key=True)
    event = models.ForeignKey(Event, on_delete=models.CASCADE)
    user = models.ForeignKey(User, on_delete=models.CASCADE)
    guest_first_name = models.CharField(max_length=255)
    guest_last_name = models.CharField(max_length=255)
    guest_email = models.EmailField()
    status = models.CharField(max_length=255)

    registered_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

class SessionRegistration(models.Model):
    id = models.AutoField(primary_key=True)
    registration = models.ForeignKey(EventRegistration, on_delete=models.CASCADE)
    session = models.ForeignKey(Session, on_delete=models.CASCADE)

    created_at = models.DateTimeField(auto_now_add=True)