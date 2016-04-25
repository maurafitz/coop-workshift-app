Feature: View User Profile
  As a member of a coop,
  In order to stay on track with my workshift hours,
  I would like to view my edit balance, fine balance, shift assignment, and signoff history on one page.
  
  Background:
    Given I am the following user:
    | first_name | last_name | email           | password | permissions | hour_balance | fine_balance |
    | Giorgia    | Willits   | gw@berkeley.edu | tortoise | 0           | 18           | 100          |
    # And the following metashifts exist:
    # | category      | name              | id |
    # | Kitchen       | Dishes            | 1  |
    # | Kitchen       | Head Cook         | 2  |
    # | Garbage       | TRC               | 3  |
    # And the following shifts exist:
    # | metashift   | days      | time_blocks                              |
    # | Dishes      | M,T,W,R,F | 5am-11am, 12pm-3pm, 4pm-7pm, 8pm-10pm    |
    # | Head Cook   | M,T,W,R,F | 8am-11am, 1pm-4pm, 5pm-8pm               |
    # | TRC         | M,W,F     | 4pm-7pm                                  |
    # And I am assigned the following shifts:
    # | metashift   | days      | time_blocks                    |
    # | Dishes      | M,T,W,R,F | 5am-11am, 4pm-7pm, 8pm-10pm    |

  Scenario: A member views their profile while logged in
    Given I am logged in
    And I am on the home page
    When I follow "Profile"
    Then I should be on my profile page
    And I should see the following: "Hour Balance", "Fine Balance", "Shift Assignment", "Signoff History"
    And I should see the following: "Giorgia", "Willits", "gw@berkeley.edu", "18", "100"
    And I should see "Edit Profile"
    And I should see "Kitchen"
    And I should see "Dishes"
    And I should not see the following: "Create Users", "Create Workshifts", "Assign Workshifts", "View Weekly History"
    
  Scenario: A member edits their profile from their profile page
    Given I am logged in
    And I am on my profile page
    When I follow "Edit Profile"
    Then I should be on my edit profile page
    
  Scenario: A member tries to view their profile while not logged in
    Given I am not logged in
    And I am on the home page
    Then I should not see "Profile"