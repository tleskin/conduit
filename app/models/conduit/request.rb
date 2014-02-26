module Conduit
  class Request < ActiveRecord::Base
    include Conduit::Concerns::Storage

    serialize :options, Hash

    # Associations

    has_many    :responses,   dependent: :destroy
    belongs_to  :requestable, polymorphic: true

    # Validations

    validates :driver, presence: true
    validates :action, presence: true

    # Hooks

    after_initialize  :set_defaults
    after_update      :update_requestable

    # Methods

    # Overriding this method fixes an issue
    # where content isn't set until after
    # the raw action is instantiated
    #
    def content
      raw.view || super
    end

    # Perform the requested action
    # for the specified driver
    #
    def perform_request
      if response = raw.perform
        responses.create(content: response.body)
      end
    end

    private

      # Set some default values
      #
      def set_defaults
        self.status ||= "open"
      end

      # Generate a unique storage key
      # TODO: Dynamic File Format
      #
      def generate_storage_path
        update_column(:file, File.join("#{id}".reverse!,
          driver.to_s, action.to_s, "request.xml"))
      end

      # Notify the requestable that our status
      # has changed. This is done by calling
      # a predefined method name on the
      # requestable instance
      #
      # NOTE: This could probably be better
      #       handled by observers, or a
      #       custom callback.
      #
      def update_requestable
        last_response = responses.last
        requestable.after_conduit_update(action,
          last_response.parsed_content) if requestable
      end

      # Raw access to the action instance
      #
      def raw
        @raw ||= Conduit::Util.find_driver(driver,
          action).new(options)
      end

  end
end
