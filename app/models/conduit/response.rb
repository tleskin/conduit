module Conduit
  class Response < ActiveRecord::Base
    include Conduit::Concerns::Storage

    # Associations

    belongs_to :request

    # Validations

    validates :request, presence: true

    # Methods

    delegate :driver, :action, to: :request

    private

      # Generate a storage key based on parent request
      # TODO: Dynamic File Format
      #
      def generate_storage_path
        update_column(:file, File.join(File.dirname(request.file),
          "#{id}-response.xml"))
      end

      # Raw access to the action instance
      #
      def raw
        @raw ||= Conduit::Util.find_driver(driver, action, 'parser').new(content)
      end

  end
end
