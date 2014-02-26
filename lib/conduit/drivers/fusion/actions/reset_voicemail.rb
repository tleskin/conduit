module Conduit::Driver::Fusion
  class ResetVoicemail < Conduit::Core::Action

    remote_url 'http://72.5.22.217/perl/xml/gateway.cgi'
    required_attributes *Conduit::Driver::Fusion.credentials, :mdn

    # Required entry method, the main driver
    # class will use this to trigger the
    # request.
    #
    def perform
      request(body: URI.encode_www_form({
        request: view
      }), method: :post)
    end

  end
end
