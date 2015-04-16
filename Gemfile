source 'https://rubygems.org'

gemspec

rails_version = ENV.fetch('RAILS_VERSION') { 'default' }

case rails_version
when "default"
  gem "rails", "~> 4.1.0"
else
  gem "rails", "~> #{rails_version}"
end

gem "rack-test"

group :development, :test do
  gem 'pry'
  gem 'pry-debugger'
end
