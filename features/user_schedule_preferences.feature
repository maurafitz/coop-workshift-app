@javascript
Feature: Set and Edit User Preferences for Schedule
  As a co-op member
  In order to be assigned shifts at times that I can work
  I would like to be able to set and edit my schedule preferences for the semester.

  Background:
    Given I am logged in
    And I am a member of "Cloyne"
    And the following metashifts exist:
    | category      | name                             | id | description                                   |
    | Kitchen       | Kitchen Manager                  | 1  | Refer to bylaws for manager description.      |
     
  @wip
  Scenario: A user sets their time preferences correctly
    Given I have not saved any preferences
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
    Then I should see an "Available" status "21" times
    And I should see an "Unavailable" status "34" times
    And I should see a "Not Preferred" status "45" times
    And I should see an "Unsure" status "12" times
    # When I fill in "Notes" with "I have nothing to say"
    And I click "Save"
    Then I should be on my profile page
    And I should see "Your preferences have been saved"
    And my schedule preferences should be saved
    
  @wip    
  Scenario: A user sets their time preferences incorrectly
    When I go to the set preferences page
    And I fill in "Notes" with "I have nothing to say"
    Then I press "Submit"
    Then I should see "Error, you must fill in all the boxes."
    
  # @wip
  Scenario: A user edits their time preferences
    Given I have saved the following time preferences:
    | day         | times              | availability  |
    | Monday      | 8am-6pm            | Unavailable   |
    | Monday      | 7pm-11pm           | Not Preferred |
    When I go to the edit preferences page
    Then I should see an "Unavailable" status "11" times
    And I should see a "Not Preferred" status "5" times
    # And I should see "Unavailable" in the availability box for "Monday", "8am"
    When I select the following time preferences:
    | day         | times              | availability  |
    | Monday      | 8am-6pm            | Available     |
    | Tuesday     | 3pm-3pm, 10pm-11pm | Not Preferred |
    And I click "Save"
    Then my availability for "Monday", "8am" should be "Available"
    And my availability for "Tuesday", "10pm" should be "Not Preferred"
      
