require 'spec_helper'
require 'guard/rack/runner'

describe Guard::RackRunner do
  let(:runner) { Guard::RackRunner.new(options) }
  let(:environment) { 'development' }
  let(:port) { 3000 }

  let(:default_options) { { environment: environment, port: port, config: 'config.ru', host: '0.0.0.0' } }
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

  describe '#start' do
    let(:unmanaged_pid) { 4567 }
    let(:pid) { 1234 }
    let(:kill_expectation) { runner.expects(:kill) }

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
      let(:pid) { 123_45 }
      let(:process) { Guard::Rack::CustomProcess.stubs(:new) }

      before do
        runner.stubs(:spawn).returns(pid)
        runner.start
      end

      context 'rackup returns successful exit status' do
        before do
          process.returns(stub(kill: 0))
        end

        it 'should return true' do
          expect(runner.stop).to be_truthy
        end
      end

      context 'rackup returns unsuccessful exit status' do
        before do
          Guard::UI.stubs(:info)
          process.returns(stub(kill: 1))
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
