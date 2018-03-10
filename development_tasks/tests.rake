require 'fileutils'

task :deploy_test_app_and_run_tests do
  RAILS_APP_PATH = 'tmp/rails_app'.freeze
  GEM_ROOT_PATH = File.expand_path('../..', __FILE__).freeze

  # Remove the app, if it exists already
  system("rm -rf #{RAILS_APP_PATH}")

  puts "Creating a new rails application..."
  FileUtils.mkdir_p RAILS_APP_PATH
  system("bundle exec rails new #{RAILS_APP_PATH}")

  FileUtils.cd RAILS_APP_PATH

  # Add readonly_site_toggle
  File.open('Gemfile', 'a') do |f|
    f.write %{gem "readonly_site_toggle", path: "#{GEM_ROOT_PATH}"\n}
  end

  # Install gems
  system("bundle install")

  # Prepare the Database
  system("RAILS_ENV=test bundle exec rake db:migrate")

  system("rails generate cucumber:install")

  # Set up the Cucumber tests
  FileUtils.cp_r File.join(GEM_ROOT_PATH, 'cucumber_features'), 'features'

  system("rake cucumber")
end