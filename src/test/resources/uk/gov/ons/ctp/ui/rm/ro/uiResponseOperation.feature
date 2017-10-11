# Author: Stephen Goddard 17/08/2017
#
# Keywords Summary : This feature file contains the scenario tests for the response operations ui
#
# Feature: List of scenarios: Test reporting unit page displays correct events and actions
#
# Feature Tags: @ui
#
@ui
Feature: Tests for response operations UI 

  # UI Tests -----

  Scenario: Test reporting unit page displays correct events and actions
    Given the "test" user has logged in using "chrome"
    When the user navigtes to the reporting unit page using "49900000021"
    Then the RU reference is "49900000021"
    And the Name is "ENTNAME1_COMPANY21"
    And the Trading Name is "RUNAME1_COMPANY21"
    Then the event entry should be "Case Created"
    And the event entry should be "Enrolment Invitation Letter"
    And the event entry should be "Action Created"
    And the event entry should be "Case created when Initial creation of case"
    Then the action entry should be "BSNOT"
    And the action entry should be "Completed"
    Then the user logs out
