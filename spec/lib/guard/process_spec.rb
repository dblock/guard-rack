require 'spec_helper'
require 'guard/rack/custom_process'

describe Guard::Rack::CustomProcess do
  let(:options) { { environment: 'development', port: 'one', config: 'config.ru', host: '0.0.0.0', timeout: 1 } }
  let(:process) { Guard::Rack::CustomProcess }

  describe 'create instance' do
    context '*nix' do
      before do
        Gem.stubs(:win_platform?).returns(false)
      end

      it 'should instantiate correctly' do
        instance = process.new(options)
        expect(instance).to be_a Guard::Rack::CustomProcess::Nix
      end
    end

    context 'windows' do
      before do
        Gem.stubs(:win_platform?).returns(true)
      end

      it 'should instantiate correctly' do
        instance = process.new(options)
        expect(instance).to be_a Guard::Rack::CustomProcess::Windows
      end
    end
  end

  describe '*nix' do
    before do
      Gem.stubs(:win_platform?).returns(false)
    end

    context 'pid exists' do
      let(:pid) { 12_345 }
      let(:status_stub) { stub('process exit status') }
      let(:subject) { process.new(options) }
      let(:wait_stub) { Process.stubs(:wait2) }

      before do
        Process.expects(:kill).with('INT', pid)
      end

      context 'rackup returns successful exit status' do
        before do
          wait_stub.returns([pid, status_stub])
          status_stub.stubs(:exitstatus).returns(0)
        end

        it 'should return true' do
          expect(subject.kill(pid)).to eq(0)
        end
      end

      context 'rackup returns unsuccessful exit status' do
        before do
          Guard::UI.stubs(:info)
          wait_stub.returns([pid, status_stub])
          status_stub.stubs(:exitstatus).returns(1)
        end

        it 'should return false' do
          expect(subject.kill(pid)).to eq(1)
        end
      end

      context 'kill times out' do
        before do
          wait_stub.raises(Timeout::Error)
          Process.expects(:kill).with('TERM', pid)
        end

        it 'should return false' do
          expect(subject.kill(pid)).to eq(-1)
        end
      end
    end
  end

  describe 'windows' do
    before do
      Gem.stubs(:win_platform?).returns(true)
    end

    context 'pid exist' do
      let(:pid) { 123_45 }
      let(:subject) { process.new }
      before do
        subject.expects(:system).with("taskkill /pid #{pid} /T /f")
      end

      describe 'kill' do
        context 'successful exit status' do
          before do
            $CHILD_STATUS.stubs(:exitstatus).returns 0
          end

          it 'should result in 0' do
            expect(subject.kill(pid)).to eq(0)
          end
        end
      end
    end
  end
end
