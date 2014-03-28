#
# The job of this class is to require all
# actions belonging to this driver
#
# e.g.
# => module Conduit::Driver
# =>   class MyDriver < Conduit::Core::Driver
# =>     required_credentials :foo, :bar, :baz
# =>
# =>     action :purchase
# =>     action :activate
# =>     action :suspend
# =>
# =>   end
# => end
#

require 'set'

module Conduit
  module Core
    module Driver

      def self.extended(base)
        base.instance_variable_set("@_driver_path",
          File.dirname(caller.first[/^[^:]+/]))
      end

      # Set required credentials
      #
      # e.g.
      # => required_credentials :foo, :bar, :baz
      #
      def required_credentials(*args)
        credentials.merge(args)
      end

      # Set available actions
      #
      # e.g.
      # => action :purchase
      #
      def action(action_name)
        require File.join(@_driver_path, 'actions', action_name.to_s)
        require File.join(@_driver_path, 'parsers', action_name.to_s)
        actions << action_name
      end

      # Storage array for required credentials
      #
      # e.g.
      # Conduit::Driver::Fusion.credentials
      # => [:foo, :bar, :baz]
      #
      def credentials
        @credentials ||= Set.new
      end

      # Storage array for required credentials
      #
      # e.g.
      # Conduit::Driver::Fusion.actions
      # => [:purchase]
      #
      def actions
        @actions ||= Set.new
      end

      private

        # Return the name of the driver
        #
        # e.g.
        # Conduit::Drivers::Fusion.name
        # => "fusion"
        #
        def driver_name
          self.name.demodulize.underscore.downcase
        end

    end
  end
end
