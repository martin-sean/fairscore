require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Fairscore
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.0

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.

    # Request job queue
    config.active_job.queue_adapter = Rails.env.production? ? :active_elastic_job : :sidekiq
    Rails.application.config.active_elastic_job.secret_key_base = Rails.application.credentials.secret_key_base
  end
end
