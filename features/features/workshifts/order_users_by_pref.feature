@wip
Feature: Workshift Manager: View Member Availability and Preference for Workshift
  As a workshift manager,
  In order to decide who I should assign to each workshift,
  I would like to see members ordered by availability and preference to work a workshift.
  
  Background:
    Given I am logged in as an admin
    And I am a member of "Cloyne"
    And the following metashifts exist:
    | category      | name              | id |
    | Kitchen       | Dishes            | 1  |
    | Kitchen       | Head Cook         | 2  |
    | Garbage       | TRC               | 3  |
    And the following shifts exist:
    | metashift | days      | time_blocks                              | 
    | Dishes    | M,T,W,R,F | 5am-11am, 12pm-3pm, 4pm-7pm, 8pm-10pm    |
    | Head Cook | M,T,W,R,F | 8am-11am, 1pm-4pm, 5pm-8pm               |
    | TRC       | M,W,F     | 4pm-7pm                                  |
    And the following users are members of "Cloyne":
    | first_name      | last_name     | email                     |   password     |    permissions   |
    | Eric            | Nelson        | ericn@berkeley.edu        |   bunnny       |      0           |
    | Giorgia         | Willits       | gwillits@berkeley.edu     |   tortoise     |      0           |
    And "Giorgia" has set their preferences as:
    | metashift | rating |
    | Dishes    |   5    |
    | Head Cook |   4    |
    | TRC       |   1    |
    And "Eric" has set their preferences as:
    | metashift | rating |
    | Dishes    |   2    |
    | TRC       |   4    |
    And "Giorgia" has set the following availability:
    | day         | times              | availability  |
    | Monday      | 8am-11pm           | Available     |
    | Tuesday     | 8am-11pm           | Unavailable   |
    | Wednesday   | 8am-11pm           | Not Preferred |
    | Thursday    | 8am-11pm           | Unavailable   |
    And "Eric" has set the following availability:
    | day         | times              | availability  |
    | Monday      | 8am-11pm           | Available     |
    | Tuesday     | 8am-11pm           | Available     |
    | Wednesday   | 8am-11pm           | Available     |
    | Thursday    | 8am-11pm           | Unavailable   |
    And I am on the assign workshifts page
    
  Scenario: An admin views users ordered by their preference to work the workshift
    When I select the shift: "Dishes, Monday, 12pm-3pm"
    And I click "Preference"
    Then I should see "Giorgia" before "Eric"
    When I select the shift: "TRC, Monday, 4pm-7pm"
    Then I should see "Eric" before "Giorgia"
    When I select the shift: "Head Cook, Monday, 8am-11am"
    Then I should see "Giorgia" before "Eric"
  
  Scenario: An admin views users ordered by their availability to work the workshift
    When I select the shift: "Dishes, Monday, 12pm-3pm"
    And I click "Availability"
    Then I should see the following: "Giorgia", "Eric"
    When I select the shift: "Dishes, Tuesday, 8am-11am"
    Then I should see "Eric"
    And I should not see "Giorgia"
    When I select the shift: "Dishes, Wednesday, 8am-11am"
    Then I should see "Eric" before "Giorgia"
    
  Scenario: An admin tries to order by availability when no one is available
    When I select the shift: "Dishes, Thursday, 8am-11am"
    And I click "Availability"
    Then I should see "No one is available to work this workshift."
    
    
    