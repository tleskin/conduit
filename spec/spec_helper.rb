# Configure Rails Envinronment
#
ENV["RAILS_ENV"] = "test"

# Require Files
#
require File.expand_path("../dummy/config/environment",__FILE__)
require 'rspec/rails'
require 'database_cleaner'
require 'shoulda/matchers/integrations/rspec'

# Load all of the _spec.rb files
#
Dir[File.join(File.dirname(__FILE__), 'support', '**', '*.rb')].each { |f| require f }

# Rspec Configuration
#
RSpec.configure do |config|
  config.include Helper

  config.use_transactional_fixtures = false

  config.before(:suite) do
    Excon.defaults[:mock] = true
    DatabaseCleaner.clean_with(:truncation)
  end

  config.before(:each) do
    DatabaseCleaner.start
    DatabaseCleaner.strategy = :truncation
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end
end