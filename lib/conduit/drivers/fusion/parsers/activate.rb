require 'conduit/drivers/fusion/parsers/base'

module Conduit::Driver::Fusion
  class Activate::Parser < Parser::Base

    def mdn
      string_path('/reponse/mdn')
    end

    def msl
      string_path('/reponse/msl')
    end

    def nid
      string_path('/reponse/esn')
    end

    def msid
      string_path('/reponse/msid')
    end

  end
end
