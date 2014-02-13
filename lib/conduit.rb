require 'conduit/core/connection'
require 'conduit/configuration'
require 'conduit/core/driver'
require 'conduit/core/action'
require 'conduit/core/render'
require 'conduit/storage'
require 'conduit/engine'
require 'conduit/util'

module Conduit

  class << self

    def configure(&block)
      Configuration.configure(&block)
    end

  end

  module Driver

    # Store a list of available drivers
    #
    # e.g.
    # Conduit::Driver.index
    # => [:foo, :bar, :baz]
    #
    def self.index
      @index ||= []
    end

    # Load the drivers automatically, but only when they're needed
    #
    Dir["#{File.dirname(__FILE__)}/conduit/drivers/**/driver.rb"].each do |file|
      name = File.dirname(file).split(File::SEPARATOR).last.classify.to_sym
      index << name.downcase
      autoload name, file
    end

  end
end
