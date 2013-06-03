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

  # specify any dependencies here; for example:
  # s.add_runtime_dependency "rest-client"
  s.add_dependency "activesupport", "~> 3.0"

  s.add_development_dependency "resque", "~> 1.19"
  s.add_development_dependency "sidekiq", "~> 1.2"
  s.add_development_dependency "rails", "~> 3.0"
  s.add_development_dependency "rspec", "~> 2.8.0"
  s.add_development_dependency "database_cleaner", "~> 0.7.0"
  s.add_development_dependency "sqlite3"
end
