require 'spec_helper'

describe ActiveAsync::ActiveRecord do

  let(:blog) { Blog.new }

  before(:each) do
    Blog.stub!(:find).and_return(blog)
  end

  describe "included", :stub_resque do
    it "should define async callback for save" do
      blog.should_receive(:expensive_save_method)
      blog.save
    end

    it "should define async callback for update" do
      blog.save
      blog.should_receive(:expensive_update_method)
      blog.update_attributes(:title => "foo")
    end

    it "should define async callback for create" do
      blog.should_receive(:expensive_create_method)
      Blog.create
    end
  end
end
