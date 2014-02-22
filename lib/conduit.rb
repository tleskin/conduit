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
    autoload :Render,     'conduit/core/render'
    autoload :Action,     'conduit/core/action'
    autoload :Driver,     'conduit/core/driver'

  end

  module Driver

    class << self
      # Store a list of available drivers
      #
      # e.g.
      # Conduit::Driver.index
      # => [:foo, :bar, :baz]
      #
      def index
        @index ||= []
      end

      # Load the drivers automatically, but only when they're needed
      #
      def load_drivers
        Dir["#{Conduit::Configuration.driver_path}/**/driver.rb"].each do |file|
          name = File.dirname(file).split(File::SEPARATOR).last.classify.to_sym
          index << name.downcase
          autoload name, file
        end
      end

    end
  end

  # Load the main application configuration if
  # none is provided, we load sane defaults
  #
  def self.configure(&block)
    Configuration.configure(&block)
  end

end
