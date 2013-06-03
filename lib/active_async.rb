require "active_support/concern"
require "active_async/version"
require "active_async/async"
require "active_async/callbacks"

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

  private

  def set_background_for_mode(mode)
    case mode
    when :sidekiq
      require "sidekiq"
      @background = ::Sidekiq::Client
    when :resque
      require "resque"
      @background = ::Resque
    when :fake_resque
      require 'active_async/fake_resque'
      @background = FakeResque
    else
      raise ModeNotSupportedError
    end
  end

end
