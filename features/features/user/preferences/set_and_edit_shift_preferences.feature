@javascript
Feature: Set and Edit User Preferences for Workshifts
  As a co-op member
  In order to be assigned shifts that I like
  I would like to be able to set and edit my shift preferences for the semester.
  
  Background:
    Given I am logged in
    And I am a member of "Cloyne"
    And the following metashifts exist:
    | category      | name                             | id | description                                   |
    | Kitchen       | Kitchen Manager                  | 1  | Refer to bylaws for manager description.      |
    | Kitchen       | Head Cook                        | 3  | Lead a team in cooking meals.                 |
    | Garbage       | Waste Reduction Coordinator      | 4  | Coordinate waste reduction. Go to CO.         |
    | Garbage       | TRC (Trash, Recycling, Compost)  | 5  | Take out trash, recycling and compost bins.   |
    | Kitchen       | Dishes                           | 2  | Put away any clean dishes. Attack the dishes according to type, e.g. silverware, cups, plates, bowls. Use a blue sponge and dish soap to scrub off each dish. Make a stack of soaped up dishes as you go.|
    
    And I am on the set preferences page

  @wip
  Scenario: A user views workshifts organized by category
    Then I should see "Rank the Workshifts"
    And I should see the following: "Kitchen", "Garbage"
    And I should not see the following: "Kitchen Manager", "Dishes", "Head Cook", "Waste Reduction Coordinator", "TRC"
    When I click "Kitchen"
    Then I should see the following: "Kitchen Manager", "Dishes", "Head Cook"
    And I should not see the following: "Waste Reduction Coordinator", "TRC"
    And I should see the following: "Shift", "Description"
    When I click "Kitchen"
    Then I should not see the following: "Kitchen Manager", "Dishes", "Head Cook"
    
  @wip
  Scenario: A user views workshift descriptions
    When I click "Kitchen"
    Then I should see "Put away any clean dishes."
    And I should not see "Use a blue sponge"
    When I click "toggle description" 
    Then I should see "Use a blue sponge and dish soap to scrub off each dish."
    When I click "toggle description" 
    Then I should not see "Use a blue sponge and dish soap to scrub off each dish."
  
  Scenario: A user sets their workshift preferences
    Given I have not saved any preferences
    When I click "Kitchen"
    And I click "Garbage"
    And I fill in the following rankings:
    | Kitchen         | 5       |
    | Kitchen Manager | 3       |
    | Dishes          | 2       |
    | Head Cook       | 1       |
    And I click "Save"
    Then I should be on my profile page
    And I should see "Your preferences have been saved"
    And my shift preferences should be saved
    
  @wip
  Scenario: A user sets invalid workshift preferences
    Given I have not saved any preferences
    When I fill in the following rankings:
    | Kitchen         | h       |
    | Garbage         | 6       |
    Then the "Save" button should be disabled
    And I click "Save"
    Then I should be on the set preferences page
    
  @wip
  Scenario: A user edits their workshift preferences
    Given I have saved the following shift preferences:
    | Kitchen         | 4       |
    | Garbage         | 2       |
    When I go to the edit preferences page
    Then I should see the following: "4", "2" 
    When I click "Kitchen"
    And I fill in the following rankings:
    | Dishes          | 5       |
    | Kitchen Manager | 3       |
    And I click "Save"
    Then I should be on my profile page
    And I should see "Your preferences have been edited successfully"
    And my ranking for "Dishes" should be "5"
    And my ranking for "Kitchen Manager" should be "3"
    
