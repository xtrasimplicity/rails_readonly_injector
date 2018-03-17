Feature: User Controller - When in read only mode    
  Scenario:  A user has previously been persisted to the database, and an attempt to update it has been made
    Given There is a user that has been persisted to the database
    And I execute:
    """
    RailsReadonlyInjector.config do |config|
      config.read_only = true
      config.controller_rescue_action = lambda do |context|
        if Rails::VERSION::STRING < '4.1.0'
          render :text => 'The site is currently in read-only mode'
        else
          render :plain => 'The site is currently in read-only mode'
        end
      end
    end

    RailsReadonlyInjector.reload!
    """
    When I'm using a web browser and attempt to update the user
    Then The page should contain 'The site is currently in read-only mode'
    And the user should not be updated
    

  Scenario:  A new user is created (and was not previously persisted to the database), and an attempt to save it has been made
    Given I execute:
    """
    RailsReadonlyInjector.config do |config|
      config.read_only = true
      config.controller_rescue_action = lambda do |context|
        if Rails::VERSION::STRING < '4.1.0'
          render :text => 'The site is currently in read-only mode'
        else
          render :plain => 'The site is currently in read-only mode'
        end
      end
    end

    RailsReadonlyInjector.reload!
    """
    When I'm using a web browser and attempt to create a user
    Then the user should not be saved