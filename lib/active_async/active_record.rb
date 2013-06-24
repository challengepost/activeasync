module ActiveAsync
  module ActiveRecord
    extend ActiveSupport::Concern

    included do
      include ActiveAsync::Async
      include ActiveAsync::Callbacks

      define_async_callbacks :after_save,
        :after_update,
        :after_create,
        :after_commit
    end

  end
end
