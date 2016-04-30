@javascript
Feature: View User Preferences
 As a work-shift manager
 In order to schedule the semester's shifts in a fair way
 I would like to be able to view each of my members' work-shift and schedule preferences.
 
 Background:
    Given the following users are members of "Cloyne":
    | first_name      | last_name     | email                     |   password     |    permissions   |
    | Eric            | Nelson        | ericn@berkeley.edu        |   bunnny       |      0           |
    | Giorgia         | Willits       | gwillits@berkeley.edu     |   tortoise     |      0           |
    | Alex            | Danily        | adanily@berkeley.edu      |   hare         |      1           |
    | Maura           | Fitz          | mfitz@berkeley.edu        |   kitty        |      2           |
   And the following metashifts exist: 
   | category      | name                             | id | description                                   |
   | Kitchen       | Kitchen Manager                  | 1  | Refer to bylaws for manager description.      |
   | Garbage       | Waste Reduction Coordinator      | 4  | Coordinate waste reduction. Go to CO.         |
   And I log in with "gwillits@berkeley.edu", "tortoise"
   And I have saved the following time preferences:
   | day         | times              | availability  |
   | Monday      | 8am-6pm            | Available  |
   | Monday      | 7pm-11pm           | Not Preferred |
   And I have saved the following shift preferences: 
    | Kitchen         | 4       |
    | Garbage         | 2       |
   And I log out
   
  Scenario: A workshift manager searches and views a valid user
    Given I log in with "mfitz@berkeley.edu", "kitty"
    And I am on my profile page
    When I click "View & Edit Users"
    Then I should be on the manage users page
    And I should see the following: "Eric Nelson", "Giorgia Willits", "Alex Danily", "Maura Fitz"
    When I click "Giorgia Willits"
    Then I should see an "Available" status "15" times
    Then I should see a "Not Preferred" status "5" times
    And I should see the following: "Kitchen", "4", "Garbage", "2"
    
  @wip
  Scenario: A workshift manager searches for a non-existent user
    Given I log in with "mfitz@berkeley.edu", "kitty"
    And I am on the manage users page
    And I search for "Bobo"
    Then I should not see "Bobo"

  Scenario: A user should not be able to see the manage users page
    Given I log in with "ericn@berkeley.edu", "bunnny"
    And I go to the manage users page
    Then I should be on the home page