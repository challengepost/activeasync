module ActiveAsync
  module Async
    extend ActiveSupport::Concern

    CLASS_IDENTIFIER = "__class__".freeze

    included do
      class_attribute :queue
      self.queue = :general
    end

    class << self
      # This will be called by a worker when a job needs to be processed
      def perform(class_name, id, method, *args)
        deserialize(class_name, id).send(method, *args)
      end

      private

      def deserialize(class_name, id)
        active_record_class = class_name.safe_constantize
        case id
        when CLASS_IDENTIFIER
          active_record_class
        else
          active_record_class.find(id)
        end
      end
    end

    module ClassMethods
      def async(method, *args)
        ActiveAsync.queue_adapter.enqueue(self.to_s, CLASS_IDENTIFIER, method, *args)
      end

      def perform(*args)
        ActiveAsync::Async.perform(self.to_s, CLASS_IDENTIFIER, *args)
      end
    end

    # We can pass any instance method that we want to run later.
    # Arguments should be serializable for Resque.
    #
    # Setting ActiveAsync.skip = true will bypass async altogether.
    #
    def async(method, *args)
      ActiveAsync.queue_adapter.enqueue(self.class.to_s, id, method, *args)
    end
  end
end
