#!/bin/bash

echo "🔧 Fixing all issues..."

cd /var/www/infragridx
source venv/bin/activate

# Step 1: Fix forms.py - Add ContactForm
sudo cat > core/forms.py << 'EOF'
from django import forms
from django.contrib.auth.models import User
from django.contrib.auth.forms import UserCreationForm, AuthenticationForm
from .models import ContactMessage, Partner, PartnerApplication, PartnerProgram

class ContactForm(forms.ModelForm):
    class Meta:
        model = ContactMessage
        fields = ['name', 'email', 'phone', 'company', 'subject', 'message']
        widgets = {
            'name': forms.TextInput(attrs={'class': 'form-control', 'placeholder': 'Your Name'}),
            'email': forms.EmailInput(attrs={'class': 'form-control', 'placeholder': 'Your Email'}),
            'phone': forms.TextInput(attrs={'class': 'form-control', 'placeholder': 'Phone Number'}),
            'company': forms.TextInput(attrs={'class': 'form-control', 'placeholder': 'Company Name'}),
            'subject': forms.TextInput(attrs={'class': 'form-control', 'placeholder': 'Subject'}),
            'message': forms.Textarea(attrs={'class': 'form-control', 'rows': 5, 'placeholder': 'Tell us about your project'}),
        }

class PartnerRegistrationForm(UserCreationForm):
    """Partner Registration Form"""
    email = forms.EmailField(required=True)
    first_name = forms.CharField(max_length=200, required=True)
    last_name = forms.CharField(max_length=200, required=True)
    
    # Company fields
    company_name = forms.CharField(max_length=200, required=True)
    company_website = forms.URLField(required=False)
    partner_type = forms.ChoiceField(choices=Partner.PARTNER_TYPES, required=True)
    business_description = forms.CharField(widget=forms.Textarea, required=True)
    address = forms.CharField(widget=forms.Textarea, required=True)
    city = forms.CharField(max_length=100, required=True)
    state = forms.CharField(max_length=100, required=True)
    country = forms.CharField(max_length=100, required=True)
    pincode = forms.CharField(max_length=20, required=True)
    contact_phone = forms.CharField(max_length=20, required=True)
    terms_accepted = forms.BooleanField(required=True)
    
    class Meta:
        model = User
        fields = ['username', 'first_name', 'last_name', 'email', 'password1', 'password2']
    
    def save(self, commit=True):
        user = super().save(commit=False)
        user.email = self.cleaned_data['email']
        user.is_active = True
        if commit:
            user.save()
            
            # Create partner profile
            partner = Partner.objects.create(
                user=user,
                company_name=self.cleaned_data['company_name'],
                company_website=self.cleaned_data.get('company_website', ''),
                partner_type=self.cleaned_data['partner_type'],
                business_description=self.cleaned_data['business_description'],
                address=self.cleaned_data['address'],
                city=self.cleaned_data['city'],
                state=self.cleaned_data['state'],
                country=self.cleaned_data['country'],
                pincode=self.cleaned_data['pincode'],
                contact_person=f"{self.cleaned_data['first_name']} {self.cleaned_data['last_name']}",
                contact_email=self.cleaned_data['email'],
                contact_phone=self.cleaned_data['contact_phone'],
                terms_accepted=self.cleaned_data['terms_accepted'],
                status='pending'
            )
        return user

class PartnerLoginForm(AuthenticationForm):
    """Partner Login Form"""
    username = forms.CharField(widget=forms.TextInput(attrs={'class': 'form-control', 'placeholder': 'Username'}))
    password = forms.CharField(widget=forms.PasswordInput(attrs={'class': 'form-control', 'placeholder': 'Password'}))

