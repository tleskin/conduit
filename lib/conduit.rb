$LOAD_PATH.unshift File.dirname(__FILE__)

require 'conduit/configuration'

module Conduit

  # Autoload the Conduit base classes
  # NOTE: Autoloading should be
  #       concurrency-safe
  #
  autoload :Storage,          'conduit/storage'
  autoload :Util,             'conduit/util'
  autoload :ApiResponse,      'conduit/api_response'
  autoload :ConnectionError,  'conduit/connection_error'
  autoload :TimeOut,          'conduit/time_out'

  module Core

    # Autoload the Conduit::Core base classes
    # NOTE: Autoloading should be
    #       concurrency-safe
    #
    autoload :Connection,     'conduit/core/connection'
    autoload :Render,         'conduit/core/render'
    autoload :Action,         'conduit/core/action'
    autoload :Parser,         'conduit/core/parser'
    autoload :Driver,         'conduit/core/driver'
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
        Conduit.configuration.driver_paths.each do |dir|
          raise "Directory not found: #{dir}" unless File.exist?(dir)
          Dir["#{dir}/**/driver.rb"].each do |file|
            raise "File not found: #{file}" unless File.exist?(file)
            name = File.dirname(file).split(File::SEPARATOR).last.classify.to_sym
            index << name.downcase
            autoload name, file
          end
        end
      end

    end
  end

end
