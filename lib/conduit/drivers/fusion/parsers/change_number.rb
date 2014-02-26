require 'conduit/drivers/fusion/parsers/base'

module Conduit::Driver::Fusion
  class ChangeNumber::Parser < Parser::Base

    def msid
      string_path('/reponse/msid')
    end

    def mdn
      string_path('/reponse/newMDN')
    end

  end
end
