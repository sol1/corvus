Rails.application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  # In the development environment your application's code is reloaded on
  # every request. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

  # Do not eager load code on boot.
  config.eager_load = false

  # Show full error reports and disable caching.
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false

  # Don't care if the mailer can't send.
  config.action_mailer.raise_delivery_errors = false

  # Print deprecation notices to the Rails logger.
  config.active_support.deprecation = :log

  # Raise an error on page load if there are pending migrations.
  config.active_record.migration_error = :page_load

  # Debug mode disables concatenation and preprocessing of assets.
  # This option may cause significant delays in view rendering with a large
  # number of complex assets.
  config.assets.debug = true

  # Asset digests allow you to set far-future HTTP expiration dates on all assets,
  # yet still be able to expire them through the digest params.
  config.assets.digest = true

  # Adds additional error checking when serving assets at runtime.
  # Checks for improperly declared sprockets dependencies.
  # Raises helpful error messages.
  config.assets.raise_runtime_errors = true

  # Raises error for missing translations
  # config.action_view.raise_on_missing_translations = true

  config.action_mailer.default_url_options = { host: 'localhost', port: 3000 }

  config.voipmonitor = { user: 'corvus', password: 'margthatcheris100%SEXY', baseurl: 'http://localhost:4000/php/api.php' }
  config.voipmonitor_cache_cleaner = {
    # Directory to use for caching wav files
    tmpdir: Rails.root.join('tmp','wav'),
    # Delete items older than this
    max_age: 1.day,
    # Delete items when the cache grows beyond this size
    max_size: 30.megabytes,
    # Delete items until the size of the cache is this much less that max_size (files exceeding max_age will be deleted regardless)
    free_size: 10.megabytes
  }
end
