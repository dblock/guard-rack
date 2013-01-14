require 'fileutils'
require 'timeout'

module Guard
  class RackRunner

    attr_reader :options, :pid

    def initialize(options)
      @options = options
    end

    def kill
      result = -1

      Process.kill("INT", @pid)
      begin
        Timeout.timeout(options[:timeout]) do
          _, status = Process.wait2(@pid)
          result = status.exitstatus
        end
      rescue Timeout::Error
        Process.kill(9, @pid)
      end
      @pid = nil

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

      if kill != 0
        UI.info "Rackup exited with non-zero exit status whilst trying to stop."
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

      %{cd #{Dir.pwd} && rackup #{rack_options.join(' ')}}
    end

    private

    def run_rack_command!
      Process.spawn(build_rack_command)
    end

    def kill_unmanaged_pid!
      if pid = unmanaged_pid
        kill pid
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
