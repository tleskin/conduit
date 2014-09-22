module Conduit::Driver::MyDriver
  class Foo < Conduit::Core::Action

    remote_url 'http://foo.com/api.xml'

    required_attributes :foo, :bar, :baz
    optional_attributes :buz

    private

    def response_class
      Conduit::Driver::MyDriver::Response
    end
  end
end
