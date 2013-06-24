require "rails"
require "active_async"

module ActiveAsync
  class Railtie < Rails::Railtie
    initializer "active_async.configure_rails_initialization" do
      require "active_async/active_record"
      ::ActiveRecord::Base.send :include, ActiveAsync::ActiveRecord
    end
  end
end
