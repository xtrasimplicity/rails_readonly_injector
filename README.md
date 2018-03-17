# Rails ReadOnly Injector
[![Build Status](https://travis-ci.org/xtrasimplicity/rails_readonly_injector.svg?branch=master)](https://travis-ci.org/xtrasimplicity/rails_readonly_injector)
[![Maintainability](https://api.codeclimate.com/v1/badges/427c153efd48ae03f688/maintainability)](https://codeclimate.com/github/xtrasimplicity/rails_readonly_injector/maintainability)
[![Test Coverage](https://api.codeclimate.com/v1/badges/427c153efd48ae03f688/test_coverage)](https://codeclimate.com/github/xtrasimplicity/rails_readonly_injector/test_coverage)

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

In order to switch a complete site into read-only mode, you will first need to set the action to occur when an attempt to commit changes to the database is made, from within a controller. Usually, this won't need to change once the application has booted, so I recommend defining it within an initializer, as follows:

```
# config/initializers/rails_readonly_injector.rb
RailsReadonlyInjector.config do |config|
  config.controller_rescue_action = lambda do |context|
    # Define actions to be performed if changes to a read-only model are attempted to be committed to the database.
    # This lambda expression is evaluated from within the instance of the referring controller.

    # You may want to set a redirect, or flash an error message, or something, here.
    # e.g.
    # flash[:danger] = 'The site is currently in read-only mode'
    # redirect_to readonly_page_url
  end
end
```

When you want to switch a site into read-only mode, you can then simply set `RailsReadonlyInjector.read_only` to true and then call `RailsReadonlyInjector.reload!` to (re-)load the configuration. Alternatively, you can also set `read_only` from within the configuration block inside the initializer.

If you want to reset the configuration to the defaults, you can simply call `RailsReadonlyInjector.reset_configuration!` from anywhere in your application.

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
