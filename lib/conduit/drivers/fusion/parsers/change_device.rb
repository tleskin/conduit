require 'conduit/drivers/fusion/parsers/base'

module Conduit::Driver::Fusion
  class ChangeDevice::Parser < Parser::Base

    def mdn
      string_path('/reponse/mdn')
    end

    def msid
      string_path('/reponse/msid')
    end

    def msl
      string_path('/reponse/msl')
    end

    def esn
      string_path('/reponse/esn')
    end

  end
end
