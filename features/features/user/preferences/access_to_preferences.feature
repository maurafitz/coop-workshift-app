Feature: Workshift Manager: View and edit user information
  As a workshift manager
  In order to assist my coop's members
  I would like to be able to view and edit their profile
  
  Background:
    Given the following users exist:
    | first_name      | last_name     | email                     |   password     |    permissions   |
    | Eric            | Nelson        | ericn@berkeley.edu        |   bunnny       |      0           |
    | Giorgia         | Willits       | gwillits@berkeley.edu     |   tortoise     |      0           |
    And I am the following user:
    | first_name      | last_name     | email                     |   password     |    permissions   |
    | Ryan            | Riddle        | ry@berkeley.edu           |   hare         |      2           |
    And I am logged in as an admin
    And I am on my profile page
  
  Scenario: Admin should be able to edit user info (Compensated Hours)
    Then I should see "Select Workshifts Preferences"
    And I follow "View & Edit Users" 
    Then I should see "Ryan Riddle"
    When I follow "Ryan Riddle"
    Then I should see "ry@berkeley.edu"
    And I should see "Permissions:	Workshift-Manager"
    And I should see "Compensated Hours:	0"
    When I follow "Edit Profile"
    Then I should see "Compensated Hours"
    When I fill in "Compensated Hours" with "5"
    And I click "Update User"
    Then I should see "Compensated Hours:	5"
    And I should see "ry@berkeley.edu"

  Scenario: Admin should be able to edit user info (Permissions)
    Then I should see "Select Workshifts Preferences"
    And I follow "View & Edit Users" 
    Then I should see "Ryan Riddle"
    When I follow "Ryan Riddle"
    Then I should see "ry@berkeley.edu"
    And I should see "Permissions:	Workshift-Manager"
    And I should see "Compensated Hours:	0"
    When I click "Edit Profile"
    Then I should see "Compensated Hours"
    When I click "Permissions"
    And I click "Member"
    Then I should see "Member"
    And I click "Update User"
    Then I should see "ry@berkeley.edu"
    And I should see "Compensated Hours:	0"
    # And I should see "Permissions:	Member"

  Scenario: Admin should be able to see users preferences
    Given I am a member of "Cloyne"
    And the following metashifts exist:
    | category      | name                             | id | description                                   |
    | Kitchen       | Kitchen Manager                  | 1  | Refer to bylaws for manager description.      |
    And I have saved the following shift preferences:
    | Kitchen         | 4       |
    And I have saved the following time preferences:
    | day         | times              | availability  |
    | Monday      | 8am-6pm            | Unavailable   |
    When I follow "View & Edit Users"
    Then I should see "Preferences"
    And I should see "4"