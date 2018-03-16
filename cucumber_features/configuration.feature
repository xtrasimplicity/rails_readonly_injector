Feature: Configuration
  Scenario: When changing from read-only back to writeable
    Given I execute:
    """
    ReadonlySiteToggle.config do |config|
      config.read_only = true
    end

    ReadonlySiteToggle.reload!
    """
    When I execute:
    """
    ReadonlySiteToggle.config do |config|
      config.read_only = false
    end

    ReadonlySiteToggle.reload!
    """
    Then I should be able to create a user without any errors