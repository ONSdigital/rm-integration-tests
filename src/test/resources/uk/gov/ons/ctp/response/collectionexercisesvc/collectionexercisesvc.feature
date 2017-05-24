# Author: Stephen Goddard 11/05/2017
#
# Keywords Summary : This feature file contains the scenario tests for the collection exercise service endpoints - details are in the swagger spec
#                    https://github.com/ONSdigital/ swagger.yml
#
# Feature: List of cases scenarios: Clean sample service DB to pre test condition
#                                   Put collection exercise by valid exerciseid
#                                   Put collection exercise by invalid exerciseid
#
# Feature Tags: @collectionExerciseSvc
#               @collectionExerciseEndpoints
#
# Scenario Tags:
#
@collectionExerciseSvc @collectionExerciseEndpoints
Feature: Runs the Collection Exercise endpoints

  # Pre Test Sample Service Environment Set Up -----

  Scenario: Reset sample service database to pre test condition
    When for the "samplesvc" run the "samplereset.sql" postgres DB script
    Then the samplesvc database has been reset

  Scenario: Load Business example survey
    Given clean sftp folders of all previous ingestions for "business" surveys
    And the sftp exit status should be "-1"
    When for the "business" survey move the "valid" file to trigger ingestion
    And the sftp exit status should be "-1"
    And after a delay of 5 seconds
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
    When for the "collectionexercisesvc" run the "collectionexercisereset.sql" postgres DB script
    Then the collectionexercisesvc database has been reset

  Scenario: Load collection exercise seed data
    Given for the "collectionexercisesvc" run the "collectionexerciseseed.sql" postgres DB script


  # Endpoint Tests -----

  # PUT /collectionexercises/{exerciseId}
  # 200
  Scenario: Put request to collection exercise service for specific business survey by exercise id
    Given I make the PUT call to the collection exercise endpoint for exercise id "1"
    When the response status should be 200
    Then the response should contain the field "sampleUnitsTotal" with an integer value of 1

  Scenario: Put request to collection exercise service for specific census survey by exercise id
    Given I make the PUT call to the collection exercise endpoint for exercise id "2"
    When the response status should be 200
    Then the response should contain the field "sampleUnitsTotal" with an integer value of 1

  Scenario: Put request to collection exercise service for specific social survey by exercise id
    Given I make the PUT call to the collection exercise endpoint for exercise id "3"
    When the response status should be 200
    Then the response should contain the field "sampleUnitsTotal" with an integer value of 1

  # 404 
  Scenario: Put request to collection exercise service for invalid exercise id
    Given I make the PUT call to the collection exercise endpoint for exercise id "101"
    When the response status should be 404
    Then the response should contain the field "error.code" with value "RESOURCE_NOT_FOUND"
    And the response should contain the field "error.message" with value "Sample not found for collection exercise Id 101"
    And the response should contain the field "error.timestamp"


  # TODO Write test to confirm state change.