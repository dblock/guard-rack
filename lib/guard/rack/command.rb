require 'guard/rack'

module Guard
  class Rack < Plugin
    class Command < String
      attr_reader :options

      def initialize(options = {})
        @options = options
        super(build.join(' '))
      end

      private

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

      def configuration
        [options[:config]]
      end

      def daemon
        return unless options[:daemon]

        ['--daemonize', options[:daemon]]
      end

      def debug
        return unless options[:debugger]

        ['--debug', options[:debugger]]
      end

      def environment
        ['--env', options[:environment]]
      end

      def host
        ['--host', options[:host]]
      end

      def port
        ['--port', options[:port]]
      end

      def server
        return unless options[:server]

        ['--server', options[:server]]
      end
    end
  end
end
