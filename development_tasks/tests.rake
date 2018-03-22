require 'fileutils'

namespace :dev do
  RAILS_APP_PATH = File.expand_path('../../tmp/rails_app', __FILE__).freeze
  GEM_ROOT_PATH = File.expand_path('../..', __FILE__).freeze

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
    gems_defined_in_appraisal = parse_gemfile(ENV['BUNDLE_GEMFILE'])
    gems_defined_in_gemfile = parse_gemfile('Gemfile').collect { |l| l.gem_name }

    gems_to_override = gems_defined_in_appraisal.reject { |l| gems_defined_in_gemfile.include? l.gem_name }.collect { |gem| gem.original_line_in_gemfile }

    # Add required gems to the gemfile
    append_to_file 'Gemfile', gems_to_override.join("\n")
    append_to_file 'Gemfile', %{gem 'simplecov', require: false, group: :test\n}
    append_to_file 'Gemfile', %{gem "rails_readonly_injector", path: "#{GEM_ROOT_PATH}"\n}

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
  task :run_tests do
    switch_to_rails_app_path

    # Set up the Cucumber and RSpec tests
    FileUtils.cp_r File.join(GEM_ROOT_PATH, 'cucumber_features', '.'), 'features'
    FileUtils.cp_r File.join(GEM_ROOT_PATH, 'rspec_specs', '.'), 'spec'

    unset_appraisal_environment_variables

    exit_code = system('bundle exec cucumber && bundle exec rspec')
    exit exit_code
  end

  def parse_gemfile(file_path)
    gems = []

    File.open(file_path).readlines.each do |line|
      matches = line.match /^\s*gem\s+['|"]/

      next if matches.nil?

      parts = line.split(',')
      
      gem_name = parts.first.gsub(/\s*gem\s*|["|']|\n/, '')

      gems << OpenStruct.new({ gem_name: gem_name, original_line_in_gemfile: line })
    end

    gems
  end

  def switch_to_gems_root_path
    FileUtils.cd GEM_ROOT_PATH
  end

  def switch_to_rails_app_path
    FileUtils.cd RAILS_APP_PATH
  end

  def append_to_file(path_to_file, content)
    raise 'The specified path is not a file!' unless File.file? path_to_file

    File.open(path_to_file, 'a') do |f|
      f.write content
    end
  end

  def append_to_beginning_of_file(path_to_file, content)
    raise 'The specified path is not a file!' unless File.file? path_to_file

    existing_content_as_array = File.open(path_to_file, 'r').readlines

    new_content_arr = [content] + existing_content_as_array

    write_file_with_content path_to_file, new_content_arr.join("\n")
  end

  def write_file_with_content(path_to_file, content)
    File.open(path_to_file, 'w') do |f|
      f.write content
    end
  end

  def unset_appraisal_environment_variables
    ENV.delete('BUNDLE_GEMFILE')
    ENV.delete('BUNDLE_BIN_PATH')
    ENV.delete('RUBYOPT')
  end
end