require 'spec_helper'

describe "ActiveAsync::RSpec" do

  describe ":stub_resque block" do

    it "should set async mode to ::Resque in example", :stub_resque do
      ActiveAsync.mode.should == :fake_queue
    end

    it "should stub_resque in example", :stub_resque do
      ActiveAsync.background.should == ActiveAsync::FakeQueue
    end

    it "should set async mode to ActiveAsync::FakeQueue in example", :enable_resque do
      ActiveAsync.mode.should == :resque
    end

    it "should set async mode to ActiveAsync::FakeQueue in example", :enable_resque do
      ActiveAsync.background.should == ::Resque
    end
  end
end
