module Conduit
  module ActsAsRequestable
    extend ActiveSupport::Concern

    module ClassMethods

      # Define a method that can be used to inject
      # methods into an ActiveRecord Model
      #
      def acts_as_requestable
        include Conduit::ActsAsRequestable::LocalInstanceMethods

        has_many :conduit_requests, as: 'requestable',
          class_name: 'Conduit::Request'
      end

    end

    # These methods are included when acts_as_requestable
    # is called on an ActiveRecord Model
    #
    module LocalInstanceMethods

      delegate :status, to: :last_conduit_request, prefix: true, allow_nil: true
      delegate :action, to: :last_conduit_request, prefix: true, allow_nil: true

      # Return a reference to the most recent
      # conduit request
      #
      # TODO: Update for efficiency if needed
      #
      def last_conduit_request
        conduit_requests.order(:created_at)
          .limit(1).first
      end

    end

  end
end

ActiveRecord::Base.send :include, Conduit::ActsAsRequestable
