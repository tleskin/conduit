#
# The job of this module is to handle network
# communication rom Conduit to a remote host.
#

require 'conduit/version'
require 'forwardable'
require 'excon'

module Conduit
  module Core
    module Connection
      def self.included(base)
        base.extend ClassMethods
        base.send :include, InstanceMethods
      end

      module ClassMethods

        # Define a remote_url
        #
        # e.g.
        # remote_url 'http://myapi.com/endpoint'
        #
        def remote_url(host = nil)
          @remote_url ||= host
        end

      end

      module InstanceMethods
        extend Forwardable

        def_delegator :'self.class', :remote_url

        # Make a request
        #
        # @param [Hash] params
        # @option params [String] :body text to be sent over a socket
        # @option params [Hash<Symbol, String>] :headers The default headers to supply in a request
        # @option params [String] :host The destination host's reachable DNS name or IP, in the form of a String
        # @option params [String] :path appears after 'scheme://host:port/'
        # @option params [Fixnum] :port The port on which to connect, to the destination host
        # @option params [Hash]   :query appended to the 'scheme://host:port/path/' in the form of '?key=value'
        # @option params [String] :scheme The protocol; 'https' causes OpenSSL to be used
        # @option params [Proc] :response_block
        #
        #
        def request(params, &block)
          params[:headers] ||= {}
          params[:headers]['User-Agent'] ||= "conduit/#{Conduit::VERSION}"
          connection.request(params, &block)
        rescue Excon::Errors::Timeout => timeout
          raise(Conduit::Timeout, timeout.message)
        rescue Excon::Errors::Error => error
          raise(Conduit::ConnectionError, error.message)
        rescue SocketError => error
          msg = 'Could not connect to the server.  Please check your internet connection.' +
            "\n#{error.message}"
          raise(Conduit::ConnectionError, msg)
        end

        private

        # Connection that will be used
        #
        # @param [Hash] params
        # @option params [String] :body Default text to be sent over a socket. Only used if :body absent in Connection#request params
        # @option params [Hash<Symbol, String>] :headers The default headers to supply in a request. Only used if params[:headers] is not supplied to Connection#request
        # @option params [String] :host The destination host's reachable DNS name or IP, in the form of a String
        # @option params [String] :path Default path; appears after 'scheme://host:port/'. Only used if params[:path] is not supplied to Connection#request
        # @option params [Fixnum] :port The port on which to connect, to the destination host
        # @option params [Hash]   :query Default query; appended to the 'scheme://host:port/path/' in the form of '?key=value'. Will only be used if params[:query] is not supplied to Connection#request
        # @option params [String] :scheme The protocol; 'https' causes OpenSSL to be used
        # @option params [String] :proxy Proxy server; e.g. 'http://myproxy.com:8888'
        # @option params [Fixnum] :retry_limit Set how many times we'll retry a failed request.  (Default 4)
        # @option params [Class] :instrumentor Responds to #instrument as in ActiveSupport::Notifications
        # @option params [String] :instrumentor_name Name prefix for #instrument events.  Defaults to 'excon'
        #
        # @return [Excon::Response]
        #
        # @raise [Excon::Errors::StubNotFound]
        # @raise [Excon::Errors::Timeout]
        # @raise [Excon::Errors::SocketError]
        #
        def connection(**params)
          @excon ||= Excon.new(remote_url, params)
        end

      end

    end
  end
end
