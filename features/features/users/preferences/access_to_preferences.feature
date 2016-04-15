Feature: Set User Access to Preferences for Schedule
  As a co-op manager
  In order to provide a way to stop users from editing their preferences
  I would like to be able to turn on and off their ability to edit

  Background:
    Given I am logged in as an admin
    
  Scenario: I take away my ability to access the form
    Given I am on my profile page
    Then I should see "Select Workshifts Preference"
    When I follow "Open/Close Workshift Preference Form" 
    Then I should see "true"
    When I follow "Open/Close Workshift Preference Form for Example"
    Then I should see "false"
    When I follow "Profile"
    Then I should not see "Select Workshifts Preference"
    
  Scenario: I open and close the form for everyone
    Given I am on my profile page
    When I follow "Open/Close Workshift Preference Form" 
    Then I should see "true"
    When I follow "Close Workshift Preference Form for Everyone"
    Then I should see "false"
    And I should not see "true"
    When I follow "Open Workshift Preference Form for Everyone"
    Then I should see "true"
    And I should not see "false"