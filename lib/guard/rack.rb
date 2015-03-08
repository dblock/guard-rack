require 'guard/compat/plugin'

require 'guard/rack/options'
require 'guard/rack/runner'

module Guard
  class Rack < Plugin
    # The options passed to the Rack command when loading or reloading
    #
    # @api public
    #
    # @example
    #   Guard::Rack.new.options #=> {cmd: 'rackup', host: '0.0.0.0', port: 9292}
    #
    # @attr_reader options [Hash]
    # @return [Hash]
    attr_reader :options

    # The Guard runner that handles the loading and reloading of Rack
    #
    # @api public
    #
    # @example
    #   Guard::Rack.new.runner #=> #<Guard::Rack::Runner:... @options={...}>
    #
    # @attr_reader runner [Guard::Rack::Runner]
    # @return [Guard::Rack::Runner]
    attr_reader :runner

    # Creates a new instance of the Rack reloading Guard plugin
    #
    # @api public
    #
    # @example
    #   Guard::Rack.new(cmd: 'bundle exec rackup')
    #
    # @param options [Hash] The Guard plugin options run from the Guardfile
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
    # @return [Guard::Rack] The plugin instance
    def initialize(options = {})
      super
      @options = Options.with_defaults(options)
      @runner = Runner.new(@options)
    end

    # @!group Guard Events

    # Called when Guard starts
    #
    # @api public
    #
    # @example
    #   Guard::Rack.new.start
    #
    # @return [void]
    def start
      server = options[:server] ? "#{options[:server]} and " : ''
      UI.info "Guard::Rack will now restart your app on port #{options[:port]} using #{server}#{options[:environment]} environment."
      reload if options[:start_on_start]
    end

    # Called when Guard reloads
    #
    # @api public
    #
    # @example
    #   Guard::Rack.new.reload
    #
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

    # Called when Guard quits
    #
    # @api public
    #
    # @example
    #   Guard::Rack.new.stop
    #
    # @return [void]
    def stop
      Notifier.notify('Until next time...', title: 'Rack shutting down.', image: :pending)
      runner.stop
    end

    # Called when any watched file is changed
    #
    # @api public
    #
    # @example
    #   Guard::Rack.new.run_on_changes([...])
    #
    # @return [void]
    def run_on_changes(*)
      reload
    end

    # @!endgroup
  end
end
