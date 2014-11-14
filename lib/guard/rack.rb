require 'guard'
require 'guard/plugin'
require 'guard/rack/runner'
require 'rbconfig'

module Guard
  class Rack < ::Guard::Plugin
    attr_reader :options, :runner

    DEFAULT_OPTIONS = {
      port: 9292,
      environment: 'development',
      start_on_start: true,
      force_run: false,
      timeout: 20,
      debugger: false,
      config: 'config.ru'
    }

    def initialize(options = {})
      super
      @options = DEFAULT_OPTIONS.merge(options)
      @runner = ::Guard::RackRunner.new(@options)
    end

    def start
      server = options[:server] ? "#{options[:server]} and " : ''
      UI.info "Guard::Rack will now restart your app on port #{options[:port]} using #{server}#{options[:environment]} environment."
      reload if options[:start_on_start]
    end

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

    def stop
      Notifier.notify('Until next time...', title: 'Rack shutting down.', image: :pending)
      runner.stop
    end

    def run_on_changes(_paths)
      reload
    end
  end
end
