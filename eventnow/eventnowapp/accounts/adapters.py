from allauth.account.adapter import DefaultAccountAdapter
from allauth.socialaccount.adapter import DefaultSocialAccountAdapter
from django.conf import settings

class CustomAccountAdapter(DefaultAccountAdapter):
    def get_login_redirect_url(self, request):
        if request.user.is_organiser():
            return '/eventnow/accounts/dashboard/organiser/'
        return '/eventnow/accounts/dashboard/attendee/'

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
            picture = sociallogin.account.extra_data['picture', '']
            user.avatar_url = picture
        elif sociallogin.account.provider == 'github':
            picture = sociallogin.account.extra_data['avatar_url', '']
            user.avatar_url = picture
        return user