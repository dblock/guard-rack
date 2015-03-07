require 'fileutils'
require 'timeout'
require 'spoon'
require 'guard/rack/command'

module Guard
  class RackRunner
    attr_reader :options, :pid

    def initialize(options)
      @options = options
    end

    def start
      kill_unmanaged_pid! if options[:force_run]
      @pid = run_rack_command!
      true
    end

    def stop
      # Rely on kill_unmanaged_pid if there's no pid
      return true unless @pid

      exitstatus = kill(@pid)
      @pid = nil
      if exitstatus && exitstatus != 0
        UI.info "Rackup exited with non-zero exit status (#{exitstatus}) whilst trying to stop."
        return false
      end

      true
    end

    def restart
      stop && start
    end

    private

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

    def run_rack_command!
      command = Guard::Rack::Command.new(options).build
      UI.debug("Running Rack with command: #{command}")
      spawn(*command)
    end

    def spawn(* args)
      Spoon.spawnp(* args)
    end

    def kill_unmanaged_pid!
      pid = unmanaged_pid
      kill(pid, true) if pid
    end

    def unmanaged_pid
      `lsof -n -i TCP:#{options[:port]}`.each_line do |line|
        return line.split("\s")[1].to_i if line["*:#{options[:port]} "]
      end
      nil
    end
  end
end
