# ActiveAsync

ActiveAsync aims to provide an interface for easily setting up ActiveRecord objects
and ruby classes to run methods asynchronously.

ActiveAsync currently depends on ActiveSupport.

[![Build Status](https://secure.travis-ci.org/challengepost/activeasync.png)](http://travis-ci.org/challengepost/activeasync)

[![Code Climate](https://codeclimate.com/badge.png)](https://codeclimate.com/github/challengepost/activeasync)

## Install

In your Gemfile

    gem "activeasync"

Or via command line

    gem install activeasync

## Usage

Configure one of the supported adapters: `:sidekiq`, `:resque`, or `:inline` (useful for testing synchronously).

```ruby
# config/initializers/activeasync.rb
require "active_async"

ActiveAsync.queue_adapter = :sidekiq
```

Background class methods

``` ruby
class HeavyLifter
  include ActiveAsync::Async

  def self.lift(*stuff)
    # heavy lifting
  end
end

HeavyLifter.async(:lift, 1, 2, 3)
```

With ActiveRecord and Rails

``` ruby
# app/models/risky_business.rb
class RiskyBusiness < ActiveRecord::Base
  def party_time
    # all night long
  end
end

business = RiskyBusiness.last
business.async(:party_time)     # runs business#party_time asynchronously
```

Run callbacks asynchronously

``` ruby
class LateNite < ActiveRecord::Base
  after_save :drive_home, :async => true

  def drive_home
    # traffic jam
  end
end

late_nite = LateNite.last
late_nite.save                # runs late_night#drive_home asynchronously after save
```

## Testing

ActiveAsync comes with some helpers support for RSpec.

To remove Resque dependency from some of your specs, use the :stub_resque option in
selected spec blocks. Async methods will run in the foreground.

``` ruby
# spec/spec_helper.rb
require 'active_async/rspec'

# spec/models/late_nite_spec.rb
it "drive home after late nite save", :stub_resque do
  # all methods run in foreground
end
```

You can also manually set the Async background adapter to `ActiveAsync::FakeResque` or
any similar module/class that responds to `#enqueue(*args)`:

``` ruby
before do
  ActiveAsync.queue_adapter = :inline
end
```

### Matchers
* [have_asynched](#have_asynched)

#### have_asynched
*Describes the method that was expected to be executed asynchronously*
```ruby
Location.should have_asynched(:geocode)
```

## Contributing

To contribute to activeasync, clone the project and submit pull requests in a branch with tests.

To run tests, install the bundle and migrate the test database:

    $ bundle
    $ cd spec/dummy && bundle exec rake db:migrate db:test:prepare
