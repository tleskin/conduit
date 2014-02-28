require 'conduit/drivers/fusion/parsers/base'

module Conduit::Driver::Fusion
  class ChangeNumber::Parser < Parser::Base

    def msid
      string_path('/BeQuick/response/msid/text()')
    end

    def mdn
      string_path('/BeQuick/response/newMDN/text()').gsub(/\D/, '')
    end

  end
end
