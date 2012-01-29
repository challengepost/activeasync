# ActiveAsync

ActiveAsync aims to provide an interface for easily setting up ActiveRecord objects
and ruby classes to run methods asynchronously.

ActiveAsync currently depends on Resque and ActiveSupport.

[![Build Status](https://secure.travis-ci.org/challengepost/activeasync.png)](http://travis-ci.org/challengepost/activeasync)

## Install

In your Gemfile

    gem "activeasync"

Or via command line

    gem install activeasync


## Usage

Background class methods

``` ruby
require 'active_async'

class HeavyLifter
  include ActiveAsync::Async

  def lift(*stuff)
    # heavy lifting
  end

end

HeavyLifter.async(:lift, 1, 2, 3)
```

With ActiveRecord and Rails

``` ruby
# config/application.rb
require 'active_async/railtie'

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

## RSpec

ActiveAsync comes with some helpers support for RSpec.

To remove Resque dependency from some of your specs, use the :stub_resque option in
selectd spec blocks. Async methods will run in the foreground.

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
  ActiveAsync.background = ActiveAsync::FakeResque
end
```

## Contributing

To contribute to activeasync, clone the project and submit pull requests in a branch with tests.

To run tests, install the bundle and migrate the test database:

    $ bundle
    $ cd spec/dummy && bundle exec rake db:migrate db:test:prepare
