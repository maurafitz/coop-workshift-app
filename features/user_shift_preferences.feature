Feature: Set User Preferences for Workshifts
  As a co-op member
  In order to be assigned shifts that I like
  I would like to be able to set my shift preferences for the semester.
  
  Background:
    Given I am logged in
    And I am a member of "Cloyne"
    And the following metashifts exist:
    | category      | name                             | id | description                                   |
    | Kitchen       | Kitchen Manager                  | 1  | Refer to bylaws for manager description.      |
    | Kitchen       | Dishes                           | 2  | Use a sponge and soap to scrub off each dish. |
    | Kitchen       | Head Cook                        | 3  | Lead a team in cooking meals.                 |
    | Garbage       | Waste Reduction Coordinator      | 4  | Coordinate waste reduction. Go to CO.         |
    | Garbage       | TRC (Trash, Recycling, Compost)  | 5  | Take out trash, recycling and compost bins.   |
    
    And I am on the set preferences page

  # @wip
  Scenario: A user views workshifts organized by category
    Then I should see "Rank the Workshifts"
    And I should see the following: "Kitchen", "Garbage"
    # And the following should be hidden: "Kitchen Manager", "Dishes", "Head Cook", "Waste Reduction Coordinator", "TRC"
    When I click "Kitchen"
    And the following should be hidden: "Kitchen Manager", "Dishes", "Head Cook", "Waste Reduction Coordinator", "TRC"
    Then I should see the following: "Kitchen Manager", "Dishes", "Head Cook"
    And the following should be hidden: "Waste Reduction Coordinator", "TRC"
    And I should see "View description"
    When I click "Kitchen"
    Then the following should be hidden: "Kitchen Manager", "Dishes", "Head Cook"
    
  @wip
  Scenario: A user views workshift descriptions
    When I click "Kitchen"
    And I click "View description" in the row for "Dishes"
    Then I should see "Use a sponge and soap to scrub off each dish."
    And I should not see "Lead a team in cooking meals."
    When I click "Kitchen"
    Then I should not see "Use a sponge and soap to scrub off each dish."
  
  @wip
  Scenario: A user sets their workshift preferences
    When I fill in "5" for the rank box for "Kitchen"
    And I fill in "1" for the rank box for "Garbage"
    When I click "Kitchen"
    And I fill in "4" for the rank box for "Kitchen Manager"
    And I fill in "3" for the rank box for "Dishes"
    And I fill in "5" for the rank box for "Head Cook"
    And I click "Save"
    Then my preferences should be saved
    
  @wip
  Scenario: A user sets invalid workshift preferences
    When I fill in "h" for the rank box for "Kitchen"
    And I fill in "6" for the rank box for "Garbage"
    And I click "Save"
    Then I should see "You must enter a number 1-5 for each preference."