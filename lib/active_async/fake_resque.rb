module ActiveAsync
  module FakeResque
    extend self

    def self.enqueue(klass, *args)
      klass.send(:perform, *args)
    end
  end
end
