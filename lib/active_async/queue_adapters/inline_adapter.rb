module ActiveAsync
  module QueueAdapters
    class InlineAdapter
      # When enqueuing jobs, the inline adapter will be
      # executed immediately
      def enqueue(*args)
        ActiveAsync::Async.perform(*args)
      end
    end
  end
end
