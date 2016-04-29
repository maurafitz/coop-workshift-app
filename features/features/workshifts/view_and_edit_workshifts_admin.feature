@javascript
Feature: Workshift Manager: View and Edit Workshifts
  As a work-shift manager,
  In order to keep workshift information up-to-date and prevent changes by non-admins,
  I would like to view and edit workshift attributes.
  
  Background:
    Given the following users are members of "Cloyne":
    | first_name      | last_name     | email                     |   password     |    permissions   |
    | Maura           | Fitz          | mf@berkeley.edu           |   mypwd        |      0           |
    | Giorgia         | Willits       | gw@berkeley.edu           |   gwpwd        |      2           |
    And the following metashifts exist:
    | category      | name                             | id | description                                   |
    | Kitchen       | Head Cook                        | 2  | Lead a team in cooking meals.                 |
    | Garbage       | Waste Reduction Coordinator      | 3  | Coordinate waste reduction. Go to CO.         |
    And "Maura" is assigned the following workshifts:
    | start_time    | end_time     | day           | metashift_id |
    | 2:00pm           | 4:00pm          | Monday        | 2            |
    | 5:00am           | 11:00am         | Tuesday       | 3            |
  
  @local
  Scenario: A member views workshifts for the semester but cannot edit
    Given I am logged in as "Maura"
    And I am on the view workshifts page
    Then I should see "Shifts for the Week"
    And I should see a workshift table
    And I should see "Maura Fitz"
    And I should see "Head Cook"
    And I should not see "Edit"
    
  @wip  
  Scenario: An admin edits a workshift
    Given I am logged in as "Giorgia"
    When I follow "Edit" for "Head Cook"
    Then I should be on the edit workshift page
    And I should see "Head Cook"
    When I fill in "Category" with "Food"
    And I press "Save Changes"
    Then I should be on the view workshifts page
    And I should see "Your workshift has been updated."
    And I should see "Food" in the row for "Head Cook"
    
  @wip
  Scenario: An admin tries to edit a workshift incorrectly
    Given I am logged in as "Giorgia"
    When I follow "Edit" for "Head Cook"
    When I fill in "Name" with ""
    And I press "Save Changes"
    Then I should be on the edit workshift page
    And I should see "Your edits are not valid."
 
  