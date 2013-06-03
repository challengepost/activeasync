require 'spec_helper'

describe ActiveAsync::ActiveRecord do

  context "callback with :async => true" do
    let(:subject) { Blog.create }

    before(:each) do
      subject
    end

    it "should define async callback for save" do
      Blog.should_receive(:expensive_save_method)
      subject.save
    end

    it "should define async callback for update" do
      Blog.should_receive(:expensive_update_method)
      subject.update_attributes(:title => "foo")
    end

    it "should define async callback for create" do
      Blog.should_receive(:expensive_create_method)
      Blog.create
    end
  end

end
