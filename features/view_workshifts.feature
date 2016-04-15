@javascript
Feature: View Workshift Table
  As a user of any type,
  In order to learn more about a workshift,
  I would like to view the list of workshifts and select one to see more details.
  
  Background:
    Given I am logged in as a user
    And some workshifts have been created for the semester
    And I am on the view workshifts page
  
  Scenario: A regular user can see all workshift slots for the semester
    Then I should see "Listing Shifts"
    And I should see a workshift table
    And I should see "Maura Fitz" in the row for "Kitchen"

  Scenario: A user can click to view a workshift description
    #When I click "Description" in the row for "Kitchen"
    #Then I should see "Sweeping the kitchen floors"

 Scenario: A regular user can't edit workshifts
    Then I should see "Listing Shifts"
    And I should not see "Edit"
 
  