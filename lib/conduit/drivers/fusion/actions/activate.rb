module Conduit::Driver::Fusion
  class Activate < Conduit::Core::Action

    remote_url 'http://72.5.22.217/perl/xml/gateway.cgi'
    required_attributes *Conduit::Driver::Fusion.credentials, :plan_id, :esn,
      :first_name, :last_name, :city, :state, :zip, :address1, :address2

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
