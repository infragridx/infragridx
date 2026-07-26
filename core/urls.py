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
    path('solutions/<slug:slug>/', views.SolutionDetailView.as_view(), name='solution_detail'),
    path('pricing/', views.PricingView.as_view(), name='pricing'),
    
    # Pricing Categories
    path('pricing/cloud-services/', views.PricingCategoryView.as_view(), kwargs={'category': 'cloud-services'}, name='pricing_cloud'),
    path('pricing/rent-a-rack/', views.PricingCategoryView.as_view(), kwargs={'category': 'rent-a-rack'}, name='pricing_rack'),
    path('pricing/rent-a-server/', views.PricingCategoryView.as_view(), kwargs={'category': 'rent-a-server'}, name='pricing_server'),
    path('pricing/rent-a-gpu/', views.PricingCategoryView.as_view(), kwargs={'category': 'rent-a-gpu'}, name='pricing_gpu'),
    
    # Pricing Items
    path('pricing/cloud-services/private-cloud/', views.PricingItemView.as_view(), kwargs={'category': 'cloud-services', 'item': 'private-cloud'}, name='pricing_private_cloud'),
    path('pricing/cloud-services/public-cloud/', views.PricingItemView.as_view(), kwargs={'category': 'cloud-services', 'item': 'public-cloud'}, name='pricing_public_cloud'),
    path('pricing/cloud-services/public-cloud/aws/', views.PricingItemView.as_view(), kwargs={'category': 'cloud-services', 'item': 'aws'}, name='pricing_aws'),
    path('pricing/cloud-services/public-cloud/azure/', views.PricingItemView.as_view(), kwargs={'category': 'cloud-services', 'item': 'azure'}, name='pricing_azure'),
    path('pricing/cloud-services/public-cloud/google-cloud/', views.PricingItemView.as_view(), kwargs={'category': 'cloud-services', 'item': 'google-cloud'}, name='pricing_google'),
    path('pricing/cloud-services/public-cloud/oracle-cloud/', views.PricingItemView.as_view(), kwargs={'category': 'cloud-services', 'item': 'oracle-cloud'}, name='pricing_oracle'),
    path('pricing/rent-a-rack/full-rack/', views.PricingItemView.as_view(), kwargs={'category': 'rent-a-rack', 'item': 'full-rack'}, name='pricing_full_rack'),
    path('pricing/rent-a-rack/half-rack/', views.PricingItemView.as_view(), kwargs={'category': 'rent-a-rack', 'item': 'half-rack'}, name='pricing_half_rack'),
    path('pricing/rent-a-rack/quarter-rack/', views.PricingItemView.as_view(), kwargs={'category': 'rent-a-rack', 'item': 'quarter-rack'}, name='pricing_quarter_rack'),
    path('pricing/rent-a-rack/custom-rack/', views.PricingItemView.as_view(), kwargs={'category': 'rent-a-rack', 'item': 'custom-rack'}, name='pricing_custom_rack'),
    path('pricing/rent-a-server/dedicated-server/', views.PricingItemView.as_view(), kwargs={'category': 'rent-a-server', 'item': 'dedicated-server'}, name='pricing_dedicated_server'),
    path('pricing/rent-a-server/virtual-server/', views.PricingItemView.as_view(), kwargs={'category': 'rent-a-server', 'item': 'virtual-server'}, name='pricing_virtual_server'),
    path('pricing/rent-a-server/high-performance/', views.PricingItemView.as_view(), kwargs={'category': 'rent-a-server', 'item': 'high-performance'}, name='pricing_high_performance'),
    path('pricing/rent-a-server/storage-server/', views.PricingItemView.as_view(), kwargs={'category': 'rent-a-server', 'item': 'storage-server'}, name='pricing_storage_server'),
    path('pricing/rent-a-gpu/nvidia-a100/', views.PricingItemView.as_view(), kwargs={'category': 'rent-a-gpu', 'item': 'nvidia-a100'}, name='pricing_a100'),
    path('pricing/rent-a-gpu/nvidia-v100/', views.PricingItemView.as_view(), kwargs={'category': 'rent-a-gpu', 'item': 'nvidia-v100'}, name='pricing_v100'),
    path('pricing/rent-a-gpu/nvidia-t4/', views.PricingItemView.as_view(), kwargs={'category': 'rent-a-gpu', 'item': 'nvidia-t4'}, name='pricing_t4'),
    path('pricing/rent-a-gpu/custom-gpu/', views.PricingItemView.as_view(), kwargs={'category': 'rent-a-gpu', 'item': 'custom-gpu'}, name='pricing_custom_gpu'),
    
    path('contact/', views.ContactView.as_view(), name='contact'),
    path('contact/success/', views.ContactSuccessView.as_view(), name='contact_success'),
    path('blog/', views.BlogListView.as_view(), name='blog'),
    path('blog/<slug:slug>/', views.BlogDetailView.as_view(), name='blog_detail'),
    path('careers/', views.CareersView.as_view(), name='careers'),
    
    # Partner Program
    path('partner/', views.PartnerView.as_view(), name='partner_programs'),
    path('partner/register/', views.PartnerRegisterView.as_view(), name='partner_register'),
    path('partner/login/', views.PartnerLoginView.as_view(), name='partner_login'),
    path('partner/logout/', views.partner_logout, name='partner_logout'),
    path('partner/dashboard/', views.partner_dashboard, name='partner_dashboard'),
    path('partner/profile/', views.partner_profile, name='partner_profile'),
    path('partner/apply/', views.PartnerApplyView.as_view(), name='partner_apply'),
    path('partner/apply/success/', views.PartnerApplySuccessView.as_view(), name='partner_apply_success'),
]
