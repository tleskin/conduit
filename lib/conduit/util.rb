module Conduit
  module Util

    # Instantiate the action class with options
    #
    # returns:
    # => Conduit::Driver::Fusion::Purchase
    #
    def self.find_driver(*args)
      driver = args.map(&:to_s).map(&:classify).join('::')
      Conduit::Driver.const_get(driver)
    rescue NameError
      # TODO: Determine the best course of action for failure
    end

  end
end