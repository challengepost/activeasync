module ActiveAsync
  module Callbacks
    extend ActiveSupport::Concern

    module ClassMethods

      def define_async_callbacks(*callback_names)
        callback_names.each do |callback_name|
          class_eval <<-RUBY
            define_callbacks :async_#{callback_name}

            def self.#{callback_name}_with_async(*methods)
              #{callback_name}_without_async(*extract_async_methods(methods))
            end

            class << self
              alias_method_chain :#{callback_name}, :async
            end
          RUBY
        end
      end

      private

      def extract_async_methods(methods)
        options = methods.extract_options!
        methods = options[:async] ? define_async_methods(methods) : methods
        methods.push(options.except(:async))
      end

      def define_async_methods(methods)
        methods.map do |method_name|
          async_name = "async_#{method_name}"
          unless instance_methods.include?(async_name)
            define_method(async_name) do
              async(method_name)
            end
          end
          async_name
        end
      end

    end
  end
end