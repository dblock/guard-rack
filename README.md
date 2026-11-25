# Guard::Rack

[![Gem Version](https://img.shields.io/gem/v/guard-rack.svg)](https://badge.fury.io/rb/guard-rack) [![Test](https://github.com/dblock/guard-rack/actions/workflows/test.yml/badge.svg?branch=master)](https://github.com/dblock/guard-rack/actions/workflows/test.yml)

Want to restart your Rack development with `rackup` whilst you work? Now you can!

```ruby
guard 'rack', port: 9292 do
  watch('Gemfile.lock')
  watch(%r{^(config|lib|app)/.*})
end
```

## Options

* `:cmd` is the command to run to mount the Rack application (default `rackup`).
* `:host` is the host IP address to run on (default `0.0.0.0`).
* `:port` is the port number to run on (default `9292`).
* `:environment` is the environment to use (default `development`).
* `:start_on_start` will start the server when starting Guard (default `true`).
* `:force_run` kills any process that's holding open the listen port before attempting to (re)start Rack (default `false`).
* `:daemon` runs the server as a daemon, without any output to the terminal that ran `guard` (default `false`).
* `:debugger` runs the server with the debugger enabled (default `false`). Requires the `ruby-debug` gem.
* `:timeout` waits this number of seconds when restarting the Rack server before reporting there's a problem (default `20`).
* `:server` serve using server (one of `webrick`, `mongrel` or `thin`).
* `:config` run the specified rackup file (default `config.ru`).

## Contributing

Fork the project. Make your feature addition or bug fix with tests. Send a pull request. Bonus points for topic branches.

* [CHANGELOG](CHANGELOG.md)
* [RELEASING](RELEASING.md)

## Copyright and License

MIT License, see [LICENSE](LICENSE.md) for details.

(c) 2012-2019 [Daniel Doubrovkine](https://github.com/dblock) and [Contributors](https://github.com/dblock/guard-rack/graphs/contributors).
