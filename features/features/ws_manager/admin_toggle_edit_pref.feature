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
    And I should see "Open"
    And I should see "Toggle whether or not the preference form is still editable for all users."
    When I toggle all off
    When I follow "Eric Nelson"
    Then I should see "ericn@berkeley.edu"
    And I should see "Closed"
    When I toggle all on
    Then I follow "Giorgia Willits"
    And I should see "gwillits@berkeley.edu"
    And I should see "Toggle whether or not the preference form is still editable for all users."
    And I should see "Open"

  
  Scenario: I take away one person's access to the form
    Then I should see "Select Workshifts Preferences"
    When I follow "View & Edit Users"
    When I follow "Eric Nelson"
    And I toggle theirs off
    Then I should see "Closed"
    When I follow "Giorgia Willits"
    And I toggle theirs on
    Then I should see "Open"