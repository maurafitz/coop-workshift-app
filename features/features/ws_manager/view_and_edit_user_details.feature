@javascript
Feature: View and Edit User Details
  As a work-shift manager
  In order to keep my house's directory and contact information accurate
  I would like to be able to view and edit each of my member's profile details.
  
  Background:
    # A member sets up their details
    Given the following users exist:
    | first_name | last_name | email              | password  | permissions | hour_balance | fine_balance |
    | Aziz       | Ansari    | aziz@berk.edu      | password1 | 0           | 3            | 0            |
  
  @wip
  Scenario: A workshift manager
    Given I am logged in as a workshift manager
    And I am on the manage users page
    And I search for and select "Aziz Ansari"
    Then I should see "aziz@berk.edu"
    And I should not see "password1"
    And I should see "Member"
 
  @wip
  Scenario: A workshift manager attempts to search for a non-existent member
    Given I am logged in as a workshift manager
    And I am on the manage users page
    And I search for "a rando"
    Then I should not see "a rando"
  
  @wip
  Scenario: A workshift manager edits a user's details
    Given I am logged in as a workshift manager
    And I am on the manage users page
    And I search for and select "Aziz Ansari"
    When I click "Edit"
    And I fill in "Email" with "aziz@berkeley.edu"
    And I fill in "First Name" with "Arthur"
    And I click "Save"
    Then I should be on the manage users page
    And I should see "aziz@berkeley.edu"
    And I should see "Arthur"
  
  Scenario: A member cannot access the manage users page but can edit their own details
    Given I am the following user:
    | first_name | last_name | email           | password | permissions | hour_balance | fine_balance |
    | momo       | fitzzz    | mf@berkeley.edu | password | 0           | 00          | 0            |
    And I am a member of "Cloyne"
    And I am logged in
    And I go to the manage users page
    Then I should be on the home page
    And I am on my edit profile page
    Then I should see "Edit Account"

    
    