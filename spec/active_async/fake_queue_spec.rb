require 'spec_helper'

describe ActiveAsync::FakeQueue do

  it "should call perform with given klass and given arguments" do
    Post.should_receive(:perform).with(1, :expensive_method)
    ActiveAsync::FakeQueue.enqueue(Post, 1, :expensive_method)
  end
end
