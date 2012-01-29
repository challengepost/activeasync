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

## Contributing

To contribute to activeasync, clone the project, 

To run tests, install the bundle and migrate the test database:

    $ bundle
    $ cd spec/dummy && bundle exec rake db:migrate db:test:prepare

Please provide pull requests with tests.