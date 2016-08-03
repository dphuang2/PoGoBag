OmniAuth.config.logger = Rails.logger

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :google_oauth2, '171395142098-ovgjbci31s1jng90ttc09knbff9c55fk.apps.googleusercontent.com', '8Z5jVftLQ0gHIQ_9CpIHrOmX', {client_options: {ssl: {ca_file: Rails.root.join("cacert.pem").to_s}}}
end
