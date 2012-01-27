require "active_record"
require "rails"
require "active_async"

module ActiveAsync
  class Railtie < Rails::Railtie
    initializer "active_async.configure_rails_initialization" do
      ::ActiveRecord::Base.send :include, ActiveAsync::ActiveRecord
    end
  end
end
