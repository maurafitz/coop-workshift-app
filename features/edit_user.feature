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