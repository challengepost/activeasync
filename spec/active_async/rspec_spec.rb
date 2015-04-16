require 'spec_helper'

describe "ActiveAsync::RSpec" do

  describe ":stub_resque block" do

    it "should set async mode to ::Resque in example", :stub_resque do
      expect(ActiveAsync.mode).to eq(:fake_resque)
    end

    it "should stub_resque in example", :stub_resque do
      expect(ActiveAsync.background).to eq(ActiveAsync::FakeResque)
    end

    it "should set async mode to ActiveAsync::FakeResque in example", :enable_resque do
      expect(ActiveAsync.mode).to eq(:resque)
    end

    it "should set async mode to ActiveAsync::FakeResque in example", :enable_resque do
      expect(ActiveAsync.background).to eq(::Resque)
    end
  end

  describe ":skip_async block" do
    it "should skip async in block", :skip_async do
      expect(ActiveAsync.skip?).to be_truthy
    end
  end
end
