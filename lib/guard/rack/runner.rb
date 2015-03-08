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
      # @param options [Hash] The options for the runner and the Rack command
      # @option options [String] :cmd ('rackup') The command used to launch Rack
      # @option options [String] :config ('config.ru') The Rack configuration file
      # @option options [Boolean] :debugger (false) A flag indicating whether to run in debug mode
      # @option options [String, Symbol] :environment ('development') The Rack environment to use
      # @option options [Boolean] :force_run (false) A flag indicating whether to kill any program listening to the Rack port
      # @option options [String] :host ('0.0.0.0') The IP for Rack to listen on
      # @option options [Integer] :port (9292) The port for Rack to listen on
      # @option options [Boolean] :start_on_start (true) A flag indicating whether to start the Rack instance upon starting Guard
      # @option options [Integer] :timeout (20) The number of seconds to wait for Rack to start up before failing
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
