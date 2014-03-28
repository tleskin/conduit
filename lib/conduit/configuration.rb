#
# The job of this class is to provide common
# configuration options to conduit
#

module Conduit
  module Configuration
    class << self

      #
      # Storage
      #
      # Define the storage configuration. This could
      # include anything from file paths, to
      # service credentials, and provider
      #
      mattr_accessor :storage_config
      self.storage_config = {
        provider:   :file,
        file_path:  Conduit.app_root.join('tmp', 'conduit')
      }

      #
      # Drivers
      #
      # Define the driver load path
      # Define an array of drivers to load
      #
      mattr_accessor :driver_paths
      self.driver_paths = ["#{File.dirname(__FILE__)}/drivers"]

      #
      # Methods
      #
      # Read in the configuration
      #
      def configure(&block)
        yield self
      end

    end
  end
end