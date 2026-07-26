#!/bin/bash

echo "🚀 Updating Pricing Page..."

cd /var/www/infragridx

# Backup current pricing template
sudo cp templates/pricing.html templates/pricing.html.backup 2>/dev/null || echo "No backup needed"

# Create new pricing template
sudo cat > templates/pricing.html << 'EOF'
{% extends 'base.html' %}
{% load static %}

{% block title %}Pricing | InfraGridX{% endblock %}

{% block meta_description %}Explore our flexible pricing for Cloud Services, Rent a Rack, and Rent a Server solutions.{% endblock %}

{% block content %}
<section class="py-5 mt-5">
    <div class="container">
        <!-- Page Header -->
        <div class="text-center mb-5 animate-on-scroll">
            <h1 class="display-4 fw-bold">Simple & Transparent Pricing</h1>
            <p class="lead text-muted">Choose from our flexible infrastructure solutions. All plans are scalable and enterprise-ready.</p>
        </div>

        <!-- Category Links -->
        <div class="row text-center mb-5 animate-on-scroll">
            <div class="col-12">
                <div class="btn-group btn-group-lg flex-wrap justify-content-center" role="group">
                    <a href="#cloud-services" class="btn btn-outline-primary m-1">☁️ Cloud Services</a>
                    <a href="#rent-a-rack" class="btn btn-outline-primary m-1">🖥️ Rent a Rack</a>
                    <a href="#rent-a-server" class="btn btn-outline-primary m-1">💻 Rent a Server</a>
                </div>
            </div>
        </div>

        <!-- 1. Cloud Services -->
        <div id="cloud-services" class="mb-5 animate-on-scroll">
            <h2 class="border-bottom pb-2 mb-4">☁️ Cloud Services</h2>
            <p class="text-muted mb-4">Scalable, secure, and managed cloud solutions for your business.</p>
            <div class="row g-4">
                <div class="col-md-6 col-lg-4">
                    <div class="card h-100 shadow-sm">
                        <div class="card-body text-center">
                            <div class="display-6 mb-3">🔒</div>
                            <h5 class="card-title">Private Cloud</h5>
                            <p class="card-text text-muted">Dedicated, isolated cloud environment for maximum security and control.</p>
                            <ul class="list-unstyled text-start mt-3">
                                <li><i class="fas fa-check-circle text-primary me-2"></i> Dedicated Infrastructure</li>
                                <li><i class="fas fa-check-circle text-primary me-2"></i> Custom Network Architecture</li>
                                <li><i class="fas fa-check-circle text-primary me-2"></i> 24/7 Managed Services</li>
                            </ul>
                            <a href="{% url 'core:contact' %}" class="btn btn-primary mt-3">Get Custom Quote</a>
                        </div>
                    </div>
                </div>
                <div class="col-md-6 col-lg-4">
                    <div class="card h-100 shadow-sm">
                        <div class="card-body text-center">
                            <div class="display-6 mb-3">🌐</div>
                            <h5 class="card-title">Public Cloud</h5>
                            <p class="card-text text-muted">Flexible, scalable public cloud solutions from the world's leading providers.</p>
                            <ul class="list-unstyled text-start mt-3">
                                <li><i class="fas fa-check-circle text-primary me-2"></i> Multi-Cloud Expertise</li>
                                <li><i class="fas fa-check-circle text-primary me-2"></i> Pay-as-you-go Pricing</li>
                                <li><i class="fas fa-check-circle text-primary me-2"></i> 24/7 Monitoring & Support</li>
                            </ul>
                            <a href="{% url 'core:contact' %}" class="btn btn-primary mt-3">Explore Options</a>
                        </div>
                    </div>
                </div>
                <div class="col-md-6 col-lg-4">
                    <div class="card h-100 shadow-sm">
                        <div class="card-body text-center">
                            <div class="display-6 mb-3">🔗</div>
                            <h5 class="card-title">Hybrid Cloud</h5>
                            <p class="card-text text-muted">The best of both worlds: integrate your on-premise infrastructure with the cloud.</p>
                            <ul class="list-unstyled text-start mt-3">
                                <li><i class="fas fa-check-circle text-primary me-2"></i> Seamless Integration</li>
                                <li><i class="fas fa-check-circle text-primary me-2"></i> Scalable & Secure</li>
                                <li><i class="fas fa-check-circle text-primary me-2"></i> Cost-Optimized Solutions</li>
                            </ul>
                            <a href="{% url 'core:contact' %}" class="btn btn-primary mt-3">Learn More</a>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- 2. Rent a Rack -->
        <div id="rent-a-rack" class="mb-5 animate-on-scroll">
            <h2 class="border-bottom pb-2 mb-4">🖥️ Rent a Rack</h2>
            <p class="text-muted mb-4">Secure, scalable, and reliable colocation space for your hardware in our state-of-the-art data centers.</p>
            <div class="row g-4">
                <div class="col-md-6 col-lg-3">
                    <div class="card h-100 shadow-sm">
                        <div class="card-body text-center">
                            <h5 class="card-title">Full Rack</h5>
                            <p class="card-text text-muted">Complete dedicated rack for your equipment.</p>
                            <ul class="list-unstyled text-start mt-3">
                                <li><i class="fas fa-check-circle text-primary me-2"></i> 42U Space</li>
                                <li><i class="fas fa-check-circle text-primary me-2"></i> Redundant Power & Cooling</li>
                                <li><i class="fas fa-check-circle text-primary me-2"></i> 24/7 Support</li>
                            </ul>
                            <a href="{% url 'core:contact' %}" class="btn btn-primary mt-3">Get Quote</a>
                        </div>
                    </div>
                </div>
                <div class="col-md-6 col-lg-3">
                    <div class="card h-100 shadow-sm">
                        <div class="card-body text-center">
                            <h5 class="card-title">Half Rack</h5>
                            <p class="card-text text-muted">Shared rack space with dedicated power and cooling.</p>
                            <ul class="list-unstyled text-start mt-3">
                                <li><i class="fas fa-check-circle text-primary me-2"></i> 21U Space</li>
                                <li><i class="fas fa-check-circle text-primary me-2"></i> Redundant Power</li>
                                <li><i class="fas fa-check-circle text-primary me-2"></i> 24/7 Support</li>
                            </ul>
                            <a href="{% url 'core:contact' %}" class="btn btn-primary mt-3">Get Quote</a>
                        </div>
                    </div>
                </div>
                <div class="col-md-6 col-lg-3">
                    <div class="card h-100 shadow-sm">
                        <div class="card-body text-center">
                            <h5 class="card-title">Quarter Rack</h5>
                            <p class="card-text text-muted">Cost-effective colocation for smaller deployments.</p>
                            <ul class="list-unstyled text-start mt-3">
                                <li><i class="fas fa-check-circle text-primary me-2"></i> 10U Space</li>
                                <li><i class="fas fa-check-circle text-primary me-2"></i> Redundant Power</li>
                                <li><i class="fas fa-check-circle text-primary me-2"></i> 24/7 Support</li>
                            </ul>
                            <a href="{% url 'core:contact' %}" class="btn btn-primary mt-3">Get Quote</a>
                        </div>
                    </div>
                </div>
                <div class="col-md-6 col-lg-3">
                    <div class="card h-100 shadow-sm">
                        <div class="card-body text-center">
                            <h5 class="card-title">Custom Rack</h5>
                            <p class="card-text text-muted">Tailored colocation solutions for your specific needs.</p>
                            <ul class="list-unstyled text-start mt-3">
                                <li><i class="fas fa-check-circle text-primary me-2"></i> Flexible Space</li>
                                <li><i class="fas fa-check-circle text-primary me-2"></i> Custom Power & Cooling</li>
                                <li><i class="fas fa-check-circle text-primary me-2"></i> 24/7 Dedicated Support</li>
                            </ul>
                            <a href="{% url 'core:contact' %}" class="btn btn-primary mt-3">Custom Quote</a>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- 3. Rent a Server -->
        <div id="rent-a-server" class="mb-5 animate-on-scroll">
            <h2 class="border-bottom pb-2 mb-4">💻 Rent a Server</h2>
            <p class="text-muted mb-4">High-performance bare-metal and virtual servers, ready to deploy for your workloads.</p>
            <div class="row g-4">
                <div class="col-md-6 col-lg-3">
                    <div class="card h-100 shadow-sm">
                        <div class="card-body text-center">
                            <h5 class="card-title">Dedicated Server</h5>
                            <p class="card-text text-muted">Single-tenant physical server for maximum performance.</p>
                            <ul class="list-unstyled text-start mt-3">
                                <li><i class="fas fa-check-circle text-primary me-2"></i> Single-Tenant</li>
                                <li><i class="fas fa-check-circle text-primary me-2"></i> High Performance</li>
                                <li><i class="fas fa-check-circle text-primary me-2"></i> 24/7 Support</li>
                            </ul>
                            <a href="{% url 'core:contact' %}" class="btn btn-primary mt-3">Get Quote</a>
                        </div>
                    </div>
                </div>
                <div class="col-md-6 col-lg-3">
                    <div class="card h-100 shadow-sm">
                        <div class="card-body text-center">
                            <h5 class="card-title">Virtual Server</h5>
                            <p class="card-text text-muted">Scalable, cost-effective virtualized server instances.</p>
                            <ul class="list-unstyled text-start mt-3">
                                <li><i class="fas fa-check-circle text-primary me-2"></i> Scalable Resources</li>
                                <li><i class="fas fa-check-circle text-primary me-2"></i> Flexible Pricing</li>
                                <li><i class="fas fa-check-circle text-primary me-2"></i> 24/7 Support</li>
                            </ul>
                            <a href="{% url 'core:contact' %}" class="btn btn-primary mt-3">Get Quote</a>
                        </div>
                    </div>
                </div>
                <div class="col-md-6 col-lg-3">
                    <div class="card h-100 shadow-sm">
                        <div class="card-body text-center">
                            <h5 class="card-title">GPU Server</h5>
                            <p class="card-text text-muted">AI, ML, and compute-intensive workloads on GPU-accelerated servers.</p>
                            <ul class="list-unstyled text-start mt-3">
                                <li><i class="fas fa-check-circle text-primary me-2"></i> NVIDIA GPU Options</li>
                                <li><i class="fas fa-check-circle text-primary me-2"></i> AI/ML Optimized</li>
                                <li><i class="fas fa-check-circle text-primary me-2"></i> 24/7 Support</li>
                            </ul>
                            <a href="{% url 'core:contact' %}" class="btn btn-primary mt-3">Get Quote</a>
                        </div>
                    </div>
                </div>
                <div class="col-md-6 col-lg-3">
                    <div class="card h-100 shadow-sm">
                        <div class="card-body text-center">
                            <h5 class="card-title">Storage Server</h5>
                            <p class="card-text text-muted">High-capacity, reliable storage solutions for your data.</p>
                            <ul class="list-unstyled text-start mt-3">
                                <li><i class="fas fa-check-circle text-primary me-2"></i> High Capacity</li>
                                <li><i class="fas fa-check-circle text-primary me-2"></i> Redundant Storage</li>
                                <li><i class="fas fa-check-circle text-primary me-2"></i> 24/7 Support</li>
                            </ul>
                            <a href="{% url 'core:contact' %}" class="btn btn-primary mt-3">Get Quote</a>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Call to Action -->
        <div class="text-center mt-5 animate-on-scroll">
            <div class="card border-0 shadow-sm p-5">
                <h3>Need a Custom Solution?</h3>
                <p class="text-muted">Contact our team for custom pricing and solutions tailored to your specific requirements.</p>
                <a href="{% url 'core:contact' %}" class="btn btn-primary btn-lg mx-auto">
                    <i class="fas fa-envelope me-2"></i>Contact Sales
                </a>
            </div>
        </div>
    </div>
</section>
{% endblock %}
EOF

# Restart services
sudo systemctl restart gunicorn
sudo systemctl restart nginx

echo ""
echo "✅ ============================================"
echo "✅ PRICING PAGE UPDATED SUCCESSFULLY!"
echo "✅ ============================================"
echo ""
echo "🌐 Visit: https://infragridx.com/pricing/"
echo ""
echo "📋 Changes Made:"
echo "  ✅ Removed old pricing plans (Starter, Professional, Business, Enterprise)"
echo "  ✅ Added Cloud Services section"
echo "  ✅ Added Rent a Rack section"
echo "  ✅ Added Rent a Server section"
echo "  ✅ All old pricing removed"
echo ""
echo "🔑 Admin Panel: https://infragridx.com/admin"