class PartnerApplicationForm(forms.ModelForm):
    """Partner Application Form (for non-registered users)"""
    class Meta:
        model = PartnerApplication
        fields = [
            'first_name', 'last_name', 'email', 'phone',
            'company_name', 'company_website', 'partner_type', 'message'
        ]
        widgets = {
            'first_name': forms.TextInput(attrs={'class': 'form-control', 'placeholder': 'First Name'}),
            'last_name': forms.TextInput(attrs={'class': 'form-control', 'placeholder': 'Last Name'}),
            'email': forms.EmailInput(attrs={'class': 'form-control', 'placeholder': 'Email Address'}),
            'phone': forms.TextInput(attrs={'class': 'form-control', 'placeholder': 'Phone Number'}),
            'company_name': forms.TextInput(attrs={'class': 'form-control', 'placeholder': 'Company Name'}),
            'company_website': forms.URLInput(attrs={'class': 'form-control', 'placeholder': 'Company Website (optional)'}),
            'partner_type': forms.Select(attrs={'class': 'form-control'}),
            'message': forms.Textarea(attrs={'class': 'form-control', 'rows': 5, 'placeholder': 'Tell us about your business...'}),
        }
EOF

echo "✅ forms.py fixed"

# Step 2: Fix views.py - Remove duplicate Service class
sudo cat > core/views.py << 'EOF'
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
EOF

echo "✅ views.py fixed"

# Step 3: Fix urls.py - Remove duplicate partner views
sudo cat > core/urls.py << 'EOF'
from django.urls import path
from . import views

app_name = 'core'

urlpatterns = [
    # Main Pages
    path('', views.HomeView.as_view(), name='home'),
    path('about/', views.AboutView.as_view(), name='about'),
    path('services/', views.ServicesView.as_view(), name='services'),
    path('services/<slug:slug>/', views.ServiceDetailView.as_view(), name='service_detail'),
    path('solutions/', views.SolutionsView.as_view(), name='solutions'),
    path('contact/', views.ContactView.as_view(), name='contact'),
    path('contact/success/', views.ContactSuccessView.as_view(), name='contact_success'),
    path('blog/', views.BlogListView.as_view(), name='blog'),
    path('careers/', views.CareersView.as_view(), name='careers'),
]
EOF

echo "✅ urls.py fixed"

# Step 4: Fix admin.py
sudo cat > core/admin.py << 'EOF'
from django.contrib import admin
from .models import *

@admin.register(Service)
class ServiceAdmin(admin.ModelAdmin):
    list_display = ['name', 'is_active', 'order']
    prepopulated_fields = {'slug': ('name',)}
    list_editable = ['is_active', 'order']
    search_fields = ['name', 'description']

@admin.register(Solution)
class SolutionAdmin(admin.ModelAdmin):
    list_display = ['title', 'is_active']
    prepopulated_fields = {'slug': ('title',)}
    search_fields = ['title', 'description']

@admin.register(ContactMessage)
class ContactMessageAdmin(admin.ModelAdmin):
    list_display = ['name', 'email', 'subject', 'is_read', 'created_at']
    list_filter = ['is_read', 'created_at']
    search_fields = ['name', 'email', 'subject']

@admin.register(Testimonial)
class TestimonialAdmin(admin.ModelAdmin):
    list_display = ['client_name', 'client_company', 'rating', 'is_active']
    list_filter = ['is_active', 'rating']
    search_fields = ['client_name', 'content']

@admin.register(TechnologyPartner)
class TechnologyPartnerAdmin(admin.ModelAdmin):
    list_display = ['name', 'is_active', 'order']
    list_filter = ['is_active']
    list_editable = ['is_active', 'order']
    search_fields = ['name']

@admin.register(BlogPost)
class BlogPostAdmin(admin.ModelAdmin):
    list_display = ['title', 'author', 'is_published', 'created_at']
    list_filter = ['is_published', 'is_featured', 'author']
    prepopulated_fields = {'slug': ('title',)}
    search_fields = ['title', 'content']
    readonly_fields = ['views', 'created_at', 'updated_at']

@admin.register(Career)
class CareerAdmin(admin.ModelAdmin):
    list_display = ['title', 'department', 'location', 'is_active']
    list_filter = ['is_active', 'is_featured', 'department']
    prepopulated_fields = {'slug': ('title',)}
    search_fields = ['title', 'description']
