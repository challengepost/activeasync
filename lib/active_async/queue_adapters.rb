module ActiveAsync
  module QueueAdapters
    autoload :InlineAdapter, 'active_async/queue_adapters/inline_adapter'
    autoload :ResqueAdapter, 'active_async/queue_adapters/resque_adapter'
    autoload :SidekiqAdapter, 'active_async/queue_adapters/sidekiq_adapter'

    class << self
      def lookup(name)
        const_get(name.to_s.camelize << 'Adapter')
      end
    end
  end
end
