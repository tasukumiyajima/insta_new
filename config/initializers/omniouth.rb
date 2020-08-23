Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook, Rails.application.credentials.facebook[:key], Rails.application.credentials.facebook[:secret]
end