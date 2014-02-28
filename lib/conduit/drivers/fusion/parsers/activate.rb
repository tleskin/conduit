require 'conduit/drivers/fusion/parsers/base'

module Conduit::Driver::Fusion
  class Activate::Parser < Parser::Base

    def mdn
      string_path('/BeQuick/response/mdn/text()').gsub(/\D/, '')
    end

    def msl
      string_path('/BeQuick/response/msl/text()')
    end

    def nid
      string_path('/BeQuick/response/esn/text()')
    end

    def msid
      string_path('/BeQuick/response/msid/text()')
    end

  end
end
