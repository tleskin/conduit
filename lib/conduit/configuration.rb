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

      # Define the storage type, and credentials
      # Supported storage types: AWS(S3)
      #
      mattr_accessor :storage_credentials
      self.storage_credentials = {}

      #
      # Drivers
      #
      # Define the driver load path
      # Define an array of drivers to load
      #
      mattr_accessor :driver_path
      self.driver_path = "#{File.dirname(__FILE__)}/drivers"

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