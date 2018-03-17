Feature: Configuration
  Scenario: When changing from read-only back to writeable
    Given I execute:
    """
    RailsReadonlyInjector.config do |config|
      config.read_only = true
    end

    RailsReadonlyInjector.reload!
    """
    When I execute:
    """
    RailsReadonlyInjector.config do |config|
      config.read_only = false
    end

    RailsReadonlyInjector.reload!
    """
    Then I should be able to create a user without any errors