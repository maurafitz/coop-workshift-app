@javascript
Feature: Workshift Manager: Set User Access to Preference Page 
  As a workshift manager
  In order to provide a way to stop users from editing their preferences
  I would like to be able to turn on and off their ability to edit
  
  Background:
    Given the following users are members of "Cloyne":
    | first_name      | last_name     | email                     |   password     |    permissions   |
    | Eric            | Nelson        | ericn@berkeley.edu        |   bunnny       |      0           |
    | Giorgia         | Willits       | gwillits@berkeley.edu     |   tortoise     |      0           |
    | Ryan            | Riddle        | ry@berkeley.edu           |   hare         |      2           |

    And I log in with "ry@berkeley.edu", "hare"
    And I am on my profile page

  Scenario: I take away everyone's ability to access the form and then give them access
    Then I should see "Select Workshifts Preferences"
    And I follow "View & Edit Users" 
    Then I should see "true"
    And I should see "ry@berkeley.edu"
    And I should see "Toggle whether or not the preference form is still editable for all users."
    When I follow "Giorgia Willits"
    Then I should see "gwillits@berkeley.edu"
    And I should see "true"
    And I should see "Toggle whether or not the preference form is still editable for all users."
    When I toggle all off
    When I follow "Eric Nelson"
    Then I should see "ericn@berkeley.edu"
    Then I follow "Giorgia Willits"
    And I should see "gwillits@berkeley.edu"
    And I should see "Toggle whether or not the preference form is still editable for all users."

  
  @wip  
  Scenario: I take away one person's access to the form
    When I follow "View & Edit Users"
    And I follow "Open Workshift Preference Form for Everyone"
    When I follow "Eric Nelson"
    And I toggle theirs
    Then I should see "false"
    When I follow "Giorgia Willits"
    Then I should see "true"