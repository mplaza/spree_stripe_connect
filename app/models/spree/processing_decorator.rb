module Spree
  class Payment < Spree::Base
    Processing.module_eval do
    	alias_method :orig_gateway_options, :gateway_options
    	def gateway_options
    		order.reload
	        options = { email: order.email,
	                    customer: order.email,
	                    customer_id: order.user_id,
	                    ip: order.last_ip_address,
	                    # Need to pass in a unique identifier here to make some
	                    # payment gateways happy.
	                    #
	                    # For more information, please see Spree::Payment#set_unique_identifier
	                    order_id: gateway_order_id }

	        options[:shipping] = order.ship_total * 100
	        options[:tax] = order.additional_tax_total * 100
	        options[:subtotal] = order.item_total * 100
	        options[:discount] = order.promo_total * 100
	        options[:currency] = currency
	        puts 'this is the ship total'
	        puts order.ship_total
	        options[:application_fee] = ( (order.item_total * ENV['application_fee_percent'].to_i) + (order.ship_total * 100)).to_i
	        t_id = order.tenant_id
	        puts 'the order tenant id'
	        puts t_id
          accnt = SpreeStripeAccount.where(tenant_id: t_id).first
          if accnt != nil
           options[:destination] = accnt.stripe_user_id
          else
           raise "Stripe account not found for tenant: #{t_id}"
          end

	        bill_address = source.try(:address)
	        bill_address ||= order.bill_address

	        options[:billing_address] = bill_address.try!(:active_merchant_hash)
	        options[:shipping_address] = order.ship_address.try!(:active_merchant_hash)
	        logger.info(options)
	        options
    	end
    end
	end
end
