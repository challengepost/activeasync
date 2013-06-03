require 'active_async'
require 'active_async/fake_queue'

RSpec.configure do |config|
  config.treat_symbols_as_metadata_keys_with_true_values = true

  config.around(:each, :stub_resque) do |example|
    async_mode = ActiveAsync.mode
    ActiveAsync.mode = :fake_queue
    example.run
    ActiveAsync.mode = async_mode
  end

  config.around(:each, :enable_resque) do |example|
    async_mode = ActiveAsync.mode
    ActiveAsync.mode = :resque
    example.run
    ActiveAsync.mode = async_mode
  end

end
