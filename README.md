# Rails ReadOnly Injector
[![Build Status](https://travis-ci.org/xtrasimplicity/rails_readonly_injector.svg?branch=master)](https://travis-ci.org/xtrasimplicity/rails_readonly_injector)[![Maintainability](https://api.codeclimate.com/v1/badges/151a348c5e63129e8dd4/maintainability)](https://codeclimate.com/github/xtrasimplicity/rails_readonly_injector/maintainability)<a href="https://codeclimate.com/github/xtrasimplicity/rails_readonly_injector/test_coverage"><img src="https://api.codeclimate.com/v1/badges/151a348c5e63129e8dd4/test_coverage" /></a>

Easily switch a Rails site into 'read-only' mode, and back again, without restarting the server.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'rails_readonly_injector'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install rails_readonly_injector

## Usage

To switch a complete site into read-only mode, simply set `RailsReadonlyInjector.config.read_only` to `true`, assign a Proc/lambda expression to `RailsReadonlyInjector.config.controller_rescue_action` and call `RailsReadonlyInjector.reload!`. 

To make things a little neater, you can pass a block to the `config` method, like this:

```
RailsReadonlyInjector.config do |config|
  config.read_only = false # Whether to set the site to read-only
  config.controller_rescue_action = lambda do |context|
    # This will be executed once an (unrescued) ActiveRecord::ReadOnlyRecord error is raised,
    # anywhere within a controller's action.
    # You can perform any redirection, logging etc from here. 

    # This lambda expression is evaluated from within the context of the controller that raised the error.
  end
end

RailsReadonlyInjector.reload!
```


## Development

After checking out the repo, run `bundle install` to install the dependencies.

RSpec specs and Cucumber features are stored in `rspec_specs` and `cucumber_features`, respectively. When `bundle exec rake` is run against an appraisal, the contents of these folders are copied to the necessary folders under the temporary rails application that is generated (by `bundle exec rake`) into `tmp/rails_app`.

To run tests for a specific version of Rails, simply run `bundle exec appraisal {APPRAISAL} bundle exec rake`, where `{APPRAISAL}` is one of the appraisals found under `Appraisals`.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/xtrasimplicity/rails_readonly_injector. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the RailsReadonlyInjector project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/xtrasimplicity/rails_readonly_injector/blob/master/CODE_OF_CONDUCT.md).
