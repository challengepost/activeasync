require 'resque'

module ActiveAsync
  module QueueAdapters
    class ResqueAdapter
      def enqueue(*args)
        ::Resque.enqueue(JobWrapper, *args)
      end

      class JobWrapper
        class_attribute :queue
        self.queue = :general

        class << self
          def perform(*args)
            ActiveAsync::Async.perform(*args)
          end
        end
      end
    end
  end
end
