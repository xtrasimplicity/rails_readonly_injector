# frozen_string_literal: true

require_relative 'support/file_helpers'
require_relative 'support/gem_helpers'

namespace :dev do
  include GemHelpers
  include FileHelpers

  desc 'Deploys a test rails application.'
  task :deploy_test_app do
    switch_to_gems_root_path

    puts 'Creating a new rails application...'
    generate_rails_application

    switch_to_rails_app_path

    ensure_gem_versions_defined_in_appraisal_are_used

    # Add required gems to the gemfile
    add_gem 'simplecov', require: false, group: :test
    add_gem 'rails_readonly_injector', path: gems_root_path

    # Make sure we don't use the gemfile from Appraisal
    unset_appraisal_environment_variables

    # Install gems
    system("bundle install")

    puts 'Executing Generators...'
    system('bundle exec rails generate cucumber:install')
    system('bundle exec rails generate rspec:install')

    # RSpec: Include all files in support/
    append_to_file 'spec/spec_helper.rb', "Dir.glob('support/**/*.rb').each { |rb| require rb }"

    install_simplecov("#{gems_root_path}/coverage")
    
    # Prepare database migrations, etc
    system('bundle exec rails generate scaffold User name:string')
    
    system('RAILS_ENV=test bundle exec rake db:migrate')
  end

  desc 'Synchronises tests from `cucumber_features` and `rspec_specs` into the temporary rails app, and runs them.'
  task run_tests: %i[run_features run_specs]

  desc 'Synchronises features from `cucumber_features` into the temporary rails app, and runs them.'
  task :run_features do
    switch_to_rails_app_path

    # Synchronise the cucumber features
    FileUtils.cp_r File.join(gems_root_path, 'cucumber_features'), 'features'

    unset_appraisal_environment_variables

    command_executed_successfully = system('bundle exec cucumber')
    
    exit 1 unless command_executed_successfully
  end

  desc 'Synchronise specs from `rspec_specs` into the temporary rails app, and run rspec.'
  task :run_specs do
    switch_to_rails_app_path

    # Synchronise the RSpec specs
    FileUtils.cp_r File.join(gems_root_path, 'rspec_specs'), 'spec'

    unset_appraisal_environment_variables

    command_executed_successfully = system('bundle exec rspec')
    
    exit 1 unless command_executed_successfully
  end

end