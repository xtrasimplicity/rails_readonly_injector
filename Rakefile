require "bundler/gem_tasks"

development_tasks_path = File.expand_path('../development_tasks', __FILE__)

Dir[File.join(development_tasks_path, '*.rake')].each { |rb| load rb }

task :default => ['dev:deploy_test_app', 'dev:run_tests']