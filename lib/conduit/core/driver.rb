#
# The job of this class is to require all
# actions belonging to this driver
#
# e.g.
# => module Conduit::Driver
# =>   class MyDriver < Conduit::Core::Driver
# =>     required_credentials :username, :password
# =>     required_attributes  :subdomain
# =>     optional_attributes  :quux
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
        base.instance_variable_set('@_driver_path',
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

      # Set required attributes
      # Useful for specifying attributes that
      # MUST be set for every request.
      #
      # e.g.
      # required_attributes :foo, :bar, :baz
      # => <Set {:foo, :bar, :baz}>
      #
      def required_attributes(*args)
        required_attribute_set.tap do |attrs|
          attrs.merge(args)
        end
      end

      # Set optional attributes
      # Useful for specifying overrides and other
      # attributes that MAY be set for every
      # request.
      #
      # e.g.
      # optional_attributes :quux
      # => <Set {:quux}>
      #
      def optional_attributes(*args)
        optional_attribute_set.tap do |attrs|
          attrs.merge(args)
        end
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

      # Storage array for permitted attributes
      #
      # e.g.
      # Conduit::Driver::Fusion.permitted_attributes
      # => <Set {:foo, :bar, :baz, :quuz}>
      #
      def permitted_attributes
        required_attribute_set + optional_attribute_set
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

      # Returns the current set of required attributes
      #
      def required_attribute_set
        @required_attribute_set ||= Set.new
      end

      # Returns the current set of optional attributes
      #
      def optional_attribute_set
        @optional_attribute_set ||= Set.new
      end

    end
  end
end
