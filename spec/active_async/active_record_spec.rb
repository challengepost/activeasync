require 'spec_helper'

describe ActiveAsync::ActiveRecord do

  let(:blog) { Blog.new }

  before(:each) do
    allow(Blog).to receive(:find).and_return(blog)
  end

  describe "included", :stub_resque do
    it "should define async callback for save" do
      expect(blog).to receive(:expensive_save_method)
      blog.save
    end

    it "should define async callback for update" do
      blog.save
      expect(blog).to receive(:expensive_update_method)
      blog.update_attributes(:title => "foo")
    end

    it "should define async callback for create" do
      expect(blog).to receive(:expensive_create_method)
      Blog.create
    end
  end

  context "synchronous callbacks" do
    it "doesn't prevent synchronous callbacks to be called" do
      expect(blog).to receive(:cheap_save_from_block)
      expect(blog).to receive(:cheap_save_from_lambda)
      expect(blog).to receive(:cheap_save_from_method_name)

      blog.save
    end
  end

end
