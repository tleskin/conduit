module Conduit
  class ApiResponse
    attr_reader :body, :parser, :raw_response

    def initialize(options = {})
      @raw_response = options[:raw_response]
      @body         = options.fetch(:body, raw_response.body)
      @parser       = options[:parser]
    end
  end
end
