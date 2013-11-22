module Conduit::Driver::Example
  class Purchase < Conduit::Core::Action

    required_attributes :required_foo, :required_bar
    optional_attributes :optional_foo, :optional_bar

    # Override the view path
    #
    def view_path
      path = File.dirname(__FILE__).match(/(.*)example/)[0]
      "#{path}/views/"
    end

  end
end
