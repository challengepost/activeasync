require "resque"
require "active_support/concern"
require "active_async/version"
require "active_async/async"
require "active_async/callbacks"
require "active_async/active_record"

module ActiveAsync
  extend self

  def background
    @background ||= ::Resque
  end

  def background=(background)
    @background = background
  end

  def reset!
    @background = nil
  end

end