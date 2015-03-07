require 'spec_helper'

describe Guard::Rack::Command do
  let(:default_options) do
    { cmd: 'rackup', environment: 'development', host: '0.0.0.0',
      port: 3000, config: 'config.ru' }
  end
  let(:options) { default_options }
  let(:command) { Guard::Rack::Command.new(options) }

  describe '#build' do
    subject { command.build }

    it { is_expected.to start_with('rackup') }
    it { is_expected.to include('config.ru') }
    it { is_expected.to include('--env').and include('development') }
    it { is_expected.to include('--host').and include('0.0.0.0') }
    it { is_expected.to include('--port').and include('3000') }
    it { is_expected.not_to include('--daemonize') }
    it { is_expected.not_to include('--debug') }
    it { is_expected.not_to include('--server') }

    context 'with a custom command configuration' do
      let(:options) { default_options.merge(cmd: 'bundle exec rackup') }

      it { is_expected.to start_with('bundle exec rackup') }
    end

    context 'with a daemon configuration' do
      let(:options) { default_options.merge(daemon: true) }

      it { is_expected.to include('--daemonize') }
    end

    context 'with a debugger configuration' do
      let(:options) { default_options.merge(debugger: true) }

      it { is_expected.to include('--debug') }
    end

    context 'with an environment configuration' do
      let(:options) { default_options.merge(environment: 'custom') }

      it { is_expected.to include('--env').and include('custom') }
    end

    context 'with a server configuration' do
      let(:options) { default_options.merge(server: 'thin') }

      it { is_expected.to include('--server').and include('thin') }
    end

    context 'with a custom config file configuration' do
      let(:options) { default_options.merge(config: 'config2.ru') }

      it { is_expected.to include('config2.ru') }
    end
  end
end
