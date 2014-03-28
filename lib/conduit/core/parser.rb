#
# The job of this class is parse a raw response
# and provide parsed attributes that can be
# predictably consumed.
#
module Conduit
  module Core
    class Parser
      cattr_accessor :attributes

      # Define an attribute that will be publically exposed
      # when dealing with conduit responses.
      #
      def self.attribute(attr_name, &block)
        attributes << attr_name
        define_method(attr_name, &block)
      end

      # Returns a hash representation of each attribute
      # defined in a parser and its value.
      #
      def serializable_hash
        attributes.inject({}) do |hash, attribute|
          hash.tap { |h| h[attribute] = send(attribute) }
        end
      end

      # Assumes all requests were successful.
      # Should be overwritten by parser implementation.
      #
      def action_response_status
        "success"
      end
    end
  end
end