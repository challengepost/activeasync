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

    class DummyBlog < DummyBase
      include Sidekiq::Worker

      after_save :expensive_resque_method,  :async => :resque
      after_save :expensive_sidekiq_method, :async => :sidekiq

      def self.expensive_resque_method; end
      def self.expensive_sidekiq_method; end

      # Sidekiq api
      def perform(*args)
         self.class.expensive_sidekiq_method
      end

      def expensive_sidekiq_method; perform; end
      def expensive_resque_method; self.class.expensive_resque_method; end
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

    before(:each) do
      DummyBase.stub!(:find).and_return(subject)
    end

    context "callbacks with async" do
      let(:subject) { DummyUser.new }

      describe "on create" do
        it "should run create method" do
          subject.should_receive(:create_expensive_method).once
          subject.create
        end

        it "should run methods asynchronously on create" do
          subject.should_receive(:async_with).with(:resque, :create_expensive_method)
          subject.create
        end

      end

      describe "on save" do
        it "should run save method" do
          subject.should_receive(:save_expensive_method).once
          subject.save
        end

        it "should run methods asynchronously on create" do
          subject.should_receive(:async_with).with(:resque, :save_expensive_method)
          subject.save
        end
      end

      describe "on update" do
        it "should run update method" do
          subject.should_receive(:async_with).with(:resque, :update_expensive_method).once
          subject.update
        end

        it "should run methods asynchronously on update" do
          subject.should_receive(:async_with).with(:resque, :update_expensive_method)
          subject.update
        end
      end

      it "should run expensive method for each callback" do
        DummyUser.should_receive(:run_expensive_method).exactly(1).times
        subject.create

        DummyUser.should_receive(:run_expensive_method).exactly(1).times
        subject.save

        DummyUser.should_receive(:run_expensive_method).exactly(1).times
        subject.update
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

    context "callback with :async => mode" do
      let(:subject) { DummyBlog.new }

      it "should trigger Resque job" do
        Resque.should_receive(:enqueue).with(
          DummyBlog, subject.id, :expensive_resque_method).once
        Resque.should_not_receive(:enqueue).with(
          DummyBlog, subject.id, :expensive_sidekiq_method)
        subject.save
      end

      it "should trigger Sidekiq" do
        Sidekiq::Client.should_receive(:enqueue).with(
          DummyBlog, subject.id, :expensive_sidekiq_method).once
        Sidekiq::Client.should_not_receive(:enqueue).with(
          DummyBlog, subject.id, :expensive_resque_method)
        subject.save
      end
    end

  end
end
