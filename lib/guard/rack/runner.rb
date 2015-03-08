require 'fileutils'
require 'timeout'
require 'spoon'
require 'guard/rack/command'

module Guard
  class Rack < Plugin
    class Runner
      # The options passed to the Rack command
      #
      # @api public
      #
      # @example
      #   runner.options
      #     #=> {cmd: 'rackup', configuration: 'config.ru',
      #          environment: 'development', host: '0.0.0.0',
      #          port: 9292}
      #
      # @attr_reader options [Hash]
      # @return [Hash]
      attr_reader :options

      # The ID of the managed Rack process
      #
      # @api public
      #
      # @example
      #   runner.pid #=> 1234
      #
      # @attr_reader pid [Integer]
      # @return [Integer]
      attr_reader :pid

      # Creates a new manager of the Guarded Rack process
      #
      # @api public
      #
      # @example
      #   Guard::Rack::Runner.new
      #
      # @see Guard::Rack For the possible options
      #
      # @return [Guard::Rack::Runner]
      def initialize(options)
        @options = options
      end

      # Starts the Rack process
      #
      # @api public
      #
      # @example
      #   runner.start
      #
      # @return [Boolean] A flag indicating whether the process started successfully
      def start
        kill_unmanaged_pid! if options[:force_run]
        @pid = run_rack_command!
        true
      end

      # Stops the Rack process
      #
      # @api public
      #
      # @example
      #   runner.stop
      #
      # @return [Boolean] A flag indicating whether the process stopped successfully
      def stop
        return true unless @pid

        exitstatus = kill(@pid)
        @pid = nil
        if exitstatus && exitstatus != 0
          UI.info "Rackup exited with non-zero exit status (#{exitstatus}) whilst trying to stop."
          return false
        end

        true
      end

      # Restarts the Rack process
      #
      # @api public
      #
      # @example
      #   runner.restart
      #
      # @return [Boolean] A flag indicating whether the process restarted successfully
      def restart
        stop && start
      end

      private

      # Kills the Rack process
      #
      # @api private
      #
      # @return [Integer] An exit code
      def kill(pid, force = false)
        result = -1

        UI.debug("Trying to kill Rack (PID #{pid})...")
        unless force
          Process.kill('INT', pid)
          begin
            Timeout.timeout(options[:timeout]) do
              _, status = Process.wait2(pid)
              result = status.exitstatus
              UI.debug("Killed Rack (Exit status: #{result})")
            end
          rescue Timeout::Error
            UI.debug("Couldn't kill Rack with INT, switching to TERM")
            force = true
          end
        end

        Process.kill('TERM', pid) if force

        result
      end

      # Constructs and runs the Rack process
      #
      # @api private
      #
      # @return [Integer] A process id
      def run_rack_command!
        command = Guard::Rack::Command.new(options).build
        UI.debug("Running Rack with command: #{command}")
        spawn(*command)
      end

      # Spawns the Rack process
      #
      # @api private
      #
      # @return [Integer] A process id
      def spawn(* args)
        Spoon.spawnp(* args)
      end

      # Kills an external process that is using the specified port
      #
      # @api private
      #
      # @return [void]
      def kill_unmanaged_pid!
        pid = unmanaged_pid
        kill(pid, true) if pid
      end

      # Determines the process id of a conflicting process
      #
      # @api private
      #
      # @return [Integer] A process id
      def unmanaged_pid
        `lsof -n -i TCP:#{options[:port]}`.each_line do |line|
          return line.split("\s")[1].to_i if line["*:#{options[:port]} "]
        end
        nil
      end
    end
  end
end
