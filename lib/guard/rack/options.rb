module Guard
  class Rack < Plugin
    module Options
      DEFAULTS = {
        cmd:            'rackup',
        config:         'config.ru',
        debugger:       false,
        environment:    'development',
        force_run:      false,
        host:           '0.0.0.0',
        port:           9292,
        start_on_start: true,
        timeout:        20
      }

      class << self
        # Merges the passed options with the plugin defaults
        #
        # @api public
        #
        # @example
        #   Guard::Rack::Options.with_defaults({cmd: 'bundle exec rackup'})
        #     #=> {cmd: 'bundle exec rackup', config: 'config.ru', ...}
        #
        # @return [Hash] The merged options
        def with_defaults(options = {})
          DEFAULTS.merge(options)
        end
      end
    end
  end
end
