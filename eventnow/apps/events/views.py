from django.shortcuts import render, redirect, get_object_or_404
from django.contrib.auth.decorators import login_required
from django.core.exceptions import PermissionDenied
from django.core.paginator import Paginator
from django.contrib import messages
from django.urls import reverse
from django.conf import settings

from typing import List
from pydantic import BaseModel, Field

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
    from apps.bookings.models import EventRegistration
    event  = get_object_or_404(Event, slug=slug)
    tracks = event.track_set.prefetch_related('session_set').order_by('name')
    is_owner = request.user.is_authenticated and event.organiser == request.user

    already_registered = None
    if request.user.is_authenticated and not is_owner:
        already_registered = EventRegistration.objects.filter(
            event=event, user=request.user
        ).first()

    return render(request, 'events/event-detail.html', {
        'event':              event,
        'tracks':             tracks,
        'is_owner':           is_owner,
        'already_registered': already_registered,
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


# ---------------------------------------------------------------------------
# AI Event Suggester
# ---------------------------------------------------------------------------

SUGGEST_QUESTIONS = [
    {
        'step': 1,
        'key':  'occupation',
        'question': "What best describes your occupation?",
        'icon': '💼',
        'options': [
            'Student',
            'Software Developer',
            'Designer',
            'Data Scientist',
            'Product Manager',
            'Business Professional',
            'Other',
        ],
    },
    {
        'step': 2,
        'key':  'age',
        'question': "How old are you?",
        'icon': '🎂',
        'options': ['Under 18', '18–24', '25–34', '35–44', '45+'],
    },
    {
        'step': 3,
        'key':  'topics',
        'question': "Which topics interest you the most?",
        'icon': '🔍',
        'options': [
            'Technology & Software',
            'Design & UX',
            'Data & AI',
            'Cybersecurity',
            'Product & Business',
            'Career Development',
        ],
    },
    {
        'step': 4,
        'key':  'format',
        'question': "What event format do you prefer?",
        'icon': '📅',
        'options': [
            'Hands-on Workshop',
            'Conference & Talks',
            'Networking Event',
            'Any format',
        ],
    },
    {
        'step': 5,
        'key':  'level',
        'question': "What is your experience level?",
        'icon': '⭐',
        'options': ['Beginner', 'Intermediate', 'Advanced', "Doesn't matter"],
    },
]

TOTAL_STEPS = len(SUGGEST_QUESTIONS)


def event_suggest(request):
    step = int(request.GET.get('step', 1))

    # Reset session on a fresh start
    if step == 1:
        request.session['suggest_answers'] = {}

    if request.method == 'POST':
        posted_step = int(request.POST.get('step', 1))
        answer      = request.POST.get('answer', '').strip()

        answers = request.session.get('suggest_answers', {})
        answers[SUGGEST_QUESTIONS[posted_step - 1]['key']] = answer
        request.session['suggest_answers'] = answers
        request.session.modified = True

        if posted_step == TOTAL_STEPS:
            return redirect('suggest_results')

        return redirect(f"{reverse('event_suggest')}?step={posted_step + 1}")

    # GET — show current step
    if step < 1 or step > TOTAL_STEPS:
        step = 1

    question     = SUGGEST_QUESTIONS[step - 1]
    progress_pct = int(step / TOTAL_STEPS * 100)

    return render(request, 'events/suggest.html', {
        'question':     question,
        'total':        TOTAL_STEPS,
        'progress_pct': progress_pct,
    })


def suggest_results(request):
    answers = request.session.get('suggest_answers', {})

    if not answers:
        return redirect('event_suggest')

    events_qs = (
        Event.objects
        .filter(status='published')
        .select_related('venue')
        .prefetch_related('track_set')
    )

    if not events_qs.exists():
        return render(request, 'events/suggest-results.html', {
            'suggested_events': [],
            'answers': answers,
        })

    # Build plain-text event descriptions for the LLM prompt
    event_lines = []
    for ev in events_qs:
        tracks = ', '.join(ev.track_set.values_list('name', flat=True)) or 'General'
        event_lines.append(
            f"Slug: {ev.slug} | Title: {ev.title} | Tracks: {tracks} | "
            f"Description: {ev.description[:250]}"
        )
    events_text  = '\n'.join(event_lines)
    user_profile = '\n'.join(f"{k.capitalize()}: {v}" for k, v in answers.items())

    # ── LangChain LLM call ─────────────────────────────────────────────────
    try:
        from langchain_openai import ChatOpenAI
        from langchain_core.prompts import PromptTemplate
        from langchain_core.output_parsers import JsonOutputParser

        class EventSuggestions(BaseModel):
            slugs: List[str] = Field(
                description="List of event slugs that best match the user profile (up to 4)"
            )

        parser = JsonOutputParser(pydantic_object=EventSuggestions)

        prompt = PromptTemplate(
            template=(
                "You are an event recommendation engine for EventNow, a conference and workshop platform.\n"
                "Given the user profile below, select the most relevant events from the available list.\n"
                "Return at most 4 event slugs. If no events match well, return an empty list.\n\n"
                "{format_instructions}\n\n"
                "User profile:\n{user_profile}\n\n"
                "Available events:\n{events}"
            ),
            input_variables=["user_profile", "events"],
            partial_variables={"format_instructions": parser.get_format_instructions()},
        )

        llm   = ChatOpenAI(
            api_key=settings.OPENAI_API_KEY,
            model="gpt-5.4-mini",
            temperature=0.7,
        )
        chain  = prompt | llm | parser
        result = chain.invoke({"user_profile": user_profile, "events": events_text})
        slugs  = result.get("slugs", [])

        suggested_events = list(
            Event.objects
            .filter(slug__in=slugs, status='published')
            .select_related('venue')
        )

    except Exception as e:
        import traceback
        traceback.print_exc()          # prints full error to Django console
        suggested_events = []
        error_msg = str(e)
    else:
        error_msg = None

    return render(request, 'events/suggest-results.html', {
        'suggested_events': suggested_events,
        'answers':          answers,
        'error_msg':        error_msg,
    })
