require 'nokogiri'

module Conduit::Driver::MyDriver
  class Foo::Parser < Conduit::Core::Parser

    def initialize(xml)
      @xml = xml
    end

    attribute :foo do
      'foo'
    end

    attribute :bar do
      'bar'
    end

    attribute :baz do
      'baz'
    end

    # Return "success/failure". This gets
    # returned to the request object
    # as a type of notification
    #
    def response_status
      string_path('/BeQuick/response/@status')
    end

    # Return an array of error objects
    #
    # e.g.
    # parser.errors
    # => [{"code"=>nil, "message"=>"Unable to locate telephone by MDN"}]
    #
    def response_errors
      object_path('/BeQuick/response/errors/error').map do |error|
        Hash.from_xml(error.to_s)['error']
      end
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
    def object_path(path, node = doc)
      node.xpath(path)
    end

    # Return a string from a attribute/element
    #
    # e.g.
    # string_path('//resources/@timestamp')
    # => 20140130180057
    #
    def string_path(path, node = doc)
      object_path(path, node).to_s
    end

  end
end
