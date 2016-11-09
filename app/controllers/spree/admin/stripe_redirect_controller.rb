class Spree::Admin::StripeRedirectController < ApplicationController
	skip_before_filter :single_signon
	def setup
		code = params["code"]
		brand_domain = Spree::Tenant.find_by_id(params["state"]).domain
		redirect_to url_for domain: brand_domain, controller: 'stripe_connect', action: 'setup', code: code
	end
  
  def dashboard_redirect
    @stripe_instance = SpreeStripeAccount.find_by(:tenant_id => Brand.current_tenant(request).id)
    if @stripe_instance.present?
      redirect_to 'https://dashboard.stripe.com/'
    else
      redirect_to '/be/admin/payment_account/authorize'
    end
  end
end
