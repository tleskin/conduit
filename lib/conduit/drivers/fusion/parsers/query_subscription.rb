require 'conduit/drivers/fusion/parsers/base'

module Conduit::Driver::Fusion
  class QuerySubscription::Parser < Parser::Base

    def line_status
      string_path('/BeQuick/response/status/text()')
    end

    def account_number
      string_path('/BeQuick/response/customerAccount/text()')
    end

    def mdn
      string_path('/BeQuick/response/mdn/text()').gsub(/\D/, '')
    end

    def msid
      string_path('/BeQuick/response/msid/text()')
    end

    def msl
      string_path('/BeQuick/response/msl/text()')
    end

    def nid
      string_path('/BeQuick/response/esn/text()')
    end

    def available_minutes
      string_path('/BeQuick/response/totalMinutes/text()')
    end

    def available_texts
      string_path('/BeQuick/response/totalTexts/text()')
    end

    def available_data
      string_path('/BeQuick/response/totalData/text()')
    end

    def current_plan_code
      string_path('/BeQuick/response/planId/text()')
    end

    def current_plan_name
      string_path('/BeQuick/response/planName/text()')
    end

    def current_plan_start_date
      string_path('/BeQuick/response/activationDate/text()')
    end

    def current_plan_end_date
      string_path('/BeQuick/response/expirationDate/text()')
    end

  end
end
