class CreateSpreeStripeAccounts < ActiveRecord::Migration
  def change
    create_table :spree_stripe_accounts do |t|
      t.string :access_token
      t.string :refresh_token
      t.string :stripe_user_id
      t.string :stripe_publishable_key
      t.integer :tenant_id, index: true

      t.timestamps null: false
    end
  end
end
