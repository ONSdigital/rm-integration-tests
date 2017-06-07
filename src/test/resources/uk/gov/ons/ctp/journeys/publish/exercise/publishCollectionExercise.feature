# Author: Stephen Goddard 25/05/2017
#
# Keywords Summary: This feature confirms that the collection exercise service will publish the collection exercise. The journey is specified in:
#                   https://collaborate2.ons.gov.uk/confluence/pages/viewpage.action?pageId=5190519
#
# Feature: List of publish collection exercise scenarios: pre test DB clean of sample service
#                                                         load business sample
#                                                         load census sample
#                                                         load social sample
#                                                         pre test DBclean of collection exercise service
#                                                         load collection exercise seed data
#                                                  test collect sample units (Journey steps: 2.1)
#                                                  test create cases (Journey steps: 2.2, 2.3)
#                                                  test assign action plan (Journey steps: 2.4)
#                                                  test publish collection (Journey steps: 2.5)
#
# Feature Tags: @publishExercise
#
# Scenario Tags: @---
#
@publishExercise
Feature: Tests the publish collection exercise

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


  # Publish Collection Exercise -----

  Scenario: Put request to collection exercise service for specific business survey by exercise id 2.1, 2.2
    Given I make the PUT call to the collection exercise endpoint for exercise id "14fb3e68-4dca-46db-bf49-04b84e07e77c"
    When the response status should be 200
    Then the response should contain the field "sampleUnitsTotal" with an integer value of 500

  Scenario: Put request to collection exercise service for specific census survey by exercise id 2.1, 2.2
    Given I make the PUT call to the collection exercise endpoint for exercise id "14fb3e68-4dca-46db-bf49-04b84e07e87c"
    When the response status should be 200
    Then the response should contain the field "sampleUnitsTotal" with an integer value of 1

  Scenario: Put request to collection exercise service for specific social survey by exercise id 2.1, 2.2
    Given I make the PUT call to the collection exercise endpoint for exercise id "14fb3e68-4dca-46db-bf49-04b84e07e97c"
    When the response status should be 200
    Then the response should contain the field "sampleUnitsTotal" with an integer value of 1


  # Get check cases 2.3
  Scenario: Test case DB state (Journey steps: 1.5)
    When check "casesvc.case" records in DB equal 0 for "state = 'ACTIONABLE'"
    
  Scenario: Test case DB state (Journey steps: 1.5)
    When check "action.case" records in DB equal 0 for "actionplanfk = 1"
    When check "action.action" records in DB equal 0 for "statefk = 'PENDING'"

  # Check action plan 2.4
  
  # Publish complete 2.5