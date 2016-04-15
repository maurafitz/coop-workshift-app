Feature: Set User Preferences for Schedule
  As a co-op member
  In order to be assigned shifts at times that I can work
  I would like to be able to set my schedule preferences for the semester.

  Background:
    Given I am logged in as a member
    And I am a member of "Cloyne"
    And I have not saved any preferences
    
  # @wip
  Scenario: A user sets their time preferences correctly
    When I go to the set preferences page
    And I select the following time preferences:
    | day         | times              | availability  |
    | Monday      | 8am-6pm            | Unavailable   |
    | Monday      | 7pm-11pm           | Not Preferred |
    | Tuesday     | 8am-11am, 4pm-5pm  | Unavailable   |
    | Tuesday     | 12pm-2pm, 6pm-9pm  | Available     |
    | Tuesday     | 3pm-3pm, 10pm-11pm | Not Preferred |
    | Wednesday   | 8am-3pm, 8pm-11pm  | Unsure        |
    | Wednesday   | 4pm-7pm            | Available     |
    | Thursday    | 8am-11am, 4pm-5pm  | Unavailable   |
    | Thursday    | 12pm-3pm, 6pm-11pm | Available     |
    | Friday      | 8am-6pm            | Unavailable   |
    | Friday      | 7pm-11pm           | Not Preferred |
    | Saturday    | 8am-11pm           | Not Preferred |
    | Sunday      | 8am-11pm           | Not Preferred |
    
    # And I select "Available" for "avail[1,8]"
    # And I fill in my availability correctly
    # Then I should see "yes" "10" times
    # And I should see "can't" "10" times
    # And I fill in "Notes" with "I have nothing to say"
    # Then I press "Submit"
    # Then I should see "Your preferences have been set"
    
  @wip    
  Scenario: A user sets their time preferences incorrectly
    When I go to the set preferences page
    And I fill in "Notes" with "I have nothing to say"
    Then I press "Submit"
    Then I should see "Error, you must fill in all the boxes."
