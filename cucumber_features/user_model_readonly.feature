Feature: User model - When in read-only mode
  Scenario: A user has previously been persisted to the database, and an attempt to update it has been made
    Given There is a user that has been persisted to the database
    And I execute:
    """
    ReadonlySiteToggle.config do |config|
      config.read_only = true
    end

    ReadonlySiteToggle.reload!
    """
    When I update the user
    Then the user should not be updated

  Scenario:  A new user is created (and was not previously persisted to the database), and an attempt to save it has been made
    Given There is a user that has not been persisted to the database
    And I execute:
    """
    ReadonlySiteToggle.config do |config|
      config.read_only = true
    end

    ReadonlySiteToggle.reload!
    """
    When I save the user
    Then the user should not be saved