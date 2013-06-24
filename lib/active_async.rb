require "resque"
require "active_support/concern"
require "active_async/version"
require "active_async/async"
require "active_async/callbacks"
require 'active_async/railtie' if defined?(Rails)

module ActiveAsync
  extend self

  class ModeNotSupportedError < StandardError; end

  def background
    @background ||= ::Resque
  end

  def background=(background)
    @background = background
  end

  def enqueue(*args)
    background.enqueue(*args)
  end

  def reset!
    @background = nil
    @mode = nil
  end

  def mode=(mode)
    set_background_for_mode(mode)
    @mode = mode
  end

  def mode
    @mode || (mode = :resque)
  end

  def skip=(true_or_false)
    @skip = true_or_false
  end

  def skip
    !!@skip
  end
  alias :skip? :skip

  private

  def set_background_for_mode(mode)
    @background = case mode
    when :resque
      ::Resque
    when :fake_resque
      require 'active_async/fake_resque'
      FakeResque
    else
      raise ModeNotSupportedError
    end
  end

end
