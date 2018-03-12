Feature: ReadOnly - Models
  Scenario:  A user has previously been persisted to the database, and an attempt to update it has been made
    Given There is a user that has been persisted to the database
    And The site is in read-only mode
    When I update the user
    Then the user should not be updated

  Scenario:  A new user is created (and was not previously persisted to the database), and an attempt to save it has been made
    Given There is a user that has not been persisted to the database
    And The site is in read-only mode
    When I save the user
    Then the user should not be saved