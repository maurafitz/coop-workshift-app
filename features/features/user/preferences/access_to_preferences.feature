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
    And I am logged in
    And I am on my profile page
    
  Scenario: I take away my ability to access the form
    Then I should see "Select Workshifts Preference"
    When I follow "Open/Close Workshift Preference Form" 
    Then I should see "true" "3" times
    When I click "Open/Close Workshift Preference Form for Ryan"
    Then I should see "false" "1" times
    And I should see "true" "2" times
    When I go to my profile page
    Then I should not see "Select Workshifts Preference"
    
  Scenario: I open and close the form for everyone
    When I follow "Open/Close Workshift Preference Form" 
    Then I should see "true" "3" times
    When I follow "Close Workshift Preference Form for Everyone"
    Then I should see "false" "3" times
    And I should not see "true"
    When I follow "Open Workshift Preference Form for Everyone"
    Then I should see "true" "3" times
    And I should not see "false"