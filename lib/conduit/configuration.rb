#
# The job of this class is to provide common
# configuration options to conduit
#

module Conduit
  class << self
    attr_accessor :configuration
  end

  def self.configuration
    @configuration ||= Configuration.new
  end

  def self.configure(&block)
    yield configuration
  end

  class Configuration
    attr_accessor :storage_config, :driver_paths

    def storage
      path = File.join(__dir__, '../', 'tmp', 'conduit')
      @storage_config ||= { provider: :file, file_path: path }
    end

    def driver_paths
      default_path = "#{File.dirname(__FILE__)}/drivers"
      @driver_paths ||= Array(default_path)
    end
  end
end
