module ActiveMerchant
	module Billing
		StripeGateway.class_eval do
			alias_method :orig_authorize, :authorize
			def authorize(money, payment, options = {})
		        MultiResponse.run do |r|
		          if payment.is_a?(ApplePayPaymentToken)
		            r.process { tokenize_apple_pay_token(payment) }
		            payment = StripePaymentToken.new(r.params["token"]) if r.success?
		          end
		          r.process do
		            post = create_post_for_auth_or_purchase(money, payment, options)
		            post[:capture] = "false"
		            add_application_fee(post, options)
		            add_destination(post, options)
		            commit(:post, 'charges', post, options)
		          end
		        end.responses.last
		      end
		    def add_destination(post, options)
		       post[:destination] = options[:destination] if options[:destination]
		    end
		end
	end
end