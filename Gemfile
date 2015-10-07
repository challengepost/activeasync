source 'https://rubygems.org'

gemspec

rails_version = ENV.fetch('RAILS_VERSION') { 'default' }

case rails_version
when "default"
  gem "rails", "~> 4.1.0"
else
  gem "rails", "~> #{rails_version}"
end

group :test do
  gem "rack-test"
end

group :development, :test do
  gem 'pry'
  gem 'pry-byebug'
end
