from django.db import models

class User(models.Model):
    class Role(models.TextChoices):
        ADMIN = 'admin', 'Admin'
        ORGANIZER = 'organiser', 'Organiser'
        ATTENDEES = 'attendee', 'Attendee'

    id = models.AutoField(primary_key=True)
    email = models.EmailField(unique=True)
    username = models.CharField(max_length=100)
    first_name = models.CharField(max_length=255)
    last_name = models.CharField(max_length=255)
    avatar_url = models.URLField(blank=True)
    role = models.CharField(
        max_length=20,
        choices=list(Role.choices),
        default=Role.ATTENDEES
    )

    is_active = models.BooleanField(default=True)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

class Identity(models.Model):
    id = models.AutoField(primary_key=True)
    user = models.ForeignKey(User, on_delete=models.CASCADE)
    provider = models.CharField(max_length=255, null=False, blank=False)
    provider_user_id = models.CharField(max_length=255, null=False, blank=False)
    access_token = models.CharField(max_length=255)
    refresh_token = models.CharField(max_length=255)
    token_expires_at = models.DateTimeField()

    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

class Password(models.Model):
    id = models.AutoField(primary_key=True)
    user = models.ForeignKey(User, on_delete=models.CASCADE)
    password_hash = models.CharField(max_length=255, null=False, blank=False)

    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)