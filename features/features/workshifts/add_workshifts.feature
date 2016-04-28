@javascript
Feature: Workshift Manager: Add Workshifts
  As a workshift manager,
  In order to set the types of shifts that my house needs completed,
  I would like to be able to upload a CSV file with the workshift information.
    
  Background:
    Given I am logged in as a workshift manager
    And I go to the create workshifts page
  
  Scenario: an admin adds workshifts using a csv file
    When I upload "workshifts_plus_times.csv"
    And I press "Import"
    Then I should see a workshift table
    And I should see "Clean" "3" times
    And I should see "Plants" "1" times
    And I should see "Friday, 1:30PM to 4:30PM"
    And I should see "3.0"
    And I should see "You added 3 new workshifts"
    
  Scenario: an admin adds workshifts manually and adds a time
    When I fill in "Category" with "Kitchen"
    And I fill in "Name" with "Sweep"
    And I fill in "Description" with "Sweeping the kitchen floor"
    And I fill in "Hour Value" with "1.5"
    When I press "Add Workshift"
    Then I should see "You added 1 new workshifts"
    And I should see "Sweep"
    And I should see "Sweeping the kitchen floor"
    And I should see "1.5"
    When I follow "Add a time"
    Then I should see "Sweeping the kitchen floor"
    When I choose the day "Monday"
    And I choose the "start" time as "7:30" "AM"
    And I choose the "end" time as "9:30" "AM"
    And I set the length to be "1.5"
    And I press "Add Timeslot"
    Then I should be on the view workshifts page
    And I should see "Created workshift 'Sweep' on Mondays from 7:30AM to 9:30AM"
    
  Scenario: an admin tries to import no file
    When I press "Import"
    Then I should be on the create workshifts page
    And I should see "You must select a file to upload."