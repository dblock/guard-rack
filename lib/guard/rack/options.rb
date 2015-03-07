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
        def with_defaults(options = {})
          DEFAULTS.merge(options)
        end
      end
    end
  end
end
