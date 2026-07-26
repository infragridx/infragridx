from django.db import models
from django.contrib.auth.models import User
from ckeditor.fields import RichTextField

class Service(models.Model):
    name = models.CharField(max_length=200)
    slug = models.SlugField(unique=True)
    icon = models.CharField(max_length=100, default='fa-server')
    description = models.TextField()
    full_description = RichTextField(blank=True)
    image = models.ImageField(upload_to='services/', blank=True)
    is_active = models.BooleanField(default=True)
    order = models.IntegerField(default=0)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    class Meta:
        ordering = ['order', 'name']
        verbose_name_plural = 'Services'

    def __str__(self):
        return self.name
    
    def get_related_services(self):
        return Service.objects.filter(is_active=True).exclude(id=self.id)[:3]

class Solution(models.Model):
    title = models.CharField(max_length=200)
    slug = models.SlugField(unique=True)
    description = models.TextField()
    full_content = RichTextField(blank=True)
    image = models.ImageField(upload_to='solutions/', blank=True)
    is_active = models.BooleanField(default=True)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    class Meta:
        ordering = ['-created_at']
        verbose_name_plural = 'Solutions'

    def __str__(self):
        return self.title
    
    def get_related_solutions(self):
        return Solution.objects.filter(is_active=True).exclude(id=self.id)[:3]

class ContactMessage(models.Model):
    name = models.CharField(max_length=200)
    email = models.EmailField()
    phone = models.CharField(max_length=20, blank=True)
    company = models.CharField(max_length=200, blank=True)
    subject = models.CharField(max_length=200)
    message = models.TextField()
    is_read = models.BooleanField(default=False)
    created_at = models.DateTimeField(auto_now_add=True)

    class Meta:
        ordering = ['-created_at']
        verbose_name_plural = 'Contact Messages'

    def __str__(self):
        return f"{self.name} - {self.subject}"

class Testimonial(models.Model):
    client_name = models.CharField(max_length=200)
    client_position = models.CharField(max_length=200, blank=True)
    client_company = models.CharField(max_length=200, blank=True)
    content = models.TextField()
    client_image = models.ImageField(upload_to='testimonials/', blank=True)
    rating = models.IntegerField(default=5)
    is_active = models.BooleanField(default=True)
    created_at = models.DateTimeField(auto_now_add=True)

    class Meta:
        ordering = ['-created_at']
        verbose_name_plural = 'Testimonials'

    def __str__(self):
        return self.client_name

class TechnologyPartner(models.Model):
    name = models.CharField(max_length=200)
    logo = models.ImageField(upload_to='partners/')
    website = models.URLField(blank=True)
    is_active = models.BooleanField(default=True)
    order = models.IntegerField(default=0)

    class Meta:
        ordering = ['order', 'name']
        verbose_name_plural = 'Technology Partners'

    def __str__(self):
        return self.name

class BlogPost(models.Model):
    title = models.CharField(max_length=200)
    slug = models.SlugField(unique=True)
    content = RichTextField()
    excerpt = models.TextField(max_length=300)
    featured_image = models.ImageField(upload_to='blog/')
    author = models.ForeignKey(User, on_delete=models.CASCADE)
    categories = models.CharField(max_length=200)
    tags = models.CharField(max_length=200, blank=True)
    is_published = models.BooleanField(default=False)
    is_featured = models.BooleanField(default=False)
    views = models.IntegerField(default=0)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    class Meta:
        ordering = ['-created_at']
        verbose_name_plural = 'Blog Posts'

    def __str__(self):
        return self.title

class Career(models.Model):
    title = models.CharField(max_length=200)
    slug = models.SlugField(unique=True)
    department = models.CharField(max_length=200)
    location = models.CharField(max_length=200)
    description = RichTextField()
    is_active = models.BooleanField(default=True)
    is_featured = models.BooleanField(default=False)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    class Meta:
        ordering = ['-created_at']
        verbose_name_plural = 'Careers'

    def __str__(self):
        return self.title

# Partner Models
class Partner(models.Model):
    PARTNER_TYPES = (
        ('reseller', 'Reseller Partner'),
        ('technology', 'Technology Partner'),
        ('solution', 'Solution Provider'),
        ('consulting', 'Consulting Partner'),
        ('affiliate', 'Affiliate Partner'),
    )
    
    STATUS_CHOICES = (
        ('pending', 'Pending Approval'),
        ('approved', 'Approved'),
        ('active', 'Active'),
        ('suspended', 'Suspended'),
        ('terminated', 'Terminated'),
    )
    
    user = models.OneToOneField(User, on_delete=models.CASCADE, related_name='partner_profile')
    company_name = models.CharField(max_length=200)
    company_website = models.URLField(blank=True)
    company_logo = models.ImageField(upload_to='partners/logos/', blank=True)
    contact_person = models.CharField(max_length=200)
    contact_email = models.EmailField()
    contact_phone = models.CharField(max_length=20)
    partner_type = models.CharField(max_length=50, choices=PARTNER_TYPES, default='reseller')
    status = models.CharField(max_length=50, choices=STATUS_CHOICES, default='pending')
    business_description = models.TextField()
    target_market = models.CharField(max_length=200, blank=True)
    years_in_business = models.IntegerField(default=1)
    employee_count = models.IntegerField(default=1)
    tax_id = models.CharField(max_length=100, blank=True)
    address = models.TextField()
    city = models.CharField(max_length=100)
    state = models.CharField(max_length=100)
    country = models.CharField(max_length=100)
    pincode = models.CharField(max_length=20)
    newsletter_subscribed = models.BooleanField(default=True)
    terms_accepted = models.BooleanField(default=False)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)
    approved_at = models.DateTimeField(null=True, blank=True)
    
    class Meta:
        ordering = ['-created_at']
        verbose_name_plural = 'Partners'
    
    def __str__(self):
        return f"{self.company_name} - {self.user.username}"
    
    def is_approved(self):
        return self.status in ['approved', 'active']

