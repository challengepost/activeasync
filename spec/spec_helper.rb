dir = File.dirname(File.expand_path(__FILE__))
$LOAD_PATH.unshift dir + '/../lib'

# Configure Rails Environment
ENV["RAILS_ENV"] ||= 'test'

require 'database_cleaner'
require 'mock_redis'
require 'resque'
require 'sidekiq'
require 'sidekiq/testing'

require File.expand_path("../sample/config/environment.rb",  __FILE__)

# Load support files
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }

RSpec.configure do |config|
  config.mock_with :rspec

  config.before(:suite) do
    Redis.current = MockRedis.new
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with(:truncation)
  end

  config.before(:each) do
    DatabaseCleaner.start
    Resque.inline = true
    Sidekiq::Testing.inline!
    ActiveAsync.queue_adapter = :inline
  end

  config.before(:each, :resque) do
    ActiveAsync.queue_adapter = :resque
  end

  config.before(:each, :sidekiq) do
    ActiveAsync.queue_adapter = :sidekiq
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end
end
