require 'spec_helper'

describe ActiveAsync do

  describe "background" do
    before(:each) do
      ActiveAsync.reset!
    end

    it "defaults to Resque" do
      ActiveAsync.background.should == ::Resque
    end

    it "can be overridden" do
      ActiveAsync.background = ActiveAsync::FakeResque
      ActiveAsync.background.should == ActiveAsync::FakeResque
    end
  end

  describe "enqueue", :stub_resque do

    it "should call enqueue on background strategy" do
      ActiveAsync::FakeResque.should_receive(:enqueue).with(:args)
      ActiveAsync.enqueue(:args)
    end
  end

  describe "mode=" do
    before(:each) do
      ActiveAsync.reset!
    end

    it "setting to :fake_resque enables FakeResque" do
      ActiveAsync.mode = :fake_resque
      ActiveAsync.background.should == ActiveAsync::FakeResque
    end

    it "setting to :resque enables Resque" do
      ActiveAsync.mode = :resque
      ActiveAsync.background.should == ::Resque
    end

    it "should raise ModeNotSupportedError otherwise" do
      lambda { ActiveAsync.mode = :mode_doesnt_exist }.should raise_error(ActiveAsync::ModeNotSupportedError)
    end

    it "should return mode" do
      ActiveAsync.mode = :fake_resque
      ActiveAsync.mode.should == :fake_resque
    end
  end

  describe "skip" do
    it "should be false" do
      ActiveAsync.skip?.should be_false
    end

    it "can be set to true" do
      ActiveAsync.skip = true
      ActiveAsync.skip?.should be_true
    end
  end
end
