module Spree
  Gateway::StripeGateway.class_eval do
  	alias_method :orig_options_for_purchase_or_auth, :options_for_purchase_or_auth
  	def options_for_purchase_or_auth(money, creditcard, gateway_options)
      options = {}
      options[:description] = "Spree Order ID: #{gateway_options[:order_id]}"
      options[:currency] = gateway_options[:currency]
      options[:destination] = gateway_options[:destination]
      options[:application_fee] = gateway_options[:application_fee]

      if customer = creditcard.gateway_customer_profile_id
        options[:customer] = customer
      end
      if token_or_card_id = creditcard.gateway_payment_profile_id
        # The Stripe ActiveMerchant gateway supports passing the token directly as the creditcard parameter
        # The Stripe ActiveMerchant gateway supports passing the customer_id and credit_card id
        # https://github.com/Shopify/active_merchant/issues/770
        creditcard = token_or_card_id
      end
      return money, creditcard, options
    end
  end
end