from django.shortcuts import render, redirect, get_object_or_404
from django.contrib.auth.decorators import login_required
from django.core.exceptions import PermissionDenied
from django.core.paginator import Paginator
from django.contrib import messages

from apps.accounts.decorators import organiser_required
from apps.events.models import Event, Track, Session
from apps.events.forms import EventForm, TrackForm, SessionForm


# ---------------------------------------------------------------------------
# Helpers
# ---------------------------------------------------------------------------

def get_own_event(request, slug):
    """Return the event only if request.user is its organiser."""
    event = get_object_or_404(Event, slug=slug)
    if event.organiser != request.user:
        raise PermissionDenied
    return event


# ---------------------------------------------------------------------------
# Public
# ---------------------------------------------------------------------------

def index(request):
    return render(request, 'account/index.html')


def event_list(request):
    qs = (
        Event.objects
        .filter(status='published')
        .select_related('venue', 'organiser')
        .order_by('starts_at')
    )
    paginator = Paginator(qs, 9)
    page_obj  = paginator.get_page(request.GET.get('page'))
    return render(request, 'events/event-list.html', {'page_obj': page_obj})


def event_detail(request, slug):
    event  = get_object_or_404(Event, slug=slug)
    tracks = event.track_set.prefetch_related('session_set').order_by('name')
    is_owner = request.user.is_authenticated and event.organiser == request.user
    return render(request, 'events/event-detail.html', {
        'event':    event,
        'tracks':   tracks,
        'is_owner': is_owner,
    })


# ---------------------------------------------------------------------------
# Event CRUD (organiser only)
# ---------------------------------------------------------------------------

@login_required
@organiser_required
def event_create(request):
    if request.method == 'POST':
        form = EventForm(request.POST)
        if form.is_valid():
            event          = form.save(commit=False)
            event.organiser = request.user
            event.save()
            messages.success(request, 'Event created successfully.')
            return redirect('event_detail', slug=event.slug)
    else:
        form = EventForm()
    return render(request, 'events/event-form.html', {
        'form':   form,
        'action': 'Create',
    })


@login_required
@organiser_required
def event_edit(request, slug):
    event = get_own_event(request, slug)
    if request.method == 'POST':
        form = EventForm(request.POST, instance=event)
        if form.is_valid():
            form.save()
            messages.success(request, 'Event updated.')
            return redirect('event_detail', slug=event.slug)
    else:
        form = EventForm(instance=event)
    return render(request, 'events/event-form.html', {
        'form':   form,
        'action': 'Edit',
        'event':  event,
    })


@login_required
@organiser_required
def event_delete(request, slug):
    event = get_own_event(request, slug)
    if request.method == 'POST':
        event.delete()
        messages.success(request, 'Event deleted.')
        return redirect('organiser_dashboard')
    return render(request, 'events/event-delete.html', {'event': event})


# ---------------------------------------------------------------------------
# Track CRUD (organiser + owner)
# ---------------------------------------------------------------------------

@login_required
@organiser_required
def track_create(request, slug):
    event = get_own_event(request, slug)
    if request.method == 'POST':
        form = TrackForm(request.POST)
        if form.is_valid():
            track       = form.save(commit=False)
            track.event = event
            track.save()
            messages.success(request, 'Track created.')
            return redirect('event_detail', slug=event.slug)
    else:
        form = TrackForm()
    return render(request, 'events/track-form.html', {
        'form':   form,
        'event':  event,
        'action': 'Create',
    })


@login_required
@organiser_required
def track_edit(request, slug, track_pk):
    event = get_own_event(request, slug)
    track = get_object_or_404(Track, pk=track_pk, event=event)
    if request.method == 'POST':
        form = TrackForm(request.POST, instance=track)
        if form.is_valid():
            form.save()
            messages.success(request, 'Track updated.')
            return redirect('event_detail', slug=event.slug)
    else:
        form = TrackForm(instance=track)
    return render(request, 'events/track-form.html', {
        'form':   form,
        'event':  event,
        'track':  track,
        'action': 'Edit',
    })


@login_required
@organiser_required
def track_delete(request, slug, track_pk):
    event = get_own_event(request, slug)
    track = get_object_or_404(Track, pk=track_pk, event=event)
    if request.method == 'POST':
        track.delete()
        messages.success(request, 'Track deleted.')
        return redirect('event_detail', slug=event.slug)
    return render(request, 'events/track-delete.html', {
        'event': event,
        'track': track,
    })


# ---------------------------------------------------------------------------
# Session CRUD (organiser + owner)
# ---------------------------------------------------------------------------

@login_required
@organiser_required
def session_create(request, slug):
    event = get_own_event(request, slug)
    if request.method == 'POST':
        form = SessionForm(event, request.POST)
        if form.is_valid():
            session       = form.save(commit=False)
            session.event = event
            session.save()
            messages.success(request, 'Session created.')
            return redirect('event_detail', slug=event.slug)
    else:
        form = SessionForm(event)
    return render(request, 'events/session-form.html', {
        'form':   form,
        'event':  event,
        'action': 'Create',
    })


@login_required
@organiser_required
def session_edit(request, slug, session_pk):
    event   = get_own_event(request, slug)
    session = get_object_or_404(Session, pk=session_pk, event=event)
    if request.method == 'POST':
        form = SessionForm(event, request.POST, instance=session)
        if form.is_valid():
            form.save()
            messages.success(request, 'Session updated.')
            return redirect('event_detail', slug=event.slug)
    else:
        form = SessionForm(event, instance=session)
    return render(request, 'events/session-form.html', {
        'form':    form,
        'event':   event,
        'session': session,
        'action':  'Edit',
    })


@login_required
@organiser_required
def session_delete(request, slug, session_pk):
    event   = get_own_event(request, slug)
    session = get_object_or_404(Session, pk=session_pk, event=event)
    if request.method == 'POST':
        session.delete()
        messages.success(request, 'Session deleted.')
        return redirect('event_detail', slug=event.slug)
    return render(request, 'events/session-delete.html', {
        'event':   event,
        'session': session,
    })
