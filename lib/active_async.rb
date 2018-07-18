require "active_support/concern"
require "active_async/version"
require "active_async/async"
require "active_async/callbacks"
require "active_async/queue_adapters"
require 'active_async/railtie' if defined?(Rails)

module ActiveAsync
  extend self

  class ModeNotSupportedError < StandardError; end

  def enqueue(*args)
    queue_adapter.enqueue(*args)
  end

  def queue_adapter=(name)
    @queue_adapter = interpret_adapter(name)
  end

  def queue_adapter
    @queue_adapter || interpret_adapter(:inline)
  end

  private

  def interpret_adapter(name)
    ActiveAsync::QueueAdapters.lookup(name).new
  end
end
