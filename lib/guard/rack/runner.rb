require 'fileutils'
require 'spoon'
require 'guard/rack/command'
require 'guard/rack/custom_process'

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
      Guard::Rack::CustomProcess.new(options).kill pid, force
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
