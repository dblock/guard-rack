Guard::Rack
===========

[![Gem Version](http://img.shields.io/gem/v/guard-rack.svg)](http://badge.fury.io/rb/guard-rack)
[![Build Status](http://img.shields.io/travis/dblock/guard-rack.svg)](https://travis-ci.org/dblock/guard-rack)
[![Dependency Status](https://gemnasium.com/dblock/guard-rack.svg)](https://gemnasium.com/dblock/guard-rack)
[![Code Climate](https://codeclimate.com/github/dblock/guard-rack.svg)](https://codeclimate.com/github/dblock/guard-rack)

Want to restart your Rack development with *rackup* whilst you work? Now you can!

    guard 'rack', :port => 9292 do
      watch('Gemfile.lock')
      watch(%r{^(config|lib|app)/.*})
    end

Options
-------

* `:host` is the host ip address to run on (default `0.0.0.0`)
* `:port` is the port number to run on (default `9292`)
* `:environment` is the environment to use (default `development`)
* `:start_on_start` will start the server when starting Guard (default `true`)
* `:force_run` kills any process that's holding open the listen port before attempting to (re)start Rack (default `false`).
* `:daemon` runs the server as a daemon, without any output to the terminal that ran `guard` (default `false`).
* `:debugger` runs the server with the debugger enabled (default `false`). Required ruby-debug gem.
* `:timeout` waits this number of seconds when restarting the Rack server before reporting there's a problem (default `20`).
* `:server` serve using server (one of `webrick`, `mongrel` or `thin`).
* `:config` run the specified rackup file (default `config.ru`).

Contributing
------------

Fork the project. Make your feature addition or bug fix with tests. Send a pull request. Bonus points for topic branches.

Copyright and License
---------------------

MIT License, see [LICENSE](http://github.com/dblock/guard-rack/raw/master/LICENSE.md) for details.

(c) 2012-2014 [Daniel Doubrovkine](http://github.com/dblock) and [Contributors](https://github.com/dblock/guard-rack/graphs/contributors).

