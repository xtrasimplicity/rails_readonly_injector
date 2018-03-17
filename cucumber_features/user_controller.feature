Feature: Users Controller - When not in read only mode
  Background:
    Given I execute:
    """
    RailsReadonlyInjector.config do |config|
      config.read_only = false
    end

    RailsReadonlyInjector.reload!
    """

  Scenario:  A user has previously been persisted to the database, and an attempt to update it has been made
    Given There is a user that has been persisted to the database
    When I'm using a web browser and attempt to update the user
    Then the user should be updated
    

  Scenario:  A new user is created (and was not previously persisted to the database), and an attempt to save it has been made
    Given I'm using a web browser and attempt to create a user
    Then the user should be created