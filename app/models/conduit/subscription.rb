module Conduit
  class Subscription < ActiveRecord::Base
    belongs_to :subscriber, polymorphic: true
    belongs_to :request, class_name: 'Conduit::Request'
  end
end