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

  @wip
  Scenario: A user views workshifts organized by category
    Then I should see "Rank the Workshifts"
    And I should see the following: "Kitchen", "Garbage"
    And the "Kitchen" category should be collapsed
    And the "Garbage" category should be collapsed
    # When I click "Kitchen"
    # Then the "Kitchen" category should not be collapsed
    # And the "Garbage" category should be collapsed
    # When I click "Kitchen"
    # Then the "Kitchen" category should be collapsed
    
  @wip
  Scenario: A user views workshift descriptions
    # When I click "Kitchen"
    And I click "toggle description" in the row for "Dishes"
    Then I should see "Use a sponge and soap to scrub off each dish."
    # And I should not see "Lead a team in cooking meals."
    # When I click "Kitchen"
    # Then I should not see "Use a sponge and soap to scrub off each dish."
  
  # @wip
  Scenario: A user sets their workshift preferences
    Given I have not saved any preferences
    When I fill in the following rankings:
    | Kitchen         | 5       |
    | Kitchen Manager | 3       |
    | Dishes          | 2       |
    | Head Cook       | 1       |
    And I click "Save Preferences"
    Then my preferences should be saved
    
  @wip
  Scenario: A user sets invalid workshift preferences
    When I fill in "h" for the rank box for "Kitchen"
    And I fill in "6" for the rank box for "Garbage"
    And I click "Save"
    Then I should see "You must enter a number 1-5 for each preference."