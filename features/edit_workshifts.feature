@javascript
Feature: View and Edit Workshifts
  As a work-shift manager,
  In order to keep workshift information up-to-date and prevent changes by non-admins,
  I would like to view and edit workshift attributes.
  
  Background:
    Given some workshifts have been created for the semester
    And I am on the view workshifts page
  
  
  Scenario: A member views workshifts for the semester but cannot edit
    Given I am logged in as a member
    And I am on the view workshifts page
    Then I should see "Listing Shifts"
    And I should see a workshift table
    And I should see "Maura Fitz"
    And I should not see "Edit"
    
  @wip  
  Scenario: An admin edits a workshift
    Given I am logged in as an admin
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
    Given I am logged in as an admin
    When I follow "Edit" for "Head Cook"
    When I fill in "Name" with ""
    And I press "Save Changes"
    Then I should be on the edit workshift page
    And I should see "Your edits are not valid."
 
  