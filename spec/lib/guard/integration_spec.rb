require 'spec_helper'
require 'guard/rack/runner'

describe "Integration" do
  let(:runner) { Guard::RackRunner.new(options) }
  let(:options) { { :environment => 'development', :port => 3000, :config => 'spec/lib/guard/integration.ru' } }

  describe '#start' do
    context 'run' do
      it "should run" do
        runner.start.should be_true
        pid = runner.pid
        pid.should_not be_nil
        Process.getpgid(pid).should > 0
        runner.stop
        expect {
          Process.getpgid(pid)
        }.to raise_error Errno::ESRCH
      end
    end
  end
end
