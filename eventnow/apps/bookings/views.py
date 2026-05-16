from django.shortcuts import render, redirect, get_object_or_404
from django.contrib.auth.decorators import login_required
from django.contrib import messages

from apps.accounts.decorators import attendee_required
from apps.events.models import Event, Session
from apps.bookings.models import EventRegistration, SessionRegistration
from apps.bookings.forms import EventRegistrationForm


@login_required
@attendee_required
def event_register(request, slug):
    event = get_object_or_404(Event, slug=slug)

    # Redirect if already registered
    existing = EventRegistration.objects.filter(event=event, user=request.user).first()
    if existing:
        messages.info(request, "You're already registered for this event.")
        return redirect('booking_detail', registration_id=existing.id)

    # Check capacity
    if event.eventregistration_set.count() >= event.max_capacity:
        messages.error(request, 'Sorry, this event is fully booked.')
        return redirect('event_detail', slug=event.slug)

    # Sessions grouped by track for the template
    tracks = event.track_set.prefetch_related('session_set').order_by('name')

    if request.method == 'POST':
        form = EventRegistrationForm(request.POST)
        selected_ids = request.POST.getlist('sessions')  # raw string IDs

        if form.is_valid():
            registration = EventRegistration.objects.create(
                event=event,
                user=request.user,
                guest_first_name=form.cleaned_data['guest_first_name'],
                guest_last_name=form.cleaned_data['guest_last_name'],
                guest_email=form.cleaned_data['guest_email'],
                status='confirmed',
            )
            # Create session registrations for checked sessions
            if selected_ids:
                sessions = Session.objects.filter(
                    id__in=selected_ids,
                    event=event,  # security: must belong to this event
                )
                for session in sessions:
                    SessionRegistration.objects.create(
                        registration=registration,
                        session=session,
                    )
            messages.success(request, "You're registered! See you there.")
            return redirect('booking_detail', registration_id=registration.id)
    else:
        selected_ids = []
        form = EventRegistrationForm(initial={
            'guest_first_name': request.user.first_name,
            'guest_last_name':  request.user.last_name,
            'guest_email':      request.user.email,
        })

    return render(request, 'booking/event-registration.html', {
        'event':        event,
        'form':         form,
        'tracks':       tracks,
        'selected_ids': [str(i) for i in selected_ids],
    })


@login_required
def booking_detail(request, registration_id):
    registration = get_object_or_404(
        EventRegistration, id=registration_id, user=request.user
    )
    session_registrations = (
        registration.sessionregistration_set
        .select_related('session', 'session__track')
        .order_by('session__starts_at')
    )
    return render(request, 'booking/thank-you.html', {
        'registration':          registration,
        'session_registrations': session_registrations,
    })


@login_required
@attendee_required
def booking_cancel(request, registration_id):
    registration = get_object_or_404(
        EventRegistration, id=registration_id, user=request.user
    )
    if request.method == 'POST':
        registration.status = 'cancelled'
        registration.save()
        messages.success(request, 'Your registration has been cancelled.')
        return redirect('attendee_dashboard')
    return render(request, 'booking/booking-cancel.html', {
        'registration': registration,
    })
