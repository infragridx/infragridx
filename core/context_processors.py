from .models import Service, TechnologyPartner

def site_context(request):
    return {
        'services_nav': Service.objects.filter(is_active=True)[:8],
        'partners_footer': TechnologyPartner.objects.filter(is_active=True)[:10],
        'company_name': 'InfraGridX Technologies Private Limited',
        'company_phone': '+91-9703732345',
        'company_email': 'info@infragridx.com',
        'company_address': 'Dr.No: 70-11-72, Srinivasa Nagar, Patamata, Vijayawada - 520010',
    }
