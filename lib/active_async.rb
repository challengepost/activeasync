require "resque"
require "active_support/concern"
require "active_async/version"
require "active_async/async"

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

#
# module Resque
#   module AsyncJob
#     @@_queue= :default
#     def self.included(base)
#       base.extend(ClassMethods)
#     end
#
#     module ClassMethods
#       # Set the default queue. chain method
#       def queue(new_queue = nil)
#         if new_queue
#           @@_queue = new_queue
#           return self
#         else
#           @@_queue
#         end
#       end
#
#       def perform(method, id=nil, *args)
#         if id && id != 0
#           find(id).send(method, *args)
#         else
#           if !id or id == 0
#             self.send(method, *args)
#           else
#             self.send(method, id, *args)
#           end
#         end
#       end
#
#       def async(method, *args)
#         Job.create(@@queue, self, method, 0, *args)
#         Plugin.after_enqueue_hooks(self).each do |hook|
#           klass.send(hook, *args)
#         end
#       end
#     end
#     def queue(new_queue = nil)
#       if new_queue
#         @@_queue = new_queue
#         return self
#       else
#         @@_queue
#       end
#     end
#
#     def async(method, *args)
#       Job.create(@@_queue, self.class, method, self.id, *args)
#       Plugin.after_enqueue_hooks(self.class).each do |hook|
#         klass.send(hook, *args)
#       end
#     end
#   end
# end
#
# if defined? ActiveRecord
#   class ActiveRecord::Base
#     include Resque::AsyncJob
#   end
# end