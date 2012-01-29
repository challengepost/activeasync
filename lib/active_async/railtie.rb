require "rails"
require "active_record"
require "active_async"
require "active_async/active_record"

module ActiveAsync
  class Railtie < Rails::Railtie
    initializer "active_async.configure_rails_initialization" do
      ::ActiveRecord::Base.send :include, ActiveAsync::ActiveRecord
    end
  end
end
