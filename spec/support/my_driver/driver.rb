module Conduit::Driver::MyDriver
  extend Conduit::Core::Driver

  required_credentials :username, :password
  required_attributes  :subdomain
  optional_attributes  :mock
  action :foo

end
