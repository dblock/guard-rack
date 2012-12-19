require 'fileutils'

module Guard
  class RackRunner

    MAX_WAIT_COUNT = 10

    attr_reader :options

    def initialize(options)
      @options = options
    end

    def kill pid
      system %{kill -INT #{pid}}
      $?.exitstatus
    end

    def start
      kill_unmanaged_pid! if options[:force_run]
      run_rack_command!
      wait_for_pid
    end

    def stop
      # Rely on kill_unmanaged_pid if there's no pid file
      return true unless File.file?(pid_file)
 
      if kill(pid) == 0
        wait_for_no_pid
        remove_pid_file
      else
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
        '--port', options[:port],
        '--pid', pid_file
      ]

      rack_options << '--daemonize' if options[:daemon]
      rack_options << '--debug' if options[:debugger]
      rack_options << ["--server",options[:server]] if options[:server]

      %{sh -c 'cd #{Dir.pwd} && rackup #{rack_options.join(' ')} &'}
    end

    def pid_file
      File.expand_path(".guard-rack-#{options[:environment]}.pid")
    end

    def pid
      File.file?(pid_file) ? File.read(pid_file).to_i : nil
    end

    def remove_pid_file
      FileUtils.rm pid_file if File.exist? pid_file
    end

    def sleep_time
      options[:timeout].to_f / MAX_WAIT_COUNT.to_f
    end

    private
    
    def run_rack_command!
      system build_rack_command
    end

    def has_pid?
      File.file?(pid_file)
    end

    def wait_for_pid_action
      sleep sleep_time
    end

    def kill_unmanaged_pid!
      if pid = unmanaged_pid
        kill pid
        wait_for_no_pid
        remove_pid_file
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

    private

      def wait_for_pid
        wait_for_pid_loop
      end

      def wait_for_no_pid
        wait_for_pid_loop(false)
      end

      def wait_for_pid_loop(check_for_existince = true)
        count = 0
        while !(check_for_existince ? has_pid? : !has_pid?) && count < MAX_WAIT_COUNT
          wait_for_pid_action
          count += 1
        end
        !(count == MAX_WAIT_COUNT)
      end
      
  end
end
