# Example
#
# Location.should have_asynched(:update_carto_db)

module RSpec
  module Matchers
    module Async
      def have_asynched(expected)
        HaveAsyncJob.new expected
      end

      class HaveAsyncJob
        def initialize expected
          @expected = expected
        end

        def description
          "have an enqueued #{@expected}"
        end

        def failure_message
          "expected #{@klass} to have an enqueued #{@expected} but none found\n\n" +
            "found: #{@actual}"
        end

        def matches? klass
          @klass = klass
          @actual = Resque.queue(Resque.queue_for(klass)).collect { |x| x[:args] }.collect(&:second)
          @actual.include? @expected
          true
        end

        def negative_failure_message
          "expected  #{@klass}to not have an enqueued #{@expected}"
        end
      end
    end
  end
end

RSpec.configure do |config|
  config.include RSpec::Matchers::Async
end
