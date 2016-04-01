require 'oauth2'
class Spree::Admin::StripeConnectController < Spree::Admin::BaseController

	before_filter :set_client, :only => [:setup, :stripeauth]

	def set_client
		@client = OAuth2::Client.new(ENV['stripe_client_id'], ENV['stripe_api_key'], {:site => 'https://connect.stripe.com', :authorize_url => '/oauth/authorize', :token_url => '/oauth/token'})
	end

	def index
		
	end

	def stripeauth
		url = @client.auth_code.authorize_url({:scope => 'read_write'})
		redirect_to url
	end

	def setup
		code = params["code"]
		@resp = @client.auth_code.get_token(code, :params => {:scope => 'read_write'})
    	@access_token = @resp.token
    	@refresh_token = @resp.refresh_token
    	@stripe_user_id = @resp["stripe_user_id"]
    	@stripe_publishable_key = @resp["stripe_publishable_key"]
    	SpreeStripeAccount.save_tokens(@access_token, @refresh_token, @stripe_user_id, @stripe_publishable_key)
	end


end