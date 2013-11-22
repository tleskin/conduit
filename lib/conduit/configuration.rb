#
# The job of this class is to provide common
# configuration options to conduit
#

module Conduit
  module Configuration
    class << self

      # Storage
      #
      # Define the storage type, and credentials
      # Supported storage types: AWS(S3)
      #
      mattr_accessor :storage_credentials
      self.storage_credentials = {}

      def configure(&block)
        yield self
      end

    end
  end
end