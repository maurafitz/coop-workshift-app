@javascript
Feature: View and Edit User Preferences
 As a work-shift manager
 In order to schedule the semester's shifts in a fair way
 I would like to be able to view each of my members' work-shift and schedule preferences.
 
 Background:
   # A member sets up their preferences for shifts and times, and their details.
   Given I am the following user:
   | first_name | last_name | email              | password  | permissions | hour_balance | fine_balance |
   | Aziz       | Ansari    | aziz@berk.edu      | password1 | 0           | 3            | 0            |
   And I am logged in
   And I belong to "Cloyne"
   And the following metashifts exist: 
   | category      | name                             | id | description                                   |
   | Kitchen       | Kitchen Manager                  | 1  | Refer to bylaws for manager description.      |
   | Garbage       | Waste Reduction Coordinator      | 4  | Coordinate waste reduction. Go to CO.         |
   And I have saved the following time preferences:
   | day         | times              | availability  |
   | Monday      | 8am-6pm            | Available  |
   | Monday      | 7pm-11pm           | Not Preferred |
   And I have saved the following shift preferences: 
    | Kitchen         | 4       |
    | Garbage         | 2       |
   And I log out
   
   
  Scenario: A workshift manager searches and views a valid user
    Given I am logged in as a workshift manager
    And I am on the manage users page
    And I search for and select "Aziz Ansari"
    Then I should see an "Available" status "11" times
    Then I should see a "Not Preferred" status "4" times
    
    
  Scenario: A workshift manager searches for a non-existent user
    Given I am logged in as a workshift manager
    And I am on the manage users page
    And I fill in Member with "Bobo"
    Then I should not see "Bobo"


  Scenario: A user should not be able to see the manage users page
    Given I am logged in as a member
    And I go to the manage users page
    Then I should be on the home page