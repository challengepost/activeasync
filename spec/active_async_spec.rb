require 'spec_helper'

describe ActiveAsync do

  describe "background" do
    before(:each) do
      ActiveAsync.reset!
    end

    it "defaults to Resque" do
      expect(ActiveAsync.background).to eq(::Resque)
    end

    it "can be overridden" do
      ActiveAsync.background = ActiveAsync::FakeResque
      expect(ActiveAsync.background).to eq(ActiveAsync::FakeResque)
    end
  end

  describe "enqueue", :stub_resque do

    it "should call enqueue on background strategy" do
      expect(ActiveAsync::FakeResque).to receive(:enqueue).with(:args)
      ActiveAsync.enqueue(:args)
    end
  end

  describe "mode=" do
    before(:each) do
      ActiveAsync.reset!
    end

    it "setting to :fake_resque enables FakeResque" do
      ActiveAsync.mode = :fake_resque
      expect(ActiveAsync.background).to eq(ActiveAsync::FakeResque)
    end

    it "setting to :resque enables Resque" do
      ActiveAsync.mode = :resque
      expect(ActiveAsync.background).to eq(::Resque)
    end

    it "should raise ModeNotSupportedError otherwise" do
      expect { ActiveAsync.mode = :mode_doesnt_exist }.to raise_error(ActiveAsync::ModeNotSupportedError)
    end

    it "should return mode" do
      ActiveAsync.mode = :fake_resque
      expect(ActiveAsync.mode).to eq(:fake_resque)
    end
  end

  describe "skip" do
    it "should be false" do
      expect(ActiveAsync.skip?).to be_falsey
    end

    it "can be set to true" do
      ActiveAsync.skip = true
      expect(ActiveAsync.skip?).to be_truthy
    end
  end
end
