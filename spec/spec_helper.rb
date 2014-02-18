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
ENGINE_RAILS_ROOT=File.join(File.dirname(__FILE__), '../')
Dir[File.join(ENGINE_RAILS_ROOT, "{spec,lib}/**/support/**/*.rb")].each { |f| require f }

# Rspec Configuration
#
RSpec.configure do |config|
  config.use_transactional_fixtures = false

  config.before(:all) do
    Excon.defaults[:mock] = true
    Excon.stub({}, body: 'foo', status: 200)
  end

  config.before(:suite) do
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