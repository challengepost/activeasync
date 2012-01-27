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
class HeavyLifter
  include ActiveAsync::Async

  def lift(*stuff)
  end
end

HeavyLifter.async(:lift, 1, 2, 3)
```

Run ActiveRecord callbacks asynchronously

``` ruby
ActiveRecord.send :include, ActiveAsync::ActiveRecord

class LateNite < ActiveRecord::Base
  after_save :drive_home, :async => true

  def drive_home
    # takes a long time in traffic
  end

  def phone_call
  end
end

late_nite = LateNite.last
late_nite.async(:phone_call)  # runs late_nite#phone_call asynchronously
late_nite.save                # runs late_night#drive_home asynchronously
```
