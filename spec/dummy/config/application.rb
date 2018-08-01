require_relative 'boot'

require 'rails'

require "active_model/railtie"
require "active_job/railtie"
# require "active_record/railtie"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_view/railtie"
require "action_cable/engine"

require "sprockets/railtie"

require "sequel-rails"

Bundler.require(*Rails.groups)
require "sc/billing"

module Dummy
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.2

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.

    # Sequel config
    config.sequel.schema_format = :sql
    config.sequel.after_connect = proc do
      Sequel::Model.plugin :timestamps, update_on_create: true
      Sequel::Model.plugin :boolean_readers
      Sequel::Model.plugin :tactical_eager_loading

      Sequel.extension :pg_json_ops

      Sequel::Model.db.extension :pg_json,
                                 :pg_array,
                                 :pg_range,
                                 :pagination
    end
  end
end

