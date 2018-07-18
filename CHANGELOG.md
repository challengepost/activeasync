## 0.2.1 (2018-07-18)

* Don't break for sidekiq-only users
* Now testing against Rails 4.2 only

## 0.2.0 (2015-10-07)

* BREAKING CHANGES: Support is dropped for Ruby 1.9.3. Please use Ruby 2.x.x

## 0.1.0 (2015-04-20)

* BREAKING CHANGES: background, mode, skip? are all removed and replaced with
  ActiveAsync.queue_adapter to match the ActiveJob API and simplify setup

## 0.0.3 (2012-02-07)
* Ability to set ActiveAsync.background via ActiveAsync.mode = :resque or :fake_resque
* RSpec around blocks: :enable_resque, :stub_resque

## 0.0.2 (2012-01-26)
* railtie for initializing activeasync in rails
* rspec module for use in testing

## 0.0.1 (2012-01-26)

* async method: interface for sending methods with arguments to Resque
* :async => true option for running active model callbacks in the background
* ActiveRecord module to enable async option for after_save, after_update, and after_create
