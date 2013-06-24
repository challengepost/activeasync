module ActiveAsync
  module Async
    extend ActiveSupport::Concern

    CLASS_IDENTIFIER = "__class__".freeze

    included do
      class_attribute :queue
      self.queue = :general
    end

    module ClassMethods

      # This will be called by a worker when a job needs to be processed
      def perform(id, method, *args)
        async_class_or_instance(id).send(method, *args)
      end

      def async(method, *args)
        ActiveAsync.background.enqueue(self, CLASS_IDENTIFIER, method, *args)
      end

      private

      def async_class_or_instance(id)
        id == CLASS_IDENTIFIER ? self : self.find(id)
      end

    end

    # We can pass any instance method that we want to run later.
    # Arguments should be serializable for Resque.
    #
    # Setting ActiveAsync.skip = true will bypass async altogether.
    #
    def async(method, *args)
      if ActiveAsync.skip?
        self.send(method, *args)
      else
        ActiveAsync.background.enqueue(self.class, id, method, *args)
      end
    end

  end
end
