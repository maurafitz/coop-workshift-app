Feature: Editiing User Profile
  As a member of a coop,
  In order to update my account information,
  I would like to change my password and email
  
  Background:
    Given I am the following user:
    | first_name | last_name | email           | password | permissions | hour_balance | fine_balance |
    | Ryan       | Riddle    | ry@berkeley.edu | password | 0           | 100          | 0            |

  Scenario: A member changes their email
    Given I am logged in
    And I am on the home page
    When I follow "Profile"
    Then I should be on my profile page
    Then I should see the following: "ry@berkeley.edu"
    And I should see "Edit Profile"
    When I follow "Edit Profile"
    Then I should be on my edit profile page
    When I fill in "Email" with "ryanriddle@berkeley.edu"
    When I click "Update Email"
    Then I should be on my profile page
    Then I should see the following: "ryanriddle@berkeley.edu"
    And I should see "Email has been updated."
    
  Scenario: A member changes their password correctly
    Given I am logged in
    And I am on the home page
    When I follow "Profile"
    Then I should be on my profile page
    And I should see "Edit Profile"
    When I follow "Edit Profile"
    Then I should be on my edit profile page
    When I fill in "New Password" with "Ryan1"
    And I fill in "New Password Confirmation" with "Ryan1"
    When I click "Update Password"
    Then I should be on my profile page
    And I should see "Password has been updated."
    
  Scenario: A member changes their password wrong
    Given I am logged in
    And I am on the home page
    When I follow "Profile"
    Then I should be on my profile page
    And I should see "Edit Profile"
    When I follow "Edit Profile"
    Then I should be on my edit profile page
    When I fill in "New Password" with "Ryan1"
    And I fill in "New Password Confirmation" with "Ryan2"
    When I click "Update Password"
    Then I should be on my profile page
    And I should see "Passwords did not match."