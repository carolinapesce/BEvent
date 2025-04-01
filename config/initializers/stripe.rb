Rails.application.configure do
  config.stripe.secret_key = ENV["STRIPE_SECRET_KEY"]
  config.stripe.publishable_key = ENV["STRIPE_PUBLISHABLE_KEY"]
  Stripe.api_version = '2025-02-24.acacia'
end
