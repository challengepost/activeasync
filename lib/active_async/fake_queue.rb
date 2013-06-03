module ActiveAsync
  module FakeQueue
    extend self

    def self.enqueue(klass, *args)
      klass.send(:perform, *args)
    end
  end
end
