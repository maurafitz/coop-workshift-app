Feature: Workshift Manager: Set User Access to Preference Page 
  As a workshift manager
  In order to provide a way to stop users from editing their preferences
  I would like to be able to turn on and off their ability to edit
  
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

  Scenario: I take away everyone's ability to access the form
    Then I should see "Select Workshifts Preferences"
    And I follow "View & Edit Users" 
    Then I should see "true"
    And I should see "coop_admin@berkeley.edu"
    And I should see "Toggle whether or not the preference form is still editable for all users."
    When I follow "Giorgia Willits"
    Then I should see "gwillits@berkeley.edu"
    And I should see "true"
    And I should see "Toggle whether or not the preference form is still editable for all users."
    When I toggle all
    # Then I should see "gwillits@berkeley.edu"
    # Then I should see "false"
    # And I should see "Toggle whether or not the preference form is still editable for all users."
    # When I follow "Eric Nelson"
    # Then I should see "ericn@berkeley.edu"
    # And I should see "false"
    # When I go to my profile page
    # Then I should not see "Select Workshifts Preference"
  
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
    
  @wip
  Scenario: Admin should be able to edit user info (Permissions)
    Then I should see "Select Workshifts Preferences"
    And I follow "View & Edit Users" 
    Then I should see "Ryan Riddle"
    When I follow "Ryan Riddle"
    Then I should see "ry@berkeley.edu"
    And I should see "Permissions:	Member"
    And I should see "Compensated Hours:	0"
    When I click "Edit Profile"
    Then I should see "Compensated Hours"
    When I click "Permissions"
    And I click "Workshift-Manager"
    Then I should see "Workshift-Manager"
    And I click "Update User"
    Then I should see "ry@berkeley.edu"
    And I should see "Compensated Hours:	0"
    And I should see "Permissions:	Workshift-Manager"
  
  @wip  
  Scenario: I give everyone the ability to access the form
    When I follow "View & Edit Users"
    And I follow "Open Workshift Preference Form for Everyone"
    Then I should see "true"
    When I go to my profile page
    Then I should see "Select Workshifts Preference"
  
  @wip  
  Scenario: I take away one person's access to the form
    When I follow "View & Edit Users"
    And I follow "Open Workshift Preference Form for Everyone"
    When I follow "Eric Nelson"
    And I follow "Toggle Preference Form for Eric Nelson"
    Then I should see "false"
    When I follow "Giorgia Willits"
    Then I should see "true"