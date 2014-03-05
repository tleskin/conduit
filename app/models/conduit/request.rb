module Conduit
  class Request < ActiveRecord::Base
    include Conduit::Concerns::Storage

    serialize :options, Hash

    # Associations

    has_many :responses,   dependent: :destroy
    has_many :subscriptions, autosave: true

    # Validations

    validates :driver, presence: true
    validates :action, presence: true

    # Hooks

    after_initialize  :set_defaults
    after_update      :notify_subscribers

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

    # Allow creation of subscriptions through the
    # subscribers virtual attribute.
    #
    # NOTE: This is usually possible by default with a
    #       has_many :through, but with polymorphic
    #       association it gets more complicated.
    #
    def subscribers=(args)
      args.map do |arg|
        next unless arg.class < ActiveRecord::Base
        subscriptions.build(subscriber: arg)
      end
    end

    # Fetch a list of subscribers through
    # the subscriptions association
    #
    # NOTE: This is usually possible by default with a
    #       has_many :through, but with polymorphic
    #       association it gets more complicated.
    #
    def subscribers
      subscriptions.map(&:subscriber)
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
      def notify_subscribers
        last_response = responses.last
        subscribers.each do |subscriber|
          subscriber.after_conduit_update(action,
            last_response.parsed_content)
        end
      end

      # Raw access to the action instance
      #
      def raw
        @raw ||= Conduit::Util.find_driver(driver,
          action).new(options.symbolize_keys!)
      end

  end
end
