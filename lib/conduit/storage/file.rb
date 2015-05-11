#
# The job of this class is to provide storage
# functionality for conduit.
#
# TODO: Support multiple storage providers
#

require 'fileutils'
require 'pathname'

module Conduit
  module Storage
    module File

      #
      # TODO: Rename this, I originally used file,
      #       not considering the fact that it's
      #       already used in ruby.
      #

      def self.extended(base)
        base.extend(ClassMethods)
      end

      module ClassMethods

        # Return a Pathname object for the
        # configured file path
        #
        def storage_path
          @storage_path ||= Pathname.new(config[:file_path])
        end

        # Write a file to AWS::S3
        #
        # e.g.
        # => Conduit::Storage.write('/path/to/file', 'foo')
        #
        def write(key, content)
          full_path = storage_path.join(key)
          FileUtils.mkdir_p(::File.dirname(full_path))

          ::File.open(full_path, 'wb') do |f|
            f.write(content)
          end
        end

        # Read a file
        #
        # e.g.
        # => Conduit::Storage.read('/path/to/file')
        #
        def read(key)
          ::File.read(storage_path.join(key))
        rescue Errno::ENOENT
          nil
        end

        # Delete a file
        #
        # e.g.
        # => Conduit::Storage.delete('/path/to/file')
        #
        def delete(key)
          ::File.delete(storage_path.join(key))
        rescue Errno::ENOENT, Errno::EPERM
          nil
        end

      end

    end
  end
end
