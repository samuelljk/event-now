from django.shortcuts import render, redirect
from django.contrib.auth.decorators import login_required
from django.core.exceptions import PermissionDenied
# from .forms import ProfileEditForm

@login_required
def dashboard(request):
    if request.user.is_organiser():
        return redirect('organiser_dashboard')
    return render(request, 'attendee_dashboard')
