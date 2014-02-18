#
# The job of this class is to provide storage
# functionality for conduit.
#
# TODO: Support multiple storage providers
#

require 'aws-sdk'

module Conduit
  module Storage
    module Aws
      extend ActiveSupport::Rescuable

      def self.extended(base)
        base.extend(ClassMethods)
        base.send(:configure)
      end

      module ClassMethods

        # Configure AWS::S3 if we have explicit config
        #
        # TODO: This needs to be tested against AWS IAM.
        #       I'm thinking this being a "module"
        #       might cause issues.
        #
        def configure
          if [:aws_access_key_id, :aws_access_secret].all? { |key| config.has_key?(key) }
            AWS.config(:access_key_id => config[:aws_access_key_id],
              :secret_access_key => config[:aws_access_secret])
          end
        end

        # Primary connection object to AWS::S3
        #
        # Configurable in:
        # config/initializers/conduit.rb
        # TODO: Update how conduit gets
        # the credentials for s3
        #
        def connection
          @connection ||= AWS::S3.new
        end

        # Bucket we want to work with
        #
        # Configurable in:
        # config/initializers/conduit.rb
        #
        def bucket
          @bucket ||= begin
            bucket = config[:bucket]
            connection.buckets.create(bucket) unless connection.buckets[bucket].exists?
            connection.buckets[bucket]
          end
        end

        # Write a file to AWS::S3
        #
        # e.g.
        # => Conduit::Storage.write('/path/to/file', 'foo')
        #
        def write(key, content)
          bucket.objects[key].write(content)
        end

        # Read a file from AWS::S3
        #
        # e.g.
        # => Conduit::Storage.read('/path/to/file')
        #
        def read(key)
          bucket.objects[key].read
        rescue AWS::S3::Errors::NoSuchKey
          nil
        end

        # Delete a file from AWS::S3
        #
        # e.g.
        # => Conduit::Storage.delete('/path/to/file')
        #
        def delete(key)
          bucket.objects[key].delete
        rescue AWS::S3::Errors::NoSuchKey
          nil
        end

      end

    end
  end
end
