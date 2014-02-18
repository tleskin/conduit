#
# The job of this class is to provide storage
# functionality for conduit.
#
# TODO: Support multiple storage providers
#

require 'conduit/storage/aws'
require 'conduit/storage/file'

module Conduit
  module Storage

    # Wrapper around the configuration object
    #
    # Configurable in:
    # config/initializers/conduit.rb
    #
    def self.config
      Configuration.storage_config
    end

    # Get the name of the chosen provider
    # from the configuration
    #
    def self.provider
      Configuration.storage_config[:provider]
    end

    # Load in the functionality for the storage provider
    # that was selected via the configuration
    #
    storage_provider_module = const_get(provider.to_s.humanize)
    extend storage_provider_module

  end
end
