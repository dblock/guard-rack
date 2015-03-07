require 'guard/compat/plugin'

require 'guard/rack/options'
require 'guard/rack/runner'

module Guard
  class Rack < Plugin
    # The options passed to the Rack command when loading or reloading
    #
    # @example
    #   options #=> {cmd: 'rackup', host: '0.0.0.0', port: 9292}
    # @api public
    # @attr_reader options [Hash]
    # @return [Hash]
    attr_reader :options

    # The Guard runner that handles the loading and reloading of Rack
    #
    # @example
    #   runner #=> #<Guard::Rack::Runner:... @options={...}>
    # @api public
    # @attr_reader runner [Guard::Rack::Runner]
    # @return [Guard::Rack::Runner]
    attr_reader :runner

    # Creates a new instance of the Rack reloading Guard plugin
    #
    # @example
    #   Guard::Rack.new(cmd: 'bundle exec rackup')
    # @api public
    # @return [Guard::Rack]
    def initialize(options = {})
      super
      @options = Options.with_defaults(options)
      @runner = Runner.new(@options)
    end

    # Starts the instance of Rack managed by the Guard plugin
    #
    # @example
    #   start
    #
    # @api public
    # @return [void]
    def start
      server = options[:server] ? "#{options[:server]} and " : ''
      UI.info "Guard::Rack will now restart your app on port #{options[:port]} using #{server}#{options[:environment]} environment."
      reload if options[:start_on_start]
    end

    # Reloads the instance of Rack managed by the Guard plugin
    #
    # @example
    #   reload
    # @api public
    # @return [void]
    def reload
      UI.info 'Restarting Rack...'
      Notifier.notify("Rack restarting on port #{options[:port]} in #{options[:environment]} environment...", title: 'Restarting Rack...', image: :pending)
      if runner.restart
        UI.info "Rack restarted, pid #{runner.pid}"
        Notifier.notify("Rack restarted on port #{options[:port]}.", title: 'Rack restarted!', image: :success)
      else
        UI.info 'Rack NOT restarted, check your log files.'
        Notifier.notify('Rack NOT restarted, check your log files.', title: 'Rack NOT restarted!', image: :failed)
      end
    end

    # Stops the instance of Rack managed by the Guard plugin
    #
    # @example
    #   stop
    # @api public
    # @return [void]
    def stop
      Notifier.notify('Until next time...', title: 'Rack shutting down.', image: :pending)
      runner.stop
    end

    # Reloads the instance of Rack whenever the Guard-watched files are changes
    #
    # @example
    #   run_on_changes([...])
    # @api public
    # @return [void]
    def run_on_changes(_paths)
      reload
    end
  end
end
