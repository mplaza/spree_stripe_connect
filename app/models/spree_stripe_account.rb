class SpreeStripeAccount < ActiveRecord::Base
  belongs_to :spree_tenant, foreign_key: "tenant"

  def self.save_tokens(at, rt, sui, spk)
  	stripe_account = self.find_or_initialize_by(tenant_id: Multitenant.current_tenant.id)
  	puts stripe_account
  	stripe_account.access_token = at
  	stripe_account.refresh_token = rt
  	stripe_account.stripe_user_id = sui
  	stripe_account.stripe_publishable_key = spk
  	stripe_account.save
  end

  def create_charge(amount, brand)
  	Stripe.api_key = ENV['stripe_api_key']
  	Stripe::Charge.create({
  		:amount => 10,
  		:currency => "usd",
  		:source => {}
  		})
  end

end
