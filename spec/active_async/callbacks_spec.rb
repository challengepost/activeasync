require 'spec_helper'

describe ActiveAsync::Callbacks do

  describe "active model example", :stub_resque do
    class DummyBase
      extend ActiveModel::Callbacks
      include ActiveAsync::Async
      include ActiveAsync::Callbacks

      define_model_callbacks :save, :update, :create
      define_async_callbacks :after_save, :after_update, :after_create

      def id; object_id; end
      def find(id); end

      def save;   run_callbacks :save; end
      def update; run_callbacks :update; end
      def create; run_callbacks :create; end
    end

    class DummyUser < DummyBase
      after_save    :save_expensive_method,   :async => true
      after_update  :update_expensive_method, :async => true
      after_create  :create_expensive_method, :async => true, :more_options => true

      def save_expensive_method;    self.class.run_expensive_method; end
      def create_expensive_method;  self.class.run_expensive_method; end
      def update_expensive_method;  self.class.run_expensive_method; end

      def self.run_expensive_method
        # please run with async!
      end
    end

    let(:model) { DummyUser.new }

    before(:each) do
      DummyUser.stub!(:find).and_return(model)
    end

    describe "callbacks with async" do

      describe "on create" do
        it "should run create method" do
          model.should_receive(:create_expensive_method).once
          model.create
        end

        it "should run methods asynchronously on create" do
          model.should_receive(:async).with(:create_expensive_method)
          model.create
        end

      end

      describe "on save" do
        it "should run save method" do
          model.should_receive(:save_expensive_method).once
          model.save
        end

        it "should run methods asynchronously on create" do
          model.should_receive(:async).with(:save_expensive_method)
          model.save
        end
      end

      describe "on update" do
        it "should run update method" do
          model.should_receive(:update_expensive_method).once
          model.update
        end

        it "should run methods asynchronously on update" do
          model.should_receive(:async).with(:update_expensive_method)
          model.update
        end
      end

      it "should run expensive method for each callback" do
        DummyUser.should_receive(:run_expensive_method).exactly(1).times
        model.create

        DummyUser.should_receive(:run_expensive_method).exactly(1).times
        model.save

        DummyUser.should_receive(:run_expensive_method).exactly(1).times
        model.update
      end

      describe ".extract_async_methods" do
        it "should forward unmodified arguments if not asyncing" do
          extracted_args = DummyUser.send(:extract_async_methods, [:method_name, {:more_options => true}])
          extracted_args.should == [:method_name, {:more_options => true}]
        end

        it "should pass along all options to after_create macro execpt :async" do
          extracted_args = DummyUser.send(:extract_async_methods, [:method_name, {:more_options => true, :async => true}])
          extracted_args.should include(:more_options => true)
          extracted_args.should_not include(:async => true)
        end

        it "should update method name and define async method when async is true" do
          extracted_args = DummyUser.send(:extract_async_methods, [:method_name, {:async => true}])
          extracted_args.should == ["async_method_name", {}]
          DummyUser.instance_methods.map(&:to_sym).should include(:async_method_name)
        end
      end


    end
  end

end
