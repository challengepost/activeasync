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

    # We can pass this any Repository instance method that we want to
    # run later.
    def async(method, *args)
      async_client.enqueue(self.class, id, method, *args)
    end

    def async_with(mode, method, *args)
      async_client(mode).enqueue(self.class, id, method, *args)
    end

    def async_client(mode = nil)
      return ActiveAsync.background if mode.nil?
      return ActiveAsync.background_for_mode(mode)
    end

  end
end
