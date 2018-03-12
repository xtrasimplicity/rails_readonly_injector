Given(/The site is( not)? in read-only mode/) do |should_be_readonly|
  should_be_readonly = !!((should_be_readonly =~ /\s*not/i).nil?)

  ReadonlySiteToggle.config do |config|
    config.read_only = should_be_readonly
  end

  ReadonlySiteToggle.reload!
end