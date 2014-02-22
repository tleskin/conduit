module Conduit::Driver::MyDriver
  class Foo::Parser

    def initialize(xml)
      @xml = xml
    end

    def action_response_status
      "success"
    end

  end
end
