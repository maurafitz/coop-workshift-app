Feature: Edit User Profile
  As a member of a coop,
  In order to update my account information,
  I would like to change my password and email.
  
  Background:
    Given I am the following user:
    | first_name | last_name | email           | password | permissions | hour_balance | fine_balance |
    | Ryan       | Riddle    | ry@berkeley.edu | password | 0           | 100          | 0            |
    And I am logged in
    And I am on my edit profile page

  Scenario: A member changes their email
    When I fill in "Email" with "ryanriddle@berkeley.edu"
    And I click "Update Email"
    Then I should be on my profile page
    Then I should see "ryanriddle@berkeley.edu"
    And I should not see "ry@berkeley.edu"
    And I should see "Your email has been updated."
    
  Scenario: A member changes their password correctly
    # When I fill in "Current Password" with "password"
    And I fill in "New Password" with "Ryan1"
    And I fill in "New Password Confirmation" with "Ryan1"
    When I click "Update Password"
    Then I should be on my profile page
    And I should see "Your password has been updated."
    
  Scenario: A member changes their password without authorization
    # When I fill in "Current Password" with "invalid"
    And I fill in "New Password" with "Ryan1"
    And I fill in "New Password Confirmation" with "Ryan1"
    When I click "Update Password"
    # Then I should be on my edit profile page
    # And I should see "Invalid password."
    
  Scenario: A member changes their password incorrectly  
    # When I fill in "Current Password" with "password"
    And I fill in "New Password" with "Ryan1"
    And I fill in "New Password Confirmation" with "Ryan2"
    When I click "Update Password"
    # Then I should be on my edit profile page
    # And I should see "New passwords don't match."