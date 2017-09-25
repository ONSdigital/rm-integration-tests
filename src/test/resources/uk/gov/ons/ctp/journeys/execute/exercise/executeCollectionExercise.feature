# Author: Stephen Goddard 25/05/2017
#
# Keywords Summary: This feature confirms that the collection exercise service will publish/execute the collection exercise. The journey is specified in:
#                   https://collaborate2.ons.gov.uk/confluence/pages/viewpage.action?pageId=5190519
#                   https://collaborate2.ons.gov.uk/confluence/display/SDC/Test+Scenario+2+-+Execute+Collection+Exercise
#
# Feature: List of publish collection exercise scenarios: pre test DB clean of sample service
#                                                         load business sample
#                                                         load census sample
#                                                         load social sample
#                                                         pre test DBclean of collection exercise service
#                                                         pre test DBclean of case service
#                                                         pre test DBclean of action service
#                                                         test collect sample units (Journey steps: 2.1, 2.2, 2.3)
#                                                         test create cases (Journey steps: 2.4, 2.5, 2.8)
#                                                         test publish collection (Journey steps: 2.6, 2.7)
#                                                         test report for collection excercise (Test scenario PO2.05, Jouney step: 2.9)
#
# NOTE: Report not developed so not tested (Journey steps: 2.9)
#
# Feature Tags: @excuteExercise
#
@executeExercise
Feature: Tests the publish collection exercise

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

  Scenario: Load Census example survey
    Given clean sftp folders of all previous ingestions for "CTP" surveys
    And the sftp exit status should be "-1"
    When for the "CTP" survey move the "valid" file to trigger ingestion
    And the sftp exit status should be "-1"
    And after a delay of 50 seconds
    Then for the "CTP" survey confirm processed file "CTP-survey-full*.xml.processed" is found
    And the sftp exit status should be "-1"

  Scenario: Load Social example survey
    Given clean sftp folders of all previous ingestions for "SSD" surveys
    And the sftp exit status should be "-1"
    When for the "SSD" survey move the "valid" file to trigger ingestion
    And the sftp exit status should be "-1"
    And after a delay of 50 seconds
    Then for the "SSD" survey confirm processed file "SSD-survey-full*.xml.processed" is found
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


  # Journey Test

  # Execute Collection Exercise -----

  Scenario: Test execute from collection exercise by put request for specific business survey by exercise id (Journey steps: 2.1, 2.2, 2.3)
    Given I make the PUT call to the collection exercise endpoint for exercise id "14fb3e68-4dca-46db-bf49-04b84e07e77c"
    When the response status should be 200
    Then the response should contain the field "sampleUnitsTotal" with an integer value of 500

  Scenario: Test execute from collection exercise by put request for specific census survey by exercise id (Journey steps: 2.1, 2.2, 2.3)
    Given I make the PUT call to the collection exercise endpoint for exercise id "14fb3e68-4dca-46db-bf49-04b84e07e87c"
    When the response status should be 200
    # 0 returned as seed data/party svc does not work for Census
    Then the response should contain the field "sampleUnitsTotal" with an integer value of 0

  Scenario: Test execute from collection exercise by put request for specific social survey by exercise id (Journey steps: 2.1, 2.2, 2.3)
    Given I make the PUT call to the collection exercise endpoint for exercise id "14fb3e68-4dca-46db-bf49-04b84e07e97c"
    When the response status should be 200
    # 0 returned as seed data/party svc does not work for Social
    Then the response should contain the field "sampleUnitsTotal" with an integer value of 0

  Scenario: Test casesvc case for business survey DB state (Journey steps: 2.4, 2.5, 2.8)
    Given after a delay of 280 seconds
    When check "casesvc.case" records in DB equal 500 for "statefk = 'ACTIONABLE'"
    Then check "casesvc.case" distinct records in DB equal 500 for "iac" where "statefk = 'ACTIONABLE'"
    
  Scenario: Test actionsvc case for business survey DB state for actionplan 1 (Journey steps: 2.6, 2.7)
    Given after a delay of 60 seconds
    When check "action.case" records in DB equal 498 for "actionplanfk = 1"
    And check "action.case" records in DB equal 2 for "actionplanfk = 2"
    Then check "casesvc.caseevent" records in DB equal 500 for "description = 'Case created when Initial creation of case'"

  # Report (PO2.05, Jouney step: 2.9)

  Scenario: Test ui report to confirm the right number and type of cases have been created (Test scenario PO2.05, Jouney step: 2.9)
    Given the "test" user has logged in using "chromehead"
    When the user navigates to the reports page and selects "case" reports
    When the user goes to view the most recent report
    And  checks values of column number 2 against value "B" and should appear 498 times
    And  checks values of column number 2 against value "BI" and should appear 2 times
    And  checks values of column number 4 against value "1" and should appear 500 times
#    Then the user logs out
