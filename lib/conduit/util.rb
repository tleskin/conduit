module Conduit
  module Util

    # Instantiate the action class with options
    #
    # returns:
    # => Conduit::Driver::Fusion::Purchase
    #
    def self.find_driver(*args)
      driver = args.map(&:to_s).map(&:camelize).join('::')
      Conduit::Driver.const_get(driver)
    rescue NameError => error
      message = "Unable to find driver with arguments: #{args.join ','}. " +
        "Expected #{error.name} to be implemented"
      raise NameError(message)
    end

  end
end
