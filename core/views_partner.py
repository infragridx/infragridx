from django.shortcuts import render, redirect, get_object_or_404
from django.contrib.auth import login, authenticate, logout
from django.contrib.auth.decorators import login_required
from django.contrib import messages
from django.urls import reverse_lazy
from django.views.generic import FormView, TemplateView, CreateView
from django.core.mail import send_mail
from django.conf import settings
from .forms import PartnerRegistrationForm, PartnerLoginForm, PartnerApplicationForm
from .models import Partner, PartnerApplication, PartnerProgram

class PartnerRegisterView(FormView):
    """Partner Registration View"""
    template_name = 'partner/register.html'
    form_class = PartnerRegistrationForm
    success_url = reverse_lazy('core:partner_dashboard')
    
    def form_valid(self, form):
        user = form.save()
        login(self.request, user)
        messages.success(self.request, '✅ Registration successful! Welcome to InfraGridX Partner Program.')
        return super().form_valid(form)
    
    def form_invalid(self, form):
        messages.error(self.request, '❌ Registration failed. Please check the errors below.')
        return super().form_invalid(form)

class PartnerLoginView(FormView):
    """Partner Login View"""
    template_name = 'partner/login.html'
    form_class = PartnerLoginForm
    success_url = reverse_lazy('core:partner_dashboard')
    
    def form_valid(self, form):
        username = form.cleaned_data.get('username')
        password = form.cleaned_data.get('password')
        user = authenticate(self.request, username=username, password=password)
        
        if user is not None:
            login(self.request, user)
            messages.success(self.request, f'✅ Welcome back, {username}!')
            return redirect('core:partner_dashboard')
        else:
            messages.error(self.request, '❌ Invalid username or password.')
            return self.form_invalid(form)

def partner_logout(request):
    """Partner Logout View"""
    logout(request)
    messages.success(request, '✅ You have been logged out successfully.')
    return redirect('core:home')

@login_required
def partner_dashboard(request):
    """Partner Dashboard View"""
    try:
        partner = request.user.partner_profile
        context = {
            'partner': partner,
            'is_approved': partner.is_approved(),
            'total_applications': PartnerApplication.objects.filter(email=partner.contact_email).count(),
        }
        return render(request, 'partner/dashboard.html', context)
    except Partner.DoesNotExist:
        messages.warning(request, '⚠️ Please complete your partner profile.')
        return redirect('core:partner_apply')

@login_required
def partner_profile(request):
    """Partner Profile View"""
    try:
        partner = request.user.partner_profile
        if request.method == 'POST':
            # Update profile logic here
            pass
        context = {'partner': partner}
        return render(request, 'partner/profile.html', context)
    except Partner.DoesNotExist:
        return redirect('core:partner_apply')

class PartnerApplyView(FormView):
    """Partner Application View"""
    template_name = 'partner/apply.html'
    form_class = PartnerApplicationForm
    success_url = reverse_lazy('core:partner_apply_success')
    
    def form_valid(self, form):
        application = form.save()
        
        # Send email notification
        try:
            send_mail(
                'New Partner Application',
                f"""
                New partner application from {application.company_name}
                
                Contact: {application.first_name} {application.last_name}
                Email: {application.email}
                Phone: {application.phone}
                
                Message:
                {application.message}
                """,
                settings.DEFAULT_FROM_EMAIL,
                ['info@infragridx.com'],
                fail_silently=False,
            )
        except:
            pass
        
        messages.success(self.request, '✅ Thank you for your application! We will review it shortly.')
        return super().form_valid(form)

class PartnerApplySuccessView(TemplateView):
    template_name = 'partner/apply_success.html'

def partner_programs(request):
    """Partner Programs Listing"""
    programs = PartnerProgram.objects.filter(is_active=True)
    return render(request, 'partner/programs.html', {'programs': programs})
