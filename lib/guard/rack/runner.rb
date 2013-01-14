require 'fileutils'
require 'timeout'

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
      rack_options = [
        options[:config],
        '--env', options[:environment],
        '--port', options[:port]
      ]

      rack_options << '--daemonize' if options[:daemon]
      rack_options << '--debug' if options[:debugger]
      rack_options << ["--server",options[:server]] if options[:server]

      %{rackup #{rack_options.join(' ')}}
    end

    private

    def run_rack_command!
      UI.debug("Running Rack with command: #{build_rack_command.inspect}")
      Process.spawn(build_rack_command)
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
