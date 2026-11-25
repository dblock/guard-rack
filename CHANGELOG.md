### 2.3.1 (Next)

* Your contribution here.

### 2.3.0 (2026/11/25)

* [#30](https://github.com/dblock/guard-rack/pull/30): Replaced Travis CI with GitHub Actions, tested with Ruby 2.7 through 4.0 and JRuby, fixed compatibility with current Guard, Rack and RuboCop, and fixed `Guard::Rack::CustomProcess::Windows#kill` failing because `English` was not loaded - [@dblock](https://github.com/dblock).
* [#31](https://github.com/dblock/guard-rack/pull/31): Lint Markdown, YAML, and spelling with rubocop-md, rubocop-prose, rubocop-spellcheck, and rubocop-yaml in a separate Lint workflow, and clean up documentation - [@dblock](https://github.com/dblock).
* [#32](https://github.com/dblock/guard-rack/pull/32): Run CI pushes only on the default branch, cancel superseded pull request runs, skip duplicate lint in the test matrix, and bound job times - [@dblock](https://github.com/dblock).
* [#34](https://github.com/dblock/guard-rack/pull/34): Release with ruby-gem-release through a manually dispatched GitHub Actions workflow and RubyGems Trusted Publishing - [@dblock](https://github.com/dblock).
* [#35](https://github.com/dblock/guard-rack/pull/35): Fixed Rack not restarting after a change that follows a failed start, such as a syntax error in `config.ru` - [@dblock](https://github.com/dblock).

### 2.2.1 (2019/4/30)

* [#24](https://github.com/dblock/guard-rack/pull/24): Use absolute module namespace to prevent conflict with Guard::Process - [@cristianbica](https://github.com/cristianbica).

### 2.2.0 (2016/4/16)

* [#23](https://github.com/dblock/guard-rack/pull/23): Added Windows support - [@jonyeezs](https://github.com/jonyeezs).

### 2.1.1 (2015/03/07)

* Fixed an issue with the command syntax that was preventing the spawner from running - [@michaelherold](https://github.com/michaelherold).

### 2.1.0 (2015/03/06)

* [#17](https://github.com/dblock/guard-rack/pull/17): Added ability to specify host - [@jwhitcraft](https://github.com/jwhitcraft).
* [#18](https://github.com/dblock/guard-rack/pull/18): Removed explicit dependencies on notification libraries, relying instead on Guard's default behavior - [@michaelherold](https://github.com/michaelherold).
* [#19](https://github.com/dblock/guard-rack/pull/19): Added the ability to specify the command for mounting the Rack application - [@michaelherold](https://github.com/michaelherold).

### 2.0.0 (2014/11/15)

* Upgraded to Guard 2.x - [@jdurand](https://github.com/jdurand).
* Upgraded RuboCop to 0.27.1 - [@dblock](https://github.com/dblock).
* Upgraded RSpec to 3.x - [@dblock](https://github.com/dblock).

### 1.4.0 (2014/1/28)

* Ruby 1.8.7 and 1.9.2 are no longer supported - [@dblock](https://github.com/dblock).
* Implemented RuboCop, Ruby linter - [@dblock](https://github.com/dblock).
* [#13](https://github.com/dblock/guard-rack/pull/13): Fix: do not lock a specific version of Rack - [@Nerian](https://github.com/Nerian).

### 1.3.1 (2013/1/16)

* [#12](https://github.com/dblock/guard-rack/issues/12): Fix: could not load 'guard/rack', added missing `ffi` into Gemfile - [@dblock](https://github.com/dblock).

### 1.3 (2013/1/15)

* [#11](https://github.com/dblock/guard-rack/pull/11): Use [spoon](https://github.com/headius/spoon) instead of `system()`, removes the need for `.pid` files - [@viking](https://github.com/viking), [@dblock](https://github.com/dblock).

### 1.2.2 (2012/12/19)

* [#10](https://github.com/dblock/guard-rack/pull/10): Added ability to specify rackup config - [@kgfullerton](https://github.com/kgfullerton).

### 1.2.1 (2012/6/31)

* [#9](https://github.com/dblock/guard-rack/pull/3): Added ability to specify server - [@rubycut](https://github.com/rubycut).

### 1.1 (2012/06/06)

* Now requires Guard 1.1.
* [#3](https://github.com/dblock/guard-rack/pull/3): Changed kill signal from `KILL` to `INT` - [@tombh](https://github.com/tombh).
* [#4](https://github.com/dblock/guard-rack/pull/4): Changed deprecated `run_on_change` to `run_on_changes` - [@tombh](https://github.com/tombh).

### 1.0 (2012/02/27)

* Initial public release - [@dblock](https://github.com/dblock).
