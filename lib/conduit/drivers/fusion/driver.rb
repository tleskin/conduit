module Conduit::Driver
  class Fusion
    extend Conduit::Core::Driver

    required_credentials :clec_id, :username, :token

    action :purchase
    action :activate
    action :deactivate
    action :suspend
    action :swap

  end
end
