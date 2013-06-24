require 'spec_helper'

describe "ActiveAsync::RSpec" do

  describe ":stub_resque block" do

    it "should set async mode to ::Resque in example", :stub_resque do
      ActiveAsync.mode.should == :fake_resque
    end

    it "should stub_resque in example", :stub_resque do
      ActiveAsync.background.should == ActiveAsync::FakeResque
    end

    it "should set async mode to ActiveAsync::FakeResque in example", :enable_resque do
      ActiveAsync.mode.should == :resque
    end

    it "should set async mode to ActiveAsync::FakeResque in example", :enable_resque do
      ActiveAsync.background.should == ::Resque
    end
  end

  describe ":skip_async block" do
    it "should skip async in block", :skip_async do
      ActiveAsync.skip?.should be_true
    end
  end
end
