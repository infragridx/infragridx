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
