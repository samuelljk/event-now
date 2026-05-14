from allauth.account.adapter import DefaultAccountAdapter
from allauth.socialaccount.adapter import DefaultSocialAccountAdapter
from django.conf import settings

class CustomAccountAdapter(DefaultAccountAdapter):
    def get_login_redirect_url(self, request):
        if request.user.is_organiser():
            return '/config/account/dashboard/organiser/'
        return '/config/account/dashboard/attendee/'

class CustomSocialAccountAdapter(DefaultSocialAccountAdapter):
    def save_user(self, request, sociallogin, form=None):
        user = super().save_user(request, sociallogin, form)
        if not user.role:
            user.role = 'attendee'
            user.save()
        return user

    def populate_user(self, request, sociallogin, data):
        user = super().populate_user(request, sociallogin, data)
        if sociallogin.account.provider == 'google':
            user.avatar_url = sociallogin.account.extra_data.get('picture', '')
        elif sociallogin.account.provider == 'github':
            user.avatar_url = sociallogin.account.extra_data.get('avatar_url', '')
        return user