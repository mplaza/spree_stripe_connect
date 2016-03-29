class AddRefreshTokenToSpreeStripeAccounts < ActiveRecord::Migration
  def change
  	add_column :spree_stripe_accounts, :refresh_token, :string
  	rename_column :spree_stripe_accounts, :auth_code, :auth_token
  end
end
