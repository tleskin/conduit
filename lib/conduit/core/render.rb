#
# The job of this module is to provide template
# rendering functionality. Included classes
# must provide a view_path, and view_context
# methods to be of any use.
#

require 'tilt'

module Conduit
  module Core
    module Render

      # Create instance variables, any of these can
      # be overriden within the including class.
      #
      # view_path:    Location where the view files are stored
      # view_context: Object that contains the variables used in the template
      #
      def self.included(base)
        attr_accessor :view_path, :view_context
      end

      # Render a template file
      #
      # e.g. Without layout
      # => render :purchase, layout: false
      #
      # e.g. With layout
      # => render :purchase
      #
      def render(file, layout: true)
        raise ViewPathNotDefined, '' unless view_path
        layout ? render_with_layout(file) : render_template(file)
      end

      # Render a template file
      #
      # e.g. Without layout
      # => render_template(:template)
      #
      # e.g. With layout
      # => render_template(:layout) do
      # =>   render_template(:template)
      # => end
      #
      def render_template(file)
        path = File.join(view_path, "#{file}.erb")
        Tilt::ERBTemplate.new(path).render(view_context) do
          yield if block_given?
        end
      end

      # Render the file with a layout
      #
      # e.g.
      # => render_layout(:template)
      #
      def render_with_layout(file)
        render_template(:layout) do
          render_template(file)
        end
      end

      class ViewPathNotDefined < StandardError; end

    end
  end
end
