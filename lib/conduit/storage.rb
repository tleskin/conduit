#
# The job of this class is to provide storage
# functionality for conduit.
#
# TODO: Support multiple storage providers
#

require 'aws-sdk'

module Conduit
  module Storage
    extend ActiveSupport::Rescuable

    # Primary connection object to AWS::S3
    #
    # Configurable in:
    # config/initializers/conduit.rb
    # TODO: Update how conduit gets
    # the credentials for s3
    #
    def self.connection
      @connection ||= AWS::S3.new(access_key_id: Configuration.storage_credentials[:aws_access_key_id],
        secret_access_key: Configuration.storage_credentials[:aws_access_secret])
    end

    # Bucket we want to work with
    #
    # Configurable in:
    # config/initializers/conduit.rb
    #
    def self.bucket
      @bucket ||= begin
        bucket = Configuration.storage_credentials[:bucket]
        connection.buckets.create(bucket) unless connection.buckets[bucket].exists?
        connection.buckets[bucket]
      end
    end

    # Write a file to AWS::S3
    #
    # e.g.
    # => Conduit::Storage.write('/path/to/file', 'foo')
    #
    def self.write(key, content)
      bucket.objects[key].write(content)
    end

    # Read a file from AWS::S3
    #
    # e.g.
    # => Conduit::Storage.read('/path/to/file')
    #
    def self.read(key)
      bucket.objects[key].read
    rescue AWS::S3::Errors::NoSuchKey
      nil
    end

    # Delete a file from AWS::S3
    #
    # e.g.
    # => Conduit::Storage.delete('/path/to/file')
    #
    def self.delete(key)
      bucket.objects[key].delete
    rescue AWS::S3::Errors::NoSuchKey
      nil
    end

  end
end
