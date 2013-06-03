require "active_support/concern"
require "active_async/version"
require "active_async/async"
require "active_async/callbacks"

module ActiveAsync
  extend self

  class ModeNotSupportedError < StandardError; end

  DEFAULT_MODE = :resque

  def enqueue(*args)
    background.enqueue(*args)
  end

  def background
    @background ||= background_for_mode(DEFAULT_MODE)
  end

  def background=(background)
    @background = background
  end

  def reset!
    @background = nil
    @mode = nil
  end

  def mode=(mode)
    self.background = background_for_mode(mode)
    @mode = mode
  end

  def mode
    @mode ||= DEFAULT_MODE
  end

  def background_for_mode(mode)
    case mode
    when :sidekiq
      require "sidekiq"
      ::Sidekiq::Client
    when :resque
      require "resque"
      ::Resque
    when :fake_queue, :fake_resque, :fake_sidekiq
      require 'active_async/fake_queue'
      FakeQueue
    else
      raise ModeNotSupportedError
    end
  end

end
