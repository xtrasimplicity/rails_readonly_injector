# Readonly Site Toggle
[![Build Status](https://travis-ci.org/xtrasimplicity/readonly_site_toggle.svg?branch=master)](https://travis-ci.org/xtrasimplicity/readonly_site_toggle)

Easily switch a Rails site into 'read-only' mode, and back again, without restarting the server. Edit
Add topics

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'readonly_site_toggle'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install readonly_site_toggle

## Usage

TODO: Write usage instructions here

## Development

After checking out the repo, run `bundle install` to install the dependencies.

RSpec specs and Cucumber features are stored in `rspec_specs` and `cucumber_features`, respectively. When `bundle exec rake` is run against an appraisal, the contents of these folders are copied to the necessary folders under the temporary rails application that is generated (by `bundle exec rake`) into `tmp/rails_app`.

To run tests for a specific version of Rails, simply run `bundle exec appraisal {APPRAISAL} bundle exec rake`, where `{APPRAISAL}` is one of the appraisals found under `Appraisals`.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/xtrasimplicity/readonly_site_toggle. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the ReadonlySiteToggle project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/xtrasimplicity/readonly_site_toggle/blob/master/CODE_OF_CONDUCT.md).
