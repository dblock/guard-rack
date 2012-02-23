require 'spec_helper'
require 'guard/rack/guard'

describe Guard::Rack::Guard do
  let(:guard) { Guard::Rack::Guard.new(watchers, options) }
  let(:watchers) { [] }
  let(:options) { {} }

  describe '#initialize' do
    it "should initialize with options" do
      guard

      guard.runner.options[:port].should == 3000
    end
  end

  describe '#start' do
    let(:ui_expectation) { Guard::UI.expects(:info).with(regexp_matches(/#{Guard::Rack::Guard::DEFAULT_OPTIONS[:port]}/)) }

    context 'start on start' do
      it "should show the right message and run startup" do
        guard.expects(:reload).once
        ui_expectation
        guard.start
      end
    end

    context 'no start on start' do
      let(:options) { { :start_on_start => false } }

      it "should show the right message and not run startup" do
        guard.expects(:reload).never
        ui_expectation
        guard.start
      end
    end
  end

  describe '#reload' do
    let(:pid) { '12345' }

    before do
      Guard::UI.expects(:info).with('Restarting Rack...')
      Guard::Notifier.expects(:notify).with(regexp_matches(/Rack restarting/), has_entry(:image => :pending))
      Guard::Rack::Runner.any_instance.stubs(:pid).returns(pid)
    end

    let(:runner_stub) { Guard::Rack::Runner.any_instance.stubs(:restart) }

    context 'with pid file' do
      before do
        runner_stub.returns(true)
      end

      it "should restart and show the pid file" do
        Guard::UI.expects(:info).with(regexp_matches(/#{pid}/))
        Guard::Notifier.expects(:notify).with(regexp_matches(/Rack restarted/), has_entry(:image => :success))

        guard.reload
      end
    end

    context 'no pid file' do
      before do
        runner_stub.returns(false)
      end

      it "should restart and show the pid file" do
        Guard::UI.expects(:info).with(regexp_matches(/#{pid}/)).never
        Guard::UI.expects(:info).with(regexp_matches(/Rack NOT restarted/))
        Guard::Notifier.expects(:notify).with(regexp_matches(/Rack NOT restarted/), has_entry(:image => :failed))

        guard.reload
      end
    end
  end

  describe '#stop' do
    it "should stop correctly" do
      Guard::Notifier.expects(:notify).with('Until next time...', anything)
      guard.stop
    end
  end

  describe '#run_on_change' do
    it "should reload on change" do
      guard.expects(:reload).once
      guard.run_on_change([])
    end
  end
end