class PartnerProgram(models.Model):
    name = models.CharField(max_length=200)
    slug = models.SlugField(unique=True)
    description = models.TextField()
    benefits = RichTextField()
    requirements = RichTextField()
    commission_structure = models.TextField(blank=True)
    is_active = models.BooleanField(default=True)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)
    
    class Meta:
        ordering = ['name']
        verbose_name_plural = 'Partner Programs'
    
    def __str__(self):
        return self.name

class PartnerApplication(models.Model):
    partner_program = models.ForeignKey(PartnerProgram, on_delete=models.CASCADE, null=True, blank=True)
    first_name = models.CharField(max_length=200)
    last_name = models.CharField(max_length=200)
    email = models.EmailField()
    phone = models.CharField(max_length=20)
    company_name = models.CharField(max_length=200)
    company_website = models.URLField(blank=True)
    partner_type = models.CharField(max_length=50, choices=Partner.PARTNER_TYPES, default='reseller')
    message = models.TextField()
    status = models.CharField(max_length=50, choices=Partner.STATUS_CHOICES, default='pending')
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)
    
    class Meta:
        ordering = ['-created_at']
        verbose_name_plural = 'Partner Applications'
    
    def __str__(self):
        return f"{self.company_name} - {self.email}"

class PricingPlan(models.Model):
    """Pricing Plans Model"""
    PLAN_TYPES = (
        ('starter', 'Starter'),
        ('professional', 'Professional'),
        ('business', 'Business'),
        ('enterprise', 'Enterprise'),
    )
    
    name = models.CharField(max_length=100)
    slug = models.SlugField(unique=True)
    plan_type = models.CharField(max_length=50, choices=PLAN_TYPES, default='professional')
    description = models.TextField()
    price_monthly = models.DecimalField(max_digits=10, decimal_places=2, default=0.00)
    price_yearly = models.DecimalField(max_digits=10, decimal_places=2, default=0.00, blank=True, null=True)
    setup_fee = models.DecimalField(max_digits=10, decimal_places=2, default=0.00)
    
    # Features (stored as JSON or text)
    features = models.TextField(help_text="List features separated by new lines")
    
    # Service association
    services = models.ManyToManyField('Service', blank=True, related_name='pricing_plans')
    
    # Display
    is_featured = models.BooleanField(default=False)
    is_active = models.BooleanField(default=True)
    order = models.IntegerField(default=0)
    
    # Metadata
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)
    
    class Meta:
        ordering = ['order', 'name']
        verbose_name_plural = 'Pricing Plans'
    
    def __str__(self):
        return f"{self.name} - ${self.price_monthly}/month"
    
    def get_feature_list(self):
        """Return features as a list"""
        return [f.strip() for f in self.features.split('\n') if f.strip()]

class BlogPost(models.Model):
    title = models.CharField(max_length=200)
    slug = models.SlugField(unique=True)
    content = RichTextField()
    excerpt = models.TextField(max_length=300)
    featured_image = models.ImageField(upload_to='blog/', blank=True)
    author = models.ForeignKey(User, on_delete=models.CASCADE)
    categories = models.CharField(max_length=200, blank=True)
    tags = models.CharField(max_length=200, blank=True)
    is_published = models.BooleanField(default=False)
    is_featured = models.BooleanField(default=False)
    views = models.IntegerField(default=0)
    read_time = models.IntegerField(default=5, help_text="Estimated read time in minutes")
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    class Meta:
        ordering = ['-created_at']
        verbose_name_plural = 'Blog Posts'

    def __str__(self):
        return self.title
    
    def get_related_posts(self):
        return BlogPost.objects.filter(is_published=True).exclude(id=self.id)[:3]

class BlogPost(models.Model):
    title = models.CharField(max_length=200)
    slug = models.SlugField(unique=True)
    content = RichTextField()
    excerpt = models.TextField(max_length=300)
    featured_image = models.ImageField(upload_to='blog/', blank=True)
    author = models.ForeignKey(User, on_delete=models.CASCADE)
    categories = models.CharField(max_length=500, blank=True)  # Increased from 200 to 500
    tags = models.CharField(max_length=200, blank=True)
    is_published = models.BooleanField(default=False)
    is_featured = models.BooleanField(default=False)
    views = models.IntegerField(default=0)
    read_time = models.IntegerField(default=5, help_text="Estimated read time in minutes")
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    class Meta:
        ordering = ['-created_at']
        verbose_name_plural = 'Blog Posts'

    def __str__(self):
        return self.title
    
    def get_related_posts(self):
        return BlogPost.objects.filter(is_published=True).exclude(id=self.id)[:3]
