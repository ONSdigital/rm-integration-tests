# Author: Stephen Goddard 25/05/2017
#
# Keywords Summary: This feature confirms that the collection exercise service will publish the collection exercise. The journey is specified in:
#                   https://collaborate2.ons.gov.uk/confluence/pages/viewpage.action?pageId=5190519
#                   https://collaborate2.ons.gov.uk/confluence/pages/viewpage.action?pageId=5385665
#
# Feature: List of publish collection exercise scenarios: pre test DB clean of sample service
#                                                         load business sample
#                                                         load census sample
#                                                         load social sample
#                                                         pre test DBclean of collection exercise service
#                                                         pre test DBclean of case service
#                                                         pre test DBclean of action service
#                                                         test collect sample units (Journey steps: 2.1)
#                                                         test create cases (Journey steps: 2.2, 2.3)
#                                                         test assign action plan (Journey steps: 2.4)
#                                                         test publish collection (Journey steps: 2.5)
#
# Feature Tags: @publishExercise
#
@publishExercise
Feature: Tests the publish collection exercise

  # Pre Test Set Up

  # Pre Test Sample Service Environment Set Up -----

  Scenario: Reset sample service database to pre test condition
    When for the "samplesvc" run the "samplereset.sql" postgres DB script
    Then the samplesvc database has been reset

  Scenario: Load Business example survey
    Given clean sftp folders of all previous ingestions for "business" surveys
    And the sftp exit status should be "-1"
    When for the "business" survey move the "valid" file to trigger ingestion
    And the sftp exit status should be "-1"
    And after a delay of 30 seconds
    Then for the "business" survey confirm processed file "business-survey-full*.xml.processed" is found
    And the sftp exit status should be "-1"

  Scenario: Load Census example survey
    Given clean sftp folders of all previous ingestions for "census" surveys
    And the sftp exit status should be "-1"
    When for the "census" survey move the "valid" file to trigger ingestion
    And the sftp exit status should be "-1"
    And after a delay of 5 seconds
    Then for the "census" survey confirm processed file "census-survey-full*.xml.processed" is found
    And the sftp exit status should be "-1"

  Scenario: Load Social example survey
    Given clean sftp folders of all previous ingestions for "social" surveys
    And the sftp exit status should be "-1"
    When for the "social" survey move the "valid" file to trigger ingestion
    And the sftp exit status should be "-1"
    And after a delay of 5 seconds
    Then for the "social" survey confirm processed file "social-survey-full*.xml.processed" is found
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

  # Publish Collection Exercise -----

  Scenario: Test publish from collection exercise by put request for specific business survey by exercise id (Journey steps: 2.1, 2.2)
    Given I make the PUT call to the collection exercise endpoint for exercise id "14fb3e68-4dca-46db-bf49-04b84e07e77c"
    When the response status should be 200
    Then the response should contain the field "sampleUnitsTotal" with an integer value of 500

  Scenario: Test publish from collection exercise by put request for specific census survey by exercise id (Journey steps: 2.1, 2.2)
    Given I make the PUT call to the collection exercise endpoint for exercise id "14fb3e68-4dca-46db-bf49-04b84e07e87c"
    When the response status should be 200
    Then the response should contain the field "sampleUnitsTotal" with an integer value of 1

  Scenario: Test publish from collection exercise by put request for specific social survey by exercise id (Journey steps: 2.1, 2.2)
    Given I make the PUT call to the collection exercise endpoint for exercise id "14fb3e68-4dca-46db-bf49-04b84e07e97c"
    When the response status should be 200
    Then the response should contain the field "sampleUnitsTotal" with an integer value of 1

  Scenario: Test casesvc case for business survey DB state (Journey steps: 2.3)
    Given after a delay of 180 seconds
    When check "casesvc.case" records in DB equal 500 for "state = 'ACTIONABLE'"
    Then check "casesvc.case" distinct records in DB equal 500 for "iac" where "state = 'ACTIONABLE'"
    
  Scenario: Test actionsvc case for business survey DB state for actionplan 1 (Journey steps: 2.4)
    Given after a delay of 60 seconds
    When check "action.case" records in DB equal 500 for "actionplanfk = 1"
