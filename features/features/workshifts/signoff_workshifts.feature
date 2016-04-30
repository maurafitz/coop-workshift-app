@javascript
Feature: Sign-off a shift
  As a member of a coop,
  In order to get credit for the shifts I work,
  I would like to get signed off online by another member.
  
  Background:
    Given the following users are members of "Cloyne":
    | first_name      | last_name     | email                     |   password     |    permissions   |
    | Eric            | Nelson        | ericn@berkeley.edu        |   bunnny       |      0           |
    | Giorgia         | Willits       | gwillits@berkeley.edu     |   tortoise     |      0           |
    | Alex            | Danily        | adanily@berkeley.edu      |   hare         |      1           |
    | Maura           | Fitz          | mfitz@berkeley.edu        |   kitty        |      2           |
  
    And the following metashifts exist:
    | category      | name                             | id |
    | Kitchen       | Kitchen Manager                  | 1  |
  
    And "Giorgia" is assigned the following workshifts:
    | start_time    | end_time     | day           | metashift_id   | id   |
    | 5:00PM        | 6:00PM       | Monday        | 1              | 72   |

    And "Giorgia" is assigned a shift today with workshift id "72"
    
  Scenario: A member signs off another member while signed in
    Given I log in with "ericn@berkeley.edu", "bunnny"
    And I am on the home page
    Then I should see the following: "Workshifter", "Notes"
    When I select "Giorgia" for "Workshifter"
    And I click "Assigned Shifts"
    Then I should see "Your Shifts"
    And I should see today's date
    And I should see "Kitchen Manager"
    When I click "Signoff Shift"
    And I should see "You have successfully signed off a shift"

  Scenario: A member signs off another member while not signed in
    Given I am on the home page
    Then I click "Save"
    Then I should see the following: "Workshifter", "Verifier", "Notes", "Password"
    When I select "Giorgia" for "Workshifter"
    And I select "Eric" for "Verifier"
    And I fill in "bunnny" for "Password"
    When I click "Signoff Shift"
    Then I should see "You have successfully signed off a shift"
    And I should not be logged in
    
  Scenario: A member enters the wrong password to sign off another member
    Given I am on the home page
    Then I click "Save"
    Then I should see the following: "Workshifter", "Verifier", "Notes", "Password"
    When I select "Giorgia" for "Workshifter"
    And I select "Eric" for "Verifier"
    And I fill in "wrong!!" for "Password"
    When I click "Signoff Shift"
    Then I should see "Verifier PW not correct. Please try again"
    And I should not be logged in
  
  Scenario: A manager signs off a member while logged in
    Given I log in with "adanily@berkeley.edu", "hare"
    And I am on the home page
    And I click "Special Shifts"
    Then I should see the following: "Special Shift", "Hours"
    And I fill in "This is a special shift" for "Special Shift"
    And I fill in "2" for "Hours"
    When I click "Signoff Shift"
    Then I should see "You have successfully signed off a shift"
    
  Scenario: Someone signs off a member for someone else's shift
    Given I log in with "adanily@berkeley.edu", "hare"
    And I am on the home page
    And I click "All Shifts"
    Then I should see the following: "All Shifts", "Person", "Hours"
    When I click "Signoff Shift"
    Then I should see "You have successfully signed off a shift"
    
  Scenario: Someone tries to sign off their own shift
    Given I log in with "gwillits@berkeley.edu", "tortoise"
    And I am on the home page
    When I select "Giorgia" for "Workshifter"
    And I click "Signoff Shift"
    Then I should see "You may not verify your own shift"
    
  Scenario: A member tries to sign off a special shift
    Given I log in with "ericn@berkeley.edu", "bunnny"
    And I am on the home page
    When I select "Giorgia" for "Workshifter"
    And I click "Special Shifts"
    And I fill in "This is a special shift" for "Special Shift"
    And I fill in "2" for "Hours"
    When I click "Signoff Shift"
    Then I should see "Only managers and admins may sign off on special shifts"
    
    
