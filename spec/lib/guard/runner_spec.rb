require 'spec_helper'
require 'guard/rack/runner'

describe Guard::RackRunner do
  let(:runner) { Guard::RackRunner.new(options) }
  let(:environment) { 'development' }
  let(:port) { 3000 }

  let(:default_options) { { environment: environment, port: port, config: 'config.ru' } }
  let(:options) { default_options }

  before do
    Guard::UI.stubs(:debug)
  end

  describe '#pid' do
    context 'after running' do
      let(:pid) { 1234 }

      before do
        runner.stubs(:spawn).returns(pid)
        runner.start
      end

      it 'should not be nil' do
        expect(runner.pid).to eq(pid)
      end
    end

    context 'before running' do
      it 'should return nil' do
        expect(runner.pid).to be_nil
      end
    end
  end

  describe '#build_rack_command' do
    context 'no daemon' do
      it 'should not have a daemon switch' do
        expect(runner.send(:build_rack_command)).not_to include('--daemonize')
      end
    end

    context 'daemon' do
      let(:options) { default_options.merge(daemon: true) }

      it 'should have a daemon switch' do
        expect(runner.send(:build_rack_command)).to include('--daemonize')
      end
    end

    context 'debugger' do
      let(:options) { default_options.merge(debugger: true) }

      it 'should have a debugger switch' do
        expect(runner.send(:build_rack_command)).to include('--debug')
      end
    end

    context 'server' do
      let(:options) { default_options.merge(server: 'thin') }

      it 'should honour server switch' do
        command = runner.send(:build_rack_command)
        index = command.index('--server')
        expect(index).to be >= 0
        expect(command[index + 1]).to eq('thin')
      end
    end

    context 'config file' do
      context 'default' do
        it 'should default to config.ru' do
          expect(runner.send(:build_rack_command)).to include('config.ru')
        end
      end

      context 'custom' do
        let(:options) { default_options.merge(config: 'config2.ru') }
        it 'should honour config option' do
          default_options.merge(config: 'config2.ru')
          expect(runner.send(:build_rack_command)).to include('config2.ru')
        end
      end
    end
  end

  describe '#start' do
    let(:unmanaged_pid) { 4567 }
    let(:pid) { 1234 }
    let(:kill_expectation) { Process.expects(:kill).with('TERM', unmanaged_pid) }

    before do
      runner.expects(:spawn).once.returns(pid)
      runner.stubs(:unmanaged_pid).returns(unmanaged_pid)
    end

    context 'do not force run' do
      before do
        kill_expectation.never
      end

      it 'should act properly' do
        expect(runner.start).to be_truthy
      end
    end

    context 'force run' do
      let(:options) { default_options.merge(force_run: true) }

      before do
        kill_expectation.once
        Process.expects(:wait2).never # don't wait on non-child processes
      end

      it 'should act properly' do
        expect(runner.start).to be_truthy
      end
    end
  end

  describe '#stop' do

    context 'pid exists' do
      let(:pid) { 12_345 }
      let(:status_stub) { stub('process exit status') }
      let(:wait_stub) { Process.stubs(:wait2) }

      before do
        runner.stubs(:spawn).returns(pid)
        runner.start

        Process.expects(:kill).with('INT', pid)
      end

      context 'rackup returns successful exit status' do
        before do
          wait_stub.returns([pid, status_stub])
          status_stub.stubs(:exitstatus).returns(0)
        end

        it 'should return true' do
          expect(runner.stop).to be_truthy
        end
      end

      context 'rackup returns unsuccessful exit status' do
        before do
          Guard::UI.stubs(:info)
          wait_stub.returns([pid, status_stub])
          status_stub.stubs(:exitstatus).returns(1)
        end

        it 'should return false' do
          expect(runner.stop).to be_falsey
        end

        it 'should send some kind of message to UI.info' do
          Guard::UI.expects(:info).with(regexp_matches(/.+/))
          runner.stop
        end
      end

      context 'kill times out' do
        before do
          Guard::UI.stubs(:info)
          wait_stub.raises(Timeout::Error)
          Process.expects(:kill).with('TERM', pid)
        end

        it 'should return false' do
          expect(runner.stop).to be_falsey
        end

        it 'should send some kind of message to UI.info' do
          Guard::UI.expects(:info).with(regexp_matches(/.+/))
          runner.stop
        end
      end
    end

    context 'pid does not exist' do
      it 'should return true' do
        expect(runner.stop).to be_truthy
      end
    end
  end
end
