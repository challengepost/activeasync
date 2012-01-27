require 'active_async/fake_resque'

RSpec.configure do |c|
  c.treat_symbols_as_metadata_keys_with_true_values = true
  c.before(:each, :stub_resque) do |example|
    ActiveAsync.background = ActiveAsync::FakeResque
  end

  c.after(:each, :stub_resque) do |example|
    ActiveAsync.background = Resque
  end
end