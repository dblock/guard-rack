require 'guard/rack'

module Guard
  class Rack < Plugin
    class Command
      # The options passed to the Rack command
      #
      # @api public
      #
      # @example
      #   command.options
      #     #=> {cmd: 'rackup', configuration: 'config.ru',
      #          environment: 'development', host: '0.0.0.0',
      #          port: 9292}
      #
      # @attr_reader options [Hash]
      # @return [Hash]
      attr_reader :options

      # Creates a new instance of the command to launch Rack
      #
      # @api public
      #
      # @example
      #   command.new(cmd: 'rackup', host: '0.0.0.0', port: 9292,
      #               environment: 'development')
      #
      # @return [Guard::Rack::Command]
      def initialize(options = {})
        @options = options
      end

      # Builds the command into an array expected by Spoon
      #
      # @api public
      #
      # @todo Refactor this out to only use the command itself
      #
      # @example
      #   command.build
      #     #=> ['rackup', 'config.ru', '--env', 'development',
      #          '--host', '0.0.0.0', '--port', '9292']
      #
      # @return [Array]
      def build
        cmd = [options[:cmd]]

        cmd << configuration
        cmd << environment
        cmd << host
        cmd << port
        cmd << daemon
        cmd << debug
        cmd << server

        cmd.flatten.compact
      end

      private

      # Specifies the Rack file to run
      #
      # @api private
      #
      # @return [Array]
      def configuration
        [options[:config]]
      end

      # Specifies the daemon configuration
      #
      # @api private
      #
      # @return [Array]
      def daemon
        return unless options[:daemon]

        ['--daemonize']
      end

      # Specifies the debug configuration
      #
      # @api private
      #
      # @return [Array]
      def debug
        return unless options[:debugger]

        ['--debug']
      end

      # Specifies the environment configuration
      #
      # @api private
      #
      # @return [Array]
      def environment
        ['--env', options[:environment].to_s]
      end

      # Specifies the host configuration
      #
      # @api private
      #
      # @return [Array]
      def host
        ['--host', options[:host]]
      end

      # Specifies the port configuration
      #
      # @api private
      #
      # @return [Array]
      def port
        ['--port', options[:port].to_s]
      end

      # Specifies the server configuration
      #
      # @api private
      #
      # @return [Array]
      def server
        return unless options[:server]

        ['--server', options[:server].to_s]
      end
    end
  end
end
