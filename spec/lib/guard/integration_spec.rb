require 'spec_helper'
require 'guard/rack'

describe 'Integration' do
  let(:runner) { Guard::Rack::Runner.new(options) }
  let(:options) { { cmd: 'rackup', environment: 'development', port: 3000, config: 'spec/lib/guard/integration.ru' } }

  describe '#start' do
    before do
      Guard::UI.stubs(:debug)
      Guard::UI.stubs(:info)
    end

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
