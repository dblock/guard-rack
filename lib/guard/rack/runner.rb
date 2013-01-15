require 'fileutils'
require 'timeout'
require 'posix/spawn'

module Guard
  class RackRunner

    attr_reader :options, :pid

    def initialize(options)
      @options = options
    end

    def kill(pid, force = false)
      result = -1

      UI.debug("Trying to kill Rack (PID #{pid})...")
      if !force
        Process.kill("INT", pid)
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

      if force
        Process.kill("TERM", pid)
      end

      result
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
      if exitstatus != 0
        UI.info "Rackup exited with non-zero exit status (#{exitstatus}) whilst trying to stop."
        return false
      end

      true
    end

    def restart
      stop and start
    end

    def build_rack_command
      command = %w{rackup}
      command.push(
        options[:config],
        '--env', options[:environment].to_s,
        '--port', options[:port].to_s
      )

      command << '--daemonize' if options[:daemon]
      command << '--debug' if options[:debugger]
      command.push("--server", options[:server].to_s) if options[:server]

      command
    end

    private

    def run_rack_command!
      command = build_rack_command
      UI.debug("Running Rack with command: #{command.inspect}")
      POSIX::Spawn.spawn(*command)
    end

    def kill_unmanaged_pid!
      if pid = unmanaged_pid
        kill(pid, true)
      end
    end

    def unmanaged_pid
      %x{lsof -n -i TCP:#{options[:port]}}.each_line { |line|
        if line["*:#{options[:port]} "]
          return line.split("\s")[1].to_i
        end
      }
      nil
    end
  end
end
