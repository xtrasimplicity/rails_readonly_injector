require "bundler/gem_tasks"

development_tasks_path = File.expand_path('../development_tasks', __FILE__)

Dir[File.join(development_tasks_path, '*.rake')].each { |rb| load rb }

task :default => :deploy_test_app_and_run_tests