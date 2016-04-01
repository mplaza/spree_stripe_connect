module Spree
  class Payment < Spree::Base
  	logger.info('HI TEST')
    Processing.module_eval do
    	alias_method :orig_gateway_options, :gateway_options
    	def gateway_options
    		logger.info('CHANGING OPTIONS!!')
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

	        options[:application_fee] = (order.item_total * 16).to_i
	        t_id = order.tenant_id
			options[:destination] = SpreeStripeAccount.where(tenant_id: t_id).first.stripe_user_id

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
