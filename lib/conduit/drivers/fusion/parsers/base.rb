require 'nokogiri'
  
module Conduit::Driver::Fusion
  module Parser
    class Base < Conduit::Core::Base
      attr_accessor :xml

      def initialize(xml)
        @xml = xml
      end

      def timestamp
        string_path('/BeQuick/response/@timestamp')
      end

      def status
        string_path('/BeQuick/response/@status')
      end

      def type
        string_path('/BeQuick/response/@type')
      end

      # Return an session object
      #
      # e.g.
      # parser.session
      # =>
      #
      def session
        if str = string_path('/BeQuick/session')
          Hash.from_xml(str)['session']
        end
      end

      # Return an array of error objects
      #
      # e.g.
      # parser.errors
      # => [#<OpenStruct code="X104", message="CLEC Profile not found">]
      #
      def errors
        object_path('/BeQuick/response/errors/error').map do |error|
          Hash.from_xml(error.to_s)['error']
        end
      end

      # Return "success/failure". This gets
      # returned to the request object
      # as a type of notification
      #
      def action_response_status
        status
      end

      private

        # Return a Nokogiri::XML object
        #
        # @xml must be set. You can either set
        # it in the initializer, or assign it
        # manually, but it must be set.
        #
        def doc
          @doc ||= Nokogiri::XML(@xml)
        end

        # Return a attribute/element object from doc
        #
        # e.g.
        # object_path('//resources/@timestamp')
        # => [#<Nokogiri::XML::Attr:0x3fca8b040818 name="timestamp" value="20140130180057">]
        #
        def object_path(path, node=doc)
          node.xpath(path)
        end

        # Return a string from a attribute/element
        #
        # e.g.
        # string_path('//resources/@timestamp')
        # => 20140130180057
        #
        def string_path(path, node=doc)
          object_path(path, node).to_s
        end

    end
  end
end
