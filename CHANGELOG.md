## 0.0.4 (2013-06-03)
* Add support for Sidekiq mode
* Set client in callback via `:async => :resque`, `:async => :sidekiq`
* Replace FakeResque with FakeQueue class for testing

## 0.0.3 (2012-02-07)
* Ability to set ActiveAsync.background via ActiveAsync.mode = :resque or :fake_queue
* RSpec around blocks: :enable_resque, :stub_resque

## 0.0.2 (2012-01-26)
* railtie for initializing activeasync in rails
* rspec module for use in testing

## 0.0.1 (2012-01-26)

* async method: interface for sending methods with arguments to Resque
* :async => true option for running active model callbacks in the background
* ActiveRecord module to enable async option for after_save, after_update, and after_create
