require 'active_async'
require 'active_async/fake_resque'

RSpec.configure do |config|
  config.treat_symbols_as_metadata_keys_with_true_values = true
  config.before(:each, :stub_resque) do |example|
    ActiveAsync.background = ActiveAsync::FakeResque
  end

  config.after(:each, :stub_resque) do |example|
    ActiveAsync.background = Resque
  end
end