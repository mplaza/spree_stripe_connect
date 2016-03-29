class CreateSpreeStripeAccounts < ActiveRecord::Migration
  def change
    create_table :spree_stripe_accounts do |t|
      t.string :auth_code
      t.integer :tenant, index: true

      t.timestamps null: false
    end
  end
end
