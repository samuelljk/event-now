from functools import wraps
from django.core.exceptions import PermissionDenied


def organiser_required(view_func):
    """Allow only users whose role is organiser. Use after @login_required."""
    @wraps(view_func)
    def wrapper(request, *args, **kwargs):
        if not request.user.is_organiser():
            raise PermissionDenied
        return view_func(request, *args, **kwargs)
    return wrapper


def attendee_required(view_func):
    """Allow only users whose role is attendee. Use after @login_required."""
    @wraps(view_func)
    def wrapper(request, *args, **kwargs):
        if not request.user.is_attendee():
            raise PermissionDenied
        return view_func(request, *args, **kwargs)
    return wrapper
