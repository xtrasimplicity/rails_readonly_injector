require File.expand_path('../../../lib/readonly_site_toggle', __FILE__)
require 'aruba/cucumber'

After do |scenario|
  if scenario.failed?
    puts last_command_stopped.stdout
    puts last_command_stopped.stderr
  end
 end
