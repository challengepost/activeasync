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
end
