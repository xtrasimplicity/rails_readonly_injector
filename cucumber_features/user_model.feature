Feature: User model - When not in read-only mode
  Background:
    Given I execute:
    """
    ReadonlySiteToggle.config do |config|
      config.read_only = false
    end

    ReadonlySiteToggle.reload!
    """

  Scenario:  A user has previously been persisted to the database, and an attempt to update it has been made
    Given There is a user that has been persisted to the database
    When I update the user
    Then the user should be updated

  Scenario:  A new user is created (and was not previously persisted to the database), and an attempt to save it has been made
    Given There is a user that has not been persisted to the database
    When I save the user
    Then the user should be saved