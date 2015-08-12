# Require Files
#
require 'bundler/setup'
Bundler.setup

require 'rspec'
require 'rspec/its'
require 'shoulda/matchers'
require 'conduit'

# Load all of the _spec.rb files
#
Dir[File.join(File.dirname(__FILE__), 'support', '**', '*.rb')].each { |f| require f }

# Rspec Configuration
#
RSpec.configure do |config|
  config.include Helper

  config.expect_with :rspec do |c|
    c.syntax = [:should, :expect]
  end

  config.before(:suite) do
    Excon.defaults[:mock] = true
    Conduit.configure do |c|
      c.driver_paths << File.join(__dir__, 'support')
    end

    Conduit::Driver.load_drivers
  end
end
