# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "active_async/version"

Gem::Specification.new do |s|
  s.name        = "activeasync"
  s.version     = ActiveAsync::VERSION
  s.authors     = ["Ross Kaffenberger"]
  s.email       = ["rosskaff@gmail.com"]
  s.homepage    = ""
  s.summary     = %q{Add async support to ruby objects}
  s.description = %q{Provides async methods ruby objects for queuing background jobs. Currently supports Resque. Bonus: callback hooks for ActiveRecord objects}

  s.rubyforge_project = "activeasync"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {spec}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_dependency "activesupport", ">= 3.0"

  s.add_development_dependency "resque", "~> 1.25"
  s.add_development_dependency "sidekiq", "~> 2.17.0"
  s.add_development_dependency "rails", ">= 3.0"
  s.add_development_dependency "rspec", ">= 3"
  s.add_development_dependency "sqlite3"
  s.add_development_dependency "database_cleaner", "~> 1.4.1"
  s.add_development_dependency "mock_redis"
end
