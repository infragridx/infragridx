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

@admin.register(Partner)
class PartnerAdmin(admin.ModelAdmin):
    list_display = ['company_name', 'user', 'partner_type', 'status', 'created_at']
    list_filter = ['partner_type', 'status']
    search_fields = ['company_name', 'contact_email', 'user__username']
    list_editable = ['status']
    readonly_fields = ['created_at', 'updated_at']

@admin.register(PartnerApplication)
class PartnerApplicationAdmin(admin.ModelAdmin):
    list_display = ['company_name', 'email', 'partner_type', 'status', 'created_at']
    list_filter = ['partner_type', 'status']
    search_fields = ['company_name', 'email', 'first_name', 'last_name']
    list_editable = ['status']
    readonly_fields = ['created_at', 'updated_at']

@admin.register(PartnerProgram)
class PartnerProgramAdmin(admin.ModelAdmin):
    list_display = ['name', 'is_active', 'created_at']
    prepopulated_fields = {'slug': ('name',)}
    search_fields = ['name', 'description']
