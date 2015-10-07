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
  if RUBY_VERSION == "1.9.3"
    gem "rack-cache", "= 1.2.0"
  else
    gem "rack-cache"
  end
  gem "rack-test"
end

group :development, :test do
  gem 'pry'
  gem 'pry-debugger'
end
