require 'spec_helper'

describe ActiveAsync::Async do

  context "activerecord, resque", :stub_resque do
    let(:post) { Post.create(:title => "A new post") }

    describe "queue" do
      it "should provide default queue" do
        expect(Post.queue).to eq(:general)
      end

      it "allows override per class" do
        Blog.queue = :blog
        expect(Blog.queue).to eq(:blog)
        expect(Post.queue).to eq(:general)
      end
    end

    describe "perform" do
      it "should send method for given instance id" do
        expect_any_instance_of(Post).to receive(:expensive_method)
        Post.perform(post.id, :expensive_method)
      end
    end

    describe "async" do
      it "should send method for given instance id" do
        expect(Post).to receive(:expensive_method)
        Post.async(:expensive_method)
      end
    end

    describe "#async" do
      it "should call the given method" do
        expect_any_instance_of(Post).to receive(:expensive_method)
        post.async(:expensive_method)
      end

      it "should call the given method" do
        expect_any_instance_of(Post).to receive(:expensive_method).with(1, 2, 3)
        post.async(:expensive_method, 1, 2, 3)
      end

      it "should call 'perform' class method as expected by Resque" do
        expect(Post).to receive(:perform).with(post.id, :expensive_method)
        post.async(:expensive_method)
      end

      it "should find the existing record" do
        expect(Post).to receive(:find).with(post.id).and_return(post)
        post.async(:expensive_method)
      end

      it "should raise error if record not found" do
        post = Post.new
        expect { post.async(:expensive_method) }.to raise_error(ActiveRecord::RecordNotFound)
      end

      it "should call given method directly when skipping async" do
        ActiveAsync.skip = true
        expect(post).to receive(:expensive_method)
        post.async(:expensive_method)
      end
    end
  end

end
