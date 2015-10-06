require 'sidekiq'

module ActiveAsync
  module QueueAdapters
    class SidekiqAdapter
      def enqueue(*args)
        ::Sidekiq::Client.enqueue(JobWrapper, *args)
      end

      class JobWrapper
        include Sidekiq::Worker

        class_attribute :queue
        self.queue = :general

        def perform(*args)
          ActiveAsync::Async.perform(*args)
        end
      end
    end
  end
end
