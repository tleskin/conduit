#
# The job of this class is to provide common
# functionality to a action class.
#
# e.g.
# => class MyAction < Conduit::Core::Action
# =>   required_attributes :foo, :bar
# =>   optional_attributes :baz
# => end
#
# => action = MyAction.new(foo: 'foo', bar: 'bar', baz: 'baz')
# => action.perform
#

module Conduit
  module Core
    class Action

      def self.inherited(base)
        base.send :include, Conduit::Core::Connection
        base.send :include, Conduit::Core::Render
        base.send :include, InstanceMethods
        base.extend ClassMethods
      end

      module ClassMethods

        # Set required attributes
        #
        # e.g.
        # => required_attributes :foo, :bar, :baz
        #
        def required_attributes(*args)
          requirements.concat(args).uniq
          attributes.concat(args).uniq
        end

        # Set optional attributes
        #
        # e.g.
        # => optional_attributes :foo, :bar, :baz
        #
        def optional_attributes(*args)
          attributes.concat(args).uniq
        end

        # Storage array for required attributes
        #
        def requirements
          @requirements ||= []
        end

        # Storage array for all attributes
        #
        def attributes
          @attributes ||= []
        end

      end

      module InstanceMethods

        delegate :requirements, :attributes, to: :class

        def initialize(**options)
          @options = options
          validate!(options)
        end

        # Object used for passing data to the view
        # Only keys listed in attributes will be
        # used.
        #
        def view_context
          OpenStruct.new(@options.select do |k,v|
            attributes.include?(k)
          end)
        end

        # Location where the view files can be found
        # Default to lib/conduit/drivers/<drivername>/views
        # Can be overriden per class.
        #
        def view_path
          driver = self.class.to_s.split('::')[-2].underscore.downcase
          "#{Conduit::Configuration.driver_path}/#{driver}/views/"
        end

        # Return the rendered view
        #
        def view
          tpl = self.class.name.demodulize
            .underscore.downcase
          render(tpl)
        end

        # Entry method. The class will use
        # use this to trigger the request.
        #
        # Override to customize.
        #
        def perform
          request(body: view, method: :post)
        end

        private

          # Ensures that all required attributes are present
          # If not all attributes are present, will raise
          # an ArgumentError listing missing attributes
          #
          def validate!(options)
            missing_keys = (requirements - options.keys)
            if missing_keys.any?
              raise ArgumentError,
                "Missing keys: #{missing_keys.join(', ')}"
            end
          end

      end

    end
  end
end
