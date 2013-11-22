#
# The job of this class is to require all
# actions belonging to this driver
#
# e.g.
# => module Conduit
# =>   module Driver
# =>     class MyDriver
# =>       extend Conduit::Core::Driver
# =>     end
# =>   end
# => end
#

module Conduit
  module Core
    module Driver

      # When this module is extended
      # it will search for, and require
      # the action files
      #
      def self.extended(base)
        base.send :path, path_for(caller, 'actions')
        base.send :path, path_for(caller, 'parsers')
      end

      # Set a default action path based on the
      # callers location. Can be overriden
      # using path 'path/to/folder'.
      #
      def self.path_for(kaller, dir)
        f = kaller.first.split(':').first
        File.join(File.dirname(f), dir)
      end

      # Require all action classes
      #
      # e.g.
      # => path File.join(File.dirname(__FILE__), 'actions')
      #
      def path(p)
        Dir["#{p}/*.rb"].each do |f|
          require f
          action f if p =~ /actions/
        end if Dir.exists?(p)
      end

      # Storage array of available actions
      #
      def actions
        @actions ||= []
      end

      # Store the actions in an array
      #
      def action(f)
        (actions << File.basename(f, ".*")
          .underscore).uniq
      end

    end
  end
end
