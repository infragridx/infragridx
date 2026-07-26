from django.views.generic import TemplateView, ListView, DetailView, FormView
from django.urls import reverse_lazy
from django.contrib import messages
from django.core.mail import send_mail, EmailMultiAlternatives
from django.conf import settings
from .models import *
from .forms import ContactForm

class HomeView(TemplateView):
    template_name = 'index.html'
    
    def get_context_data(self, **kwargs):
        context = super().get_context_data(**kwargs)
        context['services'] = Service.objects.filter(is_active=True)[:6]
        context['solutions'] = Solution.objects.filter(is_active=True)[:4]
        context['testimonials'] = Testimonial.objects.filter(is_active=True)[:3]
        context['partners'] = TechnologyPartner.objects.filter(is_active=True)
        context['blog_posts'] = BlogPost.objects.filter(is_published=True)[:3]
        return context

class AboutView(TemplateView):
    template_name = 'about.html'
    
    def get_context_data(self, **kwargs):
        context = super().get_context_data(**kwargs)
        context['testimonials'] = Testimonial.objects.filter(is_active=True)
        context['partners'] = TechnologyPartner.objects.filter(is_active=True)
        return context

class ServicesView(ListView):
    model = Service
    template_name = 'services.html'
    context_object_name = 'services'
    
    def get_queryset(self):
        return Service.objects.filter(is_active=True)

class ServiceDetailView(DetailView):
    model = Service
    template_name = 'service_detail.html'
    context_object_name = 'service'
    slug_url_kwarg = 'slug'

class SolutionsView(ListView):
    model = Solution
    template_name = 'solutions.html'
    context_object_name = 'solutions'
    
    def get_queryset(self):
        return Solution.objects.filter(is_active=True)

class ContactView(FormView):
    template_name = 'contact.html'
    form_class = ContactForm
    success_url = reverse_lazy('core:contact_success')
    
    def get_context_data(self, **kwargs):
        context = super().get_context_data(**kwargs)
        context['services'] = Service.objects.filter(is_active=True)
        return context
    
    def form_valid(self, form):
        contact = form.save()
        
        # Send email notification
        try:
            subject = f"New Contact Message from {contact.name}"
            text_content = f"""
            New Contact Message from {contact.name}
            
            Name: {contact.name}
            Email: {contact.email}
            Phone: {contact.phone or 'Not provided'}
            Company: {contact.company or 'Not provided'}
            Subject: {contact.subject}
            
            Message:
            {contact.message}
            """
            
            send_mail(
                subject,
                text_content,
                settings.DEFAULT_FROM_EMAIL,
                ['info@infragridx.com'],
                fail_silently=False,
            )
            messages.success(self.request, 'Thank you! Your message has been sent.')
        except Exception as e:
            print(f"Email error: {str(e)}")
            messages.warning(self.request, 'Message saved but email notification failed.')
        
        return super().form_valid(form)

class ContactSuccessView(TemplateView):
    template_name = 'contact_success.html'

class BlogListView(ListView):
    model = BlogPost
    template_name = 'blog.html'
    context_object_name = 'posts'
    paginate_by = 6
    
    def get_queryset(self):
        return BlogPost.objects.filter(is_published=True)

class CareersView(ListView):
    model = Career
    template_name = 'careers.html'
    context_object_name = 'careers'
    
    def get_queryset(self):
        return Career.objects.filter(is_active=True)

# ============ PARTNER VIEWS ============
from django.shortcuts import render, redirect, get_object_or_404
from django.contrib.auth import login, authenticate, logout
from django.contrib.auth.decorators import login_required
from django.views.generic import TemplateView, FormView, CreateView
from django.core.mail import send_mail
from django.contrib import messages
from .forms import PartnerRegistrationForm, PartnerLoginForm, PartnerApplicationForm
from .models import Partner, PartnerApplication, PartnerProgram

class PartnerView(TemplateView):
    template_name = 'partner/programs.html'

