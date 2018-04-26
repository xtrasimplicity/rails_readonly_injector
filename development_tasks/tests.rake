require_relative 'support/file_helpers'
require_relative 'support/gem_helpers'

namespace :dev do
  RAILS_APP_PATH = File.expand_path('../../tmp/rails_app', __FILE__).freeze
  GEM_ROOT_PATH = File.expand_path('../..', __FILE__).freeze

  include GemHelpers
  include FileHelpers

  desc "Deploys a test rails application into the #{RAILS_APP_PATH} directory."
  task :deploy_test_app do
    switch_to_gems_root_path

    # Remove the app, if it exists already
    system("rm -rf #{RAILS_APP_PATH}")

    puts "Creating a new rails application..."
    FileUtils.mkdir_p RAILS_APP_PATH
    system("bundle exec rails new #{RAILS_APP_PATH}")

    switch_to_rails_app_path

    # Read gems defined in this Appraisal,
    # so we can write them to the Gemfile rails generated.
    # i.e. To 'override'/force a specific version.
    ensure_gem_versions_defined_in_appraisal_are_used

    # Add required gems to the gemfile
    add_gem 'simplecov', require: false, group: :test
    add_gem 'rails_readonly_injector', path: GEM_ROOT_PATH

    # Make sure we don't use the gemfile from Appraisal
    unset_appraisal_environment_variables

    # Install gems
    system("bundle install")

    system("bundle exec rails generate cucumber:install")
    system("bundle exec rails generate rspec:install")

    # RSpec: Include all files in support/
    append_to_file 'spec/spec_helper.rb', "Dir.glob('support/**/*.rb').each { |rb| require rb }"

    # Set up SimpleCov
    append_to_beginning_of_file 'spec/spec_helper.rb', %{
      require 'simplecov'
      require 'rails_readonly_injector'
    }
    append_to_beginning_of_file 'features/support/env.rb', "require 'simplecov'"
    
    write_file_with_content '.simplecov', %{
      SimpleCov.start do
        coverage_dir '#{GEM_ROOT_PATH}/coverage'
      end
    }

    # Prepare database migrations, etc
    system("bundle exec rails generate scaffold User name:string")
    
    system("RAILS_ENV=test bundle exec rake db:migrate")
  end

  desc "Synchronises tests from `cucumber_features` and `rspec_specs` into the rails application in #{RAILS_APP_PATH}, and runs the tests against the application."
  task :run_tests => [:run_features, :run_specs]

  desc "Synchronises features from `cucumber_features` into the rails application in #{RAILS_APP_PATH}, and runs them against the application."
  task :run_features do
    switch_to_rails_app_path

    # Synchronise the cucumber features
    FileUtils.cp_r File.join(GEM_ROOT_PATH, 'cucumber_features', '.'), 'features'

    unset_appraisal_environment_variables

    command_executed_successfully = system('bundle exec cucumber')
    
    exit 1 unless command_executed_successfully
  end

  desc "Synchronises specs from `rspec_specs` into the rails application in #{RAILS_APP_PATH}, and runs them against the application."
  task :run_specs do
    switch_to_rails_app_path

    # Synchronise the cucumber features
    FileUtils.cp_r File.join(GEM_ROOT_PATH, 'rspec_specs', '.'), 'spec'

    unset_appraisal_environment_variables

    
    command_executed_successfully = system('bundle exec rspec')
    
    exit 1 unless command_executed_successfully
  end

  def switch_to_gems_root_path
    FileUtils.cd GEM_ROOT_PATH
  end

  def switch_to_rails_app_path
    FileUtils.cd RAILS_APP_PATH
  end

  def unset_appraisal_environment_variables
    ENV.delete('BUNDLE_GEMFILE')
    ENV.delete('BUNDLE_BIN_PATH')
    ENV.delete('RUBYOPT')
  end


end