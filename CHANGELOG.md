## 1.0.0
 - Removed the ability to read the current read-only status using `RailsReadonlyInjector.config.read_only`, and replaced it with `RailsReadonlyInjector.in_read_only_mode?`.
## 0.3.0
 - Added ability to explicitly include specific classes.
## 0.2.0
 - Added ability to exclude specific classes from read-only mode.
 - Improved support for Rails 5 (Automatic inclusion of descendants of `ApplicationRecord` rather than `ActiveRecord::Base`).
## 0.1.1
 - Initial release