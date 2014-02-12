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

module Conduit
  module Core
    module Driver

      # Set required credentials
      #
      # e.g.
      # => required_credentials :foo, :bar, :baz
      #
      def required_credentials(*args)
        credentials.concat(args)
      end

      # Set available actions
      #
      # e.g.
      # => action :purchase
      #
      def action(action_name)
        require File.join(driver_path, 'actions', action_name.to_s)
        actions << action_name
      end

      # Storage array for required credentials
      #
      # e.g.
      # Conduit::Driver::Fusion.credentials
      # => [:foo, :bar, :baz]
      #
      def credentials
        @credentials ||= []
      end

      # Storage array for required credentials
      #
      # e.g.
      # Conduit::Driver::Fusion.actions
      # => [:purchase]
      #
      def actions
        @actions ||= []
      end

      private

        # Return the name of the driver
        #
        # e.g.
        # Conduit::Drivers::Fusion.name
        # => "fusion"
        #
        def driver_name
          self.name.demodulize.downcase
        end

        # Return the path to the driver
        #
        # e.g.
        # Conduit::Drivers::Fusion.path
        # => "/Users/mike/Projects/BeQuick/conduit/lib/conduit/drivers/fusion"
        #
        def driver_path
          File.join(Conduit::Configuration.driver_path, driver_name)
        end

    end
  end
end