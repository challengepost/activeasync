require 'spec_helper'

describe ActiveAsync::Async do

  context "activerecord, resque", :stub_resque do
    let(:post) { Post.create(:title => "A new post") }

    describe "queue" do
      it "should provide default queue" do
        Post.queue.should == :general
      end

      it "allows override per class" do
        Blog.queue = :blog
        Blog.queue.should == :blog
        Post.queue.should == :general
      end
    end

    describe "perform" do
      it "should send method for given instance id" do
        Post.any_instance.should_receive(:expensive_method)
        Post.perform(post.id, :expensive_method)
      end
    end

    describe "async" do
      it "should send method for given instance id" do
        Post.should_receive(:expensive_method)
        Post.async(:expensive_method)
      end
    end

    describe "#async" do
      it "should call the given method" do
        Post.any_instance.should_receive(:expensive_method)
        post.async(:expensive_method)
      end

      it "should call the given method" do
        Post.any_instance.should_receive(:expensive_method).with(1, 2, 3)
        post.async(:expensive_method, 1, 2, 3)
      end

      it "should call 'perform' class method as expected by Resque" do
        Post.should_receive(:perform).with(post.id, :expensive_method)
        post.async(:expensive_method)
      end

      it "should find the existing record" do
        Post.should_receive(:find).with(post.id).and_return(post)
        post.async(:expensive_method)
      end

      it "should raise error if record not found" do
        post = Post.new
        lambda { post.async(:expensive_method) }.should raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end

end
