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

    after_create :perform_request, prepend: true

    # Methods

    # Overriding this method fixes an issue
    # where content isn't set until after
    # the raw action is instantiated
    #
    def content
      raw.view || super
    end

    private

      # Generate a unique storage key
      # TODO: Dynamic File Format
      #
      def generate_storage_path
        update_column(:file, File.join("#{id}".reverse!,
          driver.to_s, action.to_s, "request.xml"))
      end

      # Perform the requested action
      # for the specified driver
      #
      def perform_request
        if response = raw.perform
          responses.create(content: response.body)
        end
      end

      # Raw access to the action instance
      #
      def raw
        @raw ||= Conduit::Util.find_driver(driver, action).new(options)
      end

  end
end
