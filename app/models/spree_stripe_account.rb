class SpreeStripeAccount < ActiveRecord::Base
  belongs_to :spree_tenant, foreign_key: "tenant"

  def self.save_tokens(at, rt)
  	stripe_account = self.create_with(auth_token: at, refresh_token: rt).find_or_create_by(tenant: Multitenant.current_tenant.id)
  end

end
