require 'conduit/engine'
require 'conduit/acts_as_requestable'

module Conduit

  mattr_accessor :app_root

  # Autoload the Conduit base classes
  # NOTE: Autoloading should be
  #       concurrency-safe
  #
  autoload :Configuration,     'conduit/configuration'
  autoload :Storage,           'conduit/storage'
  autoload :Util,              'conduit/util'

  module Core

    # Autoload the Conduit::Core base classes
    # NOTE: Autoloading should be
    #       concurrency-safe
    #
    autoload :Connection, 'conduit/core/connection'
    autoload :Driver,     'conduit/core/driver'
    autoload :Action,     'conduit/core/action'
    autoload :Render,     'conduit/core/render'

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

  # Load the main application configuration if
  # none is provided, we load sane defaults
  #
  def self.configure(&block)
    Configuration.configure(&block)
  end

end
