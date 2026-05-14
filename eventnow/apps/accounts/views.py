from django.shortcuts import render, redirect
from django.contrib.auth.decorators import login_required
from django.utils import timezone

from .decorators import organiser_required, attendee_required
from .forms import ProfileEditForm


@login_required
def dashboard(request):
    if request.user.is_organiser():
        return redirect('organiser_dashboard')
    return redirect('attendee_dashboard')


@login_required
@organiser_required
def organiser_dashboard(request):
    events = request.user.event_set.all()
    return render(request, 'account/organiser-dashboard.html', {
        'events': events,
    })


@login_required
@attendee_required
def attendee_dashboard(request):
    now = timezone.now()
    all_registrations = request.user.eventregistration_set.select_related('event', 'event__venue').all()
    upcoming = all_registrations.filter(event__starts_at__gte=now)
    past = all_registrations.filter(event__starts_at__lt=now)
    return render(request, 'account/attendee-dashboard.html', {
        'upcoming_registrations': upcoming,
        'past_registrations': past,
        'total_registrations': all_registrations.count(),
    })


@login_required
def profile(request):
    return render(request, 'account/profile.html')


@login_required
def profile_edit(request):
    if request.method == 'POST':
        form = ProfileEditForm(request.POST, instance=request.user)
        if form.is_valid():
            form.save()
            return redirect('profile')
    else:
        form = ProfileEditForm(instance=request.user)
    return render(request, 'account/profile-edit.html', {'form': form})
