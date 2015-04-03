require 'spec_helper'

describe ActiveAsync::Async do
  context "activerecord", :inline do
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

    describe "async" do
      it "should send method for given instance id" do
        expect(Post).to receive(:expensive_method)
        Post.async(:expensive_method)
      end
    end

    describe "#async" do
      it "should call perform on ActiveAsync" do
        expect(ActiveAsync::Async).to receive(:perform).with("Post", post.id, :expensive_method)
        post.async(:expensive_method)
      end

      it "should call the given method" do
        expect_any_instance_of(Post).to receive(:expensive_method)
        post.async(:expensive_method)
      end

      it "should call the given method" do
        expect_any_instance_of(Post).to receive(:expensive_method).with(1, 2, 3)
        post.async(:expensive_method, 1, 2, 3)
      end

      it "should find the existing record" do
        expect(Post).to receive(:find).with(post.id).and_return(post)
        post.async(:expensive_method)
      end

      it "should raise error if record not found" do
        post = Post.new
        expect { post.async(:expensive_method) }.to raise_error(ActiveRecord::RecordNotFound)
      end

      describe "resque", :resque do
        it "should call method on instance" do
          post.async(:change_title, "A new title")
          post.reload
          expect(post.title).to eq("A new title")
        end

        it "should call 'perform' class method as expected by Resque" do
          expect(Resque).to receive(:enqueue).with \
            ActiveAsync::QueueAdapters::ResqueAdapter::JobWrapper,
            "Post",
            post.id,
            :expensive_method
          post.async(:expensive_method)
        end
      end

      describe "sidekiq", :sidekiq do
        it "should call method on instance" do
          post.async(:change_title, "A new title")
          post.reload
          expect(post.title).to eq("A new title")
        end

        it "should call 'perform' class method as expected by Sidekiq::Client" do
          expect(Sidekiq::Client).to receive(:enqueue).with \
            ActiveAsync::QueueAdapters::SidekiqAdapter::JobWrapper,
            "Post",
            post.id,
            :expensive_method
          post.async(:expensive_method)
        end
      end
    end
  end
end