class PartnerRegisterView(FormView):
    template_name = 'partner/register.html'
    form_class = PartnerRegistrationForm
    success_url = '/partner/dashboard/'
    
    def form_valid(self, form):
        user = form.save()
        login(self.request, user)
        messages.success(self.request, '✅ Registration successful! Welcome to InfraGridX Partner Program.')
        return super().form_valid(form)
    
    def form_invalid(self, form):
        messages.error(self.request, '❌ Registration failed. Please check the errors below.')
        return super().form_invalid(form)

class PartnerLoginView(FormView):
    template_name = 'partner/login.html'
    form_class = PartnerLoginForm
    success_url = '/partner/dashboard/'
    
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
    logout(request)
    messages.success(request, '✅ You have been logged out successfully.')
    return redirect('core:home')

@login_required
def partner_dashboard(request):
    try:
        partner = request.user.partner_profile
        context = {
            'partner': partner,
            'is_approved': partner.is_approved(),
        }
        return render(request, 'partner/dashboard.html', context)
    except Partner.DoesNotExist:
        messages.warning(request, '⚠️ Please complete your partner profile.')
        return redirect('core:partner_apply')

@login_required
def partner_profile(request):
    try:
        partner = request.user.partner_profile
        context = {'partner': partner}
        return render(request, 'partner/profile.html', context)
    except Partner.DoesNotExist:
        return redirect('core:partner_apply')

class PartnerApplyView(FormView):
    template_name = 'partner/apply.html'
    form_class = PartnerApplicationForm
    success_url = '/partner/apply/success/'
    
    def form_valid(self, form):
        application = form.save()
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
                'info@infragridx.com',
                ['info@infragridx.com'],
                fail_silently=False,
            )
        except:
            pass
        
        messages.success(self.request, '✅ Thank you for your application! We will review it shortly.')
        return super().form_valid(form)

class PartnerApplySuccessView(TemplateView):
    template_name = 'partner/apply_success.html'

class SolutionDetailView(DetailView):
    model = Solution
    template_name = 'solution_detail.html'
    context_object_name = 'solution'
    slug_url_kwarg = 'slug'

class SolutionDetailView(DetailView):
    model = Solution
    template_name = 'solution_detail.html'
    context_object_name = 'solution'
    slug_url_kwarg = 'slug'

class PricingView(TemplateView):
    template_name = 'pricing.html'
    
    def get_context_data(self, **kwargs):
        context = super().get_context_data(**kwargs)
        context['plans'] = PricingPlan.objects.filter(is_active=True).order_by('order')
        context['services'] = Service.objects.filter(is_active=True)
        return context

class PricingDetailView(TemplateView):
    template_name = 'pricing_detail.html'
    
    def get_context_data(self, **kwargs):
        context = super().get_context_data(**kwargs)
        context['category'] = kwargs.get('category', '')
        context['item'] = kwargs.get('item', '')
        return context

class PricingDetailView(TemplateView):
    template_name = 'pricing_detail.html'
    
    def get_context_data(self, **kwargs):
        context = super().get_context_data(**kwargs)
        context['category'] = kwargs.get('category', '')
        context['item'] = kwargs.get('item', '')
        return context

class PricingCategoryView(TemplateView):
    template_name = 'pricing_category.html'
    
    def get_context_data(self, **kwargs):
        context = super().get_context_data(**kwargs)
        context['category'] = kwargs.get('category', '')
        return context

class PricingItemView(TemplateView):
    template_name = 'pricing_item.html'
    
    def get_context_data(self, **kwargs):
        context = super().get_context_data(**kwargs)
        context['category'] = kwargs.get('category', '')
        context['item'] = kwargs.get('item', '')
        return context

class BlogDetailView(DetailView):
    model = BlogPost
    template_name = 'blog_detail.html'
    context_object_name = 'post'
    slug_url_kwarg = 'slug'
    
    def get_queryset(self):
        return BlogPost.objects.filter(is_published=True)
    
    def get_object(self):
        obj = super().get_object()
        # Increment view count
        obj.views += 1
        obj.save(update_fields=['views'])
        return obj
    
    def get_context_data(self, **kwargs):
        context = super().get_context_data(**kwargs)
        context['posts'] = BlogPost.objects.filter(is_published=True)[:5]
        return context
