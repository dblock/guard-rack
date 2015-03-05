require 'spec_helper'
require 'guard/rack/runner'

describe 'Integration' do
  let(:runner) { Guard::RackRunner.new(options) }
  let(:options) { { cmd: 'rackup', environment: 'development', port: 3000, config: 'spec/lib/guard/integration.ru' } }

  describe '#start' do
    context 'run' do
      it 'should run' do
        expect(runner.start).to be_truthy
        pid = runner.pid
        expect(pid).not_to be_nil
        expect(Process.getpgid(pid)).to be > 0
        runner.stop
        expect do
          Process.getpgid(pid)
        end.to raise_error Errno::ESRCH
      end
    end
  end
end
