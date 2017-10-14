# Author: Stephen Goddard 09/10/2017
#
# Keywords Summary : This feature file contains the scenario tests for the response operations ui
#
# Feature: List of scenarios: Reset sample service database to pre test condition
#                             Load Business example survey
#                             Reset collection exercise service database to pre test condition
#                             Reset case service database to pre test condition
#                             Reset action service database to pre test condition
#                             Execute from collection exercise by put request for specific business survey by exercise id (Journey steps: 2.1, 2.2, 2.3)
#                             Test casesvc case for business survey DB state (Journey steps: 2.4, 2.5, 2.8)
#                             Test actionsvc case for business survey DB state for actionplan 1 (Journey steps: 2.6, 2.7)
#                             Test action creation by post request to create actions for specified action plan (Journey steps: 3.1, 3.2, 3.3, 3.4, 3.5, 3.7)
#                             Print file generation and confirm contents (Journey steps: 3.6, 3.8)
#                             Test reporting unit page displays correct events and actions
#                             Test CTPA-1591 and CTPA-1617 pagination error
#
# Feature Tags: @ui
#
@ui
Feature: Tests for response operations UI 

  # Pre Test Set Up

  # Pre Test Sample Service Environment Set Up -----

  Scenario: Reset sample service database to pre test condition
    When for the "samplesvc" run the "samplereset.sql" postgres DB script
    Then the samplesvc database has been reset

  Scenario: Load Business example survey
    Given clean sftp folders of all previous ingestions for "BSD" surveys
    And the sftp exit status should be "-1"
    When for the "BSD" survey move the "valid" file to trigger ingestion
    And the sftp exit status should be "-1"
    And after a delay of 50 seconds
    Then for the "BSD" survey confirm processed file "BSD-survey-full*.xml.processed" is found
    And the sftp exit status should be "-1"


  # Pre Test Collection Exercise Service Environment Set Up -----

  Scenario: Reset collection exercise service database to pre test condition
    Given for the "collectionexercisesvc" run the "collectionexercisereset.sql" postgres DB script
    When the collectionexercisesvc database has been reset


  # Pre Test Case Service Environment Set Up -----

  Scenario: Reset case service database to pre test condition
    When for the "casesvc" run the "casereset.sql" postgres DB script
    Then the casesvc database has been reset


  # Pre Test Action Service Environment Set Up -----

  Scenario: Reset action service database to pre test condition
    When for the "actionsvc" run the "actionreset.sql" postgres DB script
    Then the actionsvc database has been reset


  # Execute Collection Exercise -----

  Scenario: Test execute from collection exercise by put request for specific business survey by exercise id (Journey steps: 2.1, 2.2, 2.3)
    Given I make the PUT call to the collection exercise endpoint for exercise id "14fb3e68-4dca-46db-bf49-04b84e07e77c"
    When the response status should be 200
    Then the response should contain the field "sampleUnitsTotal" with an integer value of 500

  Scenario: Test casesvc case for business survey DB state (Journey steps: 2.4, 2.5, 2.8)
    Given after a delay of 380 seconds
    When check "casesvc.case" records in DB equal 500 for "statefk = 'ACTIONABLE'"
    Then check "casesvc.case" distinct records in DB equal 500 for "iac" where "statefk = 'ACTIONABLE'"
    
  Scenario: Test actionsvc case for business survey DB state for actionplan 1 (Journey steps: 2.6, 2.7)
    Given after a delay of 60 seconds
    When check "action.case" records in DB equal 497 for "actionplanfk = 1"
    And check "action.case" records in DB equal 3 for "actionplanfk = 2"
    Then check "casesvc.caseevent" records in DB equal 500 for "description = 'Case created when Initial creation of case'"


  # Send Enrolment Letters -----

  Scenario: Test action creation by post request to create actions for specified action plan (Journey steps: 3.1, 3.2, 3.3, 3.4, 3.5, 3.7)
    Given the case start date is adjusted to trigger action plan
      | actionplanfk  | actionrulepk | actiontypefk | total |
      | 1             | 1            | 1            | 497   |
    When after a delay of 90 seconds
    Then check "action.action" records in DB
      | actionplanfk  | actionrulepk | actiontypefk | statefk   | total |
      | 1             | 1            | 1            | COMPLETED | 497   |
    And check "casesvc.caseevent" records in DB equal 497 for "description = 'Enrolment Invitation Letter'"

  Scenario: Test print file generation and confirm contents (Journey steps: 3.6, 3.8)
    Given after a delay of 90 seconds
    When get the contents of the print files where the filename begins "BSNOT" for "BSD"
    And the sftp exit status should be "-1"
    Then each line should contain an iac
    And the contents should contain ":null:null"
    And the contents should contain 497 lines


  # UI Tests -----

  Scenario: Test reporting unit page displays correct events and actions
    Given the "test" user has logged in using "chrome"
    When the user navigtes to the reporting unit page using "49900000021"
    Then the RU reference is "49900000021"
    And the Name is "ENTNAME1_COMPANY21"
    And the Trading Name is "RUNAME1_COMPANY21"
    Then the event entry should be "Case Created"
    And the event entry should be "Case created when Initial creation of case"
    And the event entry should be "Action Created"
    And the event entry should be "Enrolment Invitation Letter"
    Then the action entry should be "BSNOT"
    And the action entry should be "Completed"
    Then the user logs out

  Scenario: Test CTPA-1591 and CTPA-1617 pagination error
    Given I make the POST call to the caseservice cases events 20 times for sampleunit "49900000021"
    When the "test" user has logged in using "chrome"
    Then the user navigtes to the reporting unit page using "49900000021"
    Then the RU reference is "49900000021"
    And the Name is "ENTNAME1_COMPANY21"
    And the Trading Name is "RUNAME1_COMPANY21"
    And the event entry should be "Action Completed"
    And the event entry should be "Created by cucumber test"
    Then use pagination to see more events
    And the event entry should be "Case Created"
    And the event entry should be "Case created when Initial creation of case"
    Then the user logs out
