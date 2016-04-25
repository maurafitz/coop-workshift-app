@wip
Feature: Sign-off a shift
  As a member of a coop,
  In order to get credit for the shifts I work,
  I would like to get signed off online by another member.
  
  Background:
    Given the following users exist:
    | first_name      | last_name     | email                     |   password     |    permissions   |
    | Eric            | Nelson        | ericn@berkeley.edu        |   bunnny       |      0           |
    | Giorgia         | Willits       | gwillits@berkeley.edu     |   tortoise     |      0           |
    | Alex            | Danily        | adanily@berkeley.edu      |   hare         |      1           |
    | Maura           | Fitz          | mfitz@berkeley.edu        |   kitty        |      2           |
  
    And the following metashifts exist:
    | category      | name                             | id |
    | Kitchen       | Kitchen Manager                  | 1  |
    | Kitchen       | Dishes                           | 2  |
    | Kitchen       | Head Cook                        | 3  |
    | Garbage       | Waste Reduction Coordinator      | 4  |
    | Garbage       | TRC (Trash, Recycling, Compost)  | 5  |
  
    And "Giorgia" is assigned the following workshifts:
    | start_time    | end_time     | day           | metashift_id   |
    | 5:00PM        | 6:00PM       | Monday        | 1              |
    | 11:00AM       | 1:00PM       | Monday        | 3              |
    | 2:00PM        | 5:00PM       | Tuesday       | 5              |
    
  @wip
  Scenario: A member signs off another member while signed in
    Given I am logged in as "Eric"
    And I am on the home page
    Then I should see the following: "Workshifter", "Notes"
    And I should not see the following: "Verifier", "Password", "Special Shift"
    When I select "Giorgia" for "Workshifter"
    Then I should see "Giorgia's shifts"
    And I should see the following: "March 5, 2016", "Kitchen Manager", "March 6, 2016", "Head Cook", "March 8, 2016", "TRC"
    When I select "Head Cook" for "Giorgia's shifts"
    Then I should see the following: "Hours", "2"
    When I click "Sign off!"
    Then Giorgia's shift for "Head Cook" on "March 6, 2016" should be completed
    
  @wip
  Scenario: A member signs off another member while not signed in
    Given I am on the home page
    Then I should see the following: "Workshifter", "Verifier", "Notes", "Password"
    And I should not see "Special Shift"
    When I select "Giorgia" for "Workshifter"
    And I select "Head Cook" for "Giorgia's shifts"
    And I select "Eric" for "Verifier"
    And I fill in "bunnny" for "Password"
    And I click "Sign off!"
    Then Giorgia's shift for "Head Cook" on "March 6, 2016" should be completed
    And I should not be logged in
    
  @wip
  Scenario: A member enters the wrong password to sign off another member
    Given I am on the home page
    When I select "Giorgia" for "Workshifter"
    And I select "Head Cook" for "Giorgia's shifts"
    And I select "Eric" for "Verifier"
    And I fill in "rabbit" for "Password"
    And I click "Sign off!"
    Then Giorgia's shift for "Head Cook" on "March 6, 2016" should not be completed

  @wip
  Scenario: A manager signs off a member while logged in
    Given "Alex" is logged in
    And I am on the home page
    Then I should see the following: "Workshifter", "Notes", "Special Shift", "Recent online signoffs", "View Workshifts and Descriptions"
    
  @wip
  Scenario: A workshift manager signs off a member while logged in
    Given "Maura" is logged in
    And I am on the home page
    Then I should see the following: "Workshifter", "Notes", "Special Shift", "Recent online signoffs", "View Workshifts and Descriptions"