EOF

echo "✅ admin.py fixed"

# Step 5: Drop and recreate tables
echo "📊 Resetting database..."
sudo -u postgres psql -d infragridx_db << 'SQL'
DROP TABLE IF EXISTS core_career CASCADE;
DROP TABLE IF EXISTS core_contactmessage CASCADE;
DROP TABLE IF EXISTS core_service CASCADE;
DROP TABLE IF EXISTS core_solution CASCADE;
DROP TABLE IF EXISTS core_technologypartner CASCADE;
DROP TABLE IF EXISTS core_testimonial CASCADE;
DROP TABLE IF EXISTS core_blogpost CASCADE;
DROP TABLE IF EXISTS core_partner CASCADE;
DROP TABLE IF EXISTS core_partnerprogram CASCADE;
DROP TABLE IF EXISTS core_partnerapplication CASCADE;
DELETE FROM django_migrations WHERE app='core';
SQL

# Step 6: Remove old migrations and create fresh ones
rm -f core/migrations/00*.py
python manage.py makemigrations core
python manage.py migrate core

# Step 7: Create superuser
python -c "
import os
os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'infragridx.settings')
import django
django.setup()
from django.contrib.auth import get_user_model
User = get_user_model()
if not User.objects.filter(is_superuser=True).exists():
    User.objects.create_superuser('admin', 'admin@infragridx.com', 'Admin@2024!')
    print('✅ Admin user created!')
else:
    print('✅ Admin user already exists!')
"

# Step 8: Add services
python -c "
import os
os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'infragridx.settings')
import django
django.setup()
from core.models import Service

services = [
    {'name': 'Data Center Infrastructure & Services', 'slug': 'data-center-infrastructure-services', 'icon': 'fa-server', 'description': 'Enterprise-grade data center infrastructure solutions including design, deployment, and management.', 'is_active': True, 'order': 1},
    {'name': 'Colocation Services', 'slug': 'colocation-services', 'icon': 'fa-building', 'description': 'Secure, reliable, and cost-effective colocation services with 24/7 monitoring.', 'is_active': True, 'order': 2},
    {'name': 'Cloud Services', 'slug': 'cloud-services', 'icon': 'fa-cloud', 'description': 'Comprehensive cloud solutions including migration, management, and optimization.', 'is_active': True, 'order': 3},
    {'name': 'Cyber Security', 'slug': 'cyber-security', 'icon': 'fa-shield-alt', 'description': 'Advanced security solutions including threat detection and compliance management.', 'is_active': True, 'order': 4},
    {'name': 'Managed Servers', 'slug': 'managed-servers', 'icon': 'fa-server', 'description': 'Complete server management including deployment, configuration, maintenance, and 24/7 monitoring.', 'is_active': True, 'order': 5},
]

for service_data in services:
    service, created = Service.objects.get_or_create(slug=service_data['slug'], defaults=service_data)
    print(f\"{'✅ Created' if created else 'ℹ️ Already exists'}: {service.name}\")

print('\n📋 All Services:')
for s in Service.objects.all().order_by('order'):
    print(f'  {s.order}. {s.name}')
"

# Step 9: Collect static and restart
python manage.py collectstatic --noinput
sudo systemctl restart gunicorn
sudo systemctl restart nginx

echo ""
echo "✅ ============================================"
echo "✅ ALL FIXES APPLIED!"
echo "✅ ============================================"
echo ""
echo "🌐 Visit: http://172.16.165.11"
echo "🔑 Admin: http://172.16.165.11/admin"
echo "   Username: admin"
echo "   Password: Admin@2024!"
echo ""
echo "📋 Services Added:"
echo "  1. Data Center Infrastructure & Services"
echo "  2. Colocation Services"
echo "  3. Cloud Services"
echo "  4. Cyber Security"
echo "  5. Managed Servers"
echo ""
