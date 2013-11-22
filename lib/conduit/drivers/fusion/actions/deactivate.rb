module Conduit::Driver::Fusion
  class Deactivate < Conduit::Core::Action

    remote_url 'http://72.5.22.217/perl/xml/gateway.cgi'

    required_attributes :clec_id, :username, :token, :mdn

    optional_attributes :originatingControlNumber, :originatingClientId, :originatingOrderId

    # Required entry method, the main driver
    # class will use this to trigger the
    # request.
    #
    def perform
      raise 'Deactivate Not Yet Suported'
    end

  end
end

# Conduit::Request.create(driver: 'fusion', action: 'deactivate', options: { clec_id: 216, username: 'EZ Admin',
#  token: '5RO4NB7V86B8GBY', mdn: '4052207357', plan_id: 313 })
