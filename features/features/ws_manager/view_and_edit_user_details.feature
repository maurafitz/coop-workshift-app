@javascript
Feature: View and Edit User Details
  As a work-shift manager
  In order to keep my house's directory and contact information accurate
  I would like to be able to view and edit each of my member's profile details.
  
  Background:
    Given the following users are members of "Cloyne":
    | first_name      | last_name     | email                     |   password     |    permissions   |
    | Eric            | Nelson        | ericn@berkeley.edu        |   bunnny       |      0           |
    | Giorgia         | Willits       | gwillits@berkeley.edu     |   tortoise     |      0           |
    | Alex            | Danily        | adanily@berkeley.edu      |   hare         |      1           |
    | Maura           | Fitz          | mfitz@berkeley.edu        |   kitty        |      2           |
  
  Scenario: A workshift manager
    Given I log in with "mfitz@berkeley.edu", "kitty"
    And I am on the manage users page
    And I click "Giorgia Willits"
    Then I should see the following: "Email", "gwillits@berkeley.edu", "Permissions", "Member", "Compensated Hours"
    And I should not see "tortoise"
    When I click "Eric Nelson"
    Then I should see the following: "ericn@berkeley.edu", "Member"
    When I click "Alex Danily"
    Then I should see the following: "adanily@berkeley.edu", "Manager"
 
  Scenario: A workshift manager edits a user's details
    Given I log in with "mfitz@berkeley.edu", "kitty"
    And I am on the manage users page
    When I click "Giorgia Willits"
    And I click "Edit Profile"
    And I fill in "Email" with "yyip@berkeley.edu"
    And I click "Update Email"
    Then I should see "yyip@berkeley.edu"
  
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

    
    