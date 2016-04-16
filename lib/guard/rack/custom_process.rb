require 'timeout'

module Guard
  class Rack
    class CustomProcess
      attr_reader :options

      def self.new(options = {})
        if Gem.win_platform?
          os_instance = Windows.allocate
        else
          os_instance = Nix.allocate
        end
        os_instance.send :initialize, options
        os_instance
      end

      def initialize(options)
        @options = options
      end

      class Nix < Rack::CustomProcess
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
      end

      class Windows < Rack::CustomProcess
        def kill(pid, _force = true)
          # Doesn't matter if its forceful or not. There's only one way of ending it
          system("taskkill /pid #{pid} /T /f")
          result = $CHILD_STATUS.exitstatus
          if result == 0
            UI.debug("Killed Rack (Exit status: #{result})")
          else
            UI.debug("Couldn't kill Rack")
          end
          result
        end
      end
    end
  end
end
