Feature: View Workshift Table
  As a user of any type,
  In order to learn more about a workshift,
  I would like to view the list of workshifts and select one to see more details.
  
  Background:
    Given I am the following user:
    | first_name      | last_name     | email                     |   password     |    permissions   |
    | Maura           | Fitz          | mf@berkeley.edu           |   mypwd        |      0           |
    And I am logged in
    And I am a member of "Cloyne"
    And the following metashifts exist:
    | category      | name                             | id | description                                   |
    | Kitchen       | Kitchen Manager                  | 1  | Refer to bylaws for manager description.      |
    | Kitchen       | Head Cook                        | 2  | Lead a team in cooking meals.                 |
    | Garbage       | Waste Reduction Coordinator      | 3  | Coordinate waste reduction. Go to CO.         |
    And I am assigned the following shifts:
    | start_time    | end_time     | date          | metashift_id |
    | 2pm           | 4pm          | May 17, 2016  | 2            |
    | 5am           | 11am         | May 18, 2016  | 3            |
    And I am on the view workshifts page
  
  @local @javascript
  Scenario: A regular user can see all workshift slots for the semester
    Then I should see "Listing Shifts"
    And I should see a workshift table
    And I should see "Maura Fitz" in the row for "Head Cook"
    And I should see "Maura Fitz" in the row for "Waste Reduction Coordinator"

  @local @javascript
  Scenario: A user can click to view a workshift description
    Then I should not see "Lead a team in cooking meals."
    When I click "Description" in the row for "Head Cook"
    Then I should see "Lead a team in cooking meals."
    And I should not see "Coordinate waste reduction. Go to CO."

 Scenario: A regular user can't edit workshifts
    Then I should see "Listing Shifts"
    And I should not see "Edit Workshifts"
 
  