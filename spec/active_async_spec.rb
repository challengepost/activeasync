require 'spec_helper'

describe ActiveAsync do
  describe "queue_adapter" do
    it "defaults to inline" do
      expect(ActiveAsync.queue_adapter).to be_a(ActiveAsync::QueueAdapters::InlineAdapter)
    end

    it "can be set to resque" do
      ActiveAsync.queue_adapter = :resque
      expect(ActiveAsync.queue_adapter).to be_a(ActiveAsync::QueueAdapters::ResqueAdapter)
    end

    it "can be set to sidekiq" do
      ActiveAsync.queue_adapter = :sidekiq
      expect(ActiveAsync.queue_adapter).to be_a(ActiveAsync::QueueAdapters::SidekiqAdapter)
    end
  end

  describe "enqueue" do
    it "should call enqueue on queue adapter" do
      expect(ActiveAsync.queue_adapter).to receive(:enqueue).with(:args)
      ActiveAsync.enqueue(:args)
    end
  end
end
