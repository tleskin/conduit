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

require 'active_support/inflector'
require 'forwardable'
require 'ostruct'
require 'set'

module Conduit
  module Core
    class Action

      def self.inherited(base)
        base.send :include, Conduit::Core::Connection
        base.send :include, Conduit::Core::Render
        base.send :include, InstanceMethods
        base.extend ClassMethods

        # TODO: Move this to the driver scope
        #       which allows for setting this
        #       "globally" for the driver.
        #
        path = caller.first[/^[^:]+/]
        base.send(:define_method, :action_path) do
          File.dirname(path)
        end
      end

      module ClassMethods

        attr_accessor :_action_path

        # Set required attributes
        #
        # e.g.
        # => required_attributes :foo, :bar, :baz
        #
        def required_attributes(*args)
          requirements.merge(args)
          attributes.merge(args)
        end

        # Set optional attributes
        #
        # e.g.
        # => optional_attributes :foo, :bar, :baz
        #
        def optional_attributes(*args)
          attributes.merge(args)
        end

        # Storage array for required attributes
        #
        def requirements
          @requirements ||= Set.new
        end

        # Storage array for all attributes
        #
        def attributes
          @attributes ||= Set.new
        end

      end

      module InstanceMethods
        extend Forwardable

        def initialize(**options)
          @options = options
          validate!(options)
        end

        def_delegator :'self.class', :requirements
        def_delegator :'self.class', :attributes

        # def requirements
        #   self.class.requirements
        # end

        # def attributes
        #   self.class.attributes
        # end

        # Object used for passing data to the view
        # Only keys listed in attributes will be
        # used.
        #
        def view_context
          OpenStruct.new(@options.select do |k, v|
            attributes.include?(k)
          end)
        end

        # Location where the view files can be found
        # Default to lib/conduit/drivers/<drivername>/views
        # Can be overriden per class.
        #
        def view_path
          File.join(File.dirname(action_path), 'views')
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
          response = request(body: view, method: :post)
          parser   = parser_class.new(response.body)

          Conduit::Response.new(raw_response: response,
            parser: parser)
        end

        private

        # Ensures that all required attributes are present
        # If not all attributes are present, will raise
        # an ArgumentError listing missing attributes
        #
        def validate!(options)
          missing_keys = (requirements.to_a - options.keys)
          if missing_keys.any?
            raise ArgumentError,
              "Missing keys: #{missing_keys.join(', ')}"
          end
        end

        # Returns the parser for this action
        # subclasses responsible for providing the
        # response_body and response_status.
        #
        def parser_class
          self.class.const_get(:Parser)
        end
      end

    end
  end
end
