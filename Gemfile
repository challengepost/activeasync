source 'https://rubygems.org'

gemspec

rails_version = ENV.fetch('RAILS_VERSION') { 'default' }

case rails_version
when "default"
  gem "rails", "~> 3.2"
else
  gem "rails", "~> #{rails_version}"
end

gem "rack-test"
