module Conduit::Driver
  module Fusion
    extend Conduit::Core::Driver

    required_credentials :clec_id, :username, :token

    action :reset_voicemail
    action :change_device
    action :change_number
    action :deactivate
    action :activate
    action :purchase
    action :suspend
    action :restore
    action :query_subscription

  end
end
