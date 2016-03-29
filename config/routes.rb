Spree::Core::Engine.routes.draw do
  namespace :admin, path: '/admin' do
  	get '/payment_account' => 'stripe_connect#index'
  	get '/payment_account/setup' => 'stripe_connect#setup'
  	get '/payment_account/authorize' => 'stripe_connect#stripeauth'
  end
end
