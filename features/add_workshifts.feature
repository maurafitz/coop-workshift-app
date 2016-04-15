Feature: Adding workshifts
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
  And I should see "Friday, 1:30 PM to 4:30 PM"
  And I should see "3.0"
  And I should see "You added 3 new workshifts"
  
Scenario: an admin adds workshifts manually
  When I fill in "Category" with "Kitchen"
  And I fill in "Name" with "Sweep"
  And I fill in "Description" with "Sweeping the kitchen floor"
  And I fill in "Hour Value" with "1.5"
  When I press "Add Workshift"
  Then I should see "You added 1 new workshifts"
  And I should see "Sweep"
  And I should see "Sweeping the kitchen floor"
  And I should see "1.5"
  
Scenario: an admin tries to import no file
  When I press "Import"
  Then I should be on the create workshifts page
  And I should see "You must select a file to upload."