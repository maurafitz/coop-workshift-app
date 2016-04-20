Feature: Workshift Manager: Assign Workshifts
  As a work-shift manager
  In order for members to know when, where, and how they need to work,
  I would like to be able to assign members work-shifts for the entire semester.
  
  Background:
    Given I am logged in as an admin
    And I am a member of "Cloyne"
    And the following metashifts exist:
    | category      | name              | id |
    | Kitchen       | Dishes            | 1  |
    | Kitchen       | Head Cook         | 2  |
    | Garbage       | TRC               | 3  |
    And the following shifts exist:
    | time_blocks                              | metashift   | days      |
    | 5am-11am, 12pm-3pm, 4pm-7pm, 8pm-10pm    | Dishes      | M,T,W,R,F |
    | 8am-11am, 1pm-4pm, 5pm-8pm               | Head Cook   | M,T,W,R,F |
    | 4pm-7pm                                  | TRC         | M,W,F     |
    And the following users are members of "Cloyne":
    | first_name      | last_name     | email                     |   password     |    permissions   |
    | Eric            | Nelson        | ericn@berkeley.edu        |   bunnny       |      0           |
    | Giorgia         | Willits       | gwillits@berkeley.edu     |   tortoise     |      0           |
    And I am on the assign workshifts page
    
  Scenario: An admin assigns workshifts to a member 
    Then I should see "38" workshift slots
    When I fill in "Giorgia Willits" for "Dishes, Monday, 5am-11am"
    And I fill in "Eric Nelson" for "Head Cook, Tuesday, 8am-11am"
    And I click "Save"
    Then "Giorgia" should be assigned the shift "Dishes, Monday, 5am-11am"
    And "Eric" should be assigned the shift "Head Cook, Tuesday, 8am-11am"
    And no one should be assigned to the shift "Dishes, Tuesday, 5am-11am"
    
  Scenario: An admin tries to assign a workshift incorrectly
    When I fill in "Alex Danilychev" for "Dishes, Monday, 5am-11am"
    And I fill in "Giorgia Willits" for "TRC, Wednesday, 4pm-7pm"
    And I click "Save"
    Then I should be on the assign workshifts page
    And I should see "Alex Danilychev is not a member of Cloyne."
    And no one should be assigned to the shift "Dishes, Monday, 5am-11am"
    And no one should be assigned to the shift "TRC, Wednesday, 4pm-7pm"
    
    
    
    
    
    
    
  