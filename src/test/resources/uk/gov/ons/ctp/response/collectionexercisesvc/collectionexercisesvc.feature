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
    Given I make the PUT call to the collection exercise endpoint for exercise id "14fb3e68-4dca-46db-bf49-04b84e07e77c"
    When the response status should be 200
    Then the response should contain the field "sampleUnitsTotal" with an integer value of 1

  Scenario: Put request to collection exercise service for specific census survey by exercise id
    Given I make the PUT call to the collection exercise endpoint for exercise id "14fb3e68-4dca-46db-bf49-04b84e07e87c"
    When the response status should be 200
    Then the response should contain the field "sampleUnitsTotal" with an integer value of 1

  Scenario: Put request to collection exercise service for specific social survey by exercise id
    Given I make the PUT call to the collection exercise endpoint for exercise id "14fb3e68-4dca-46db-bf49-04b84e07e97c"
    When the response status should be 200
    Then the response should contain the field "sampleUnitsTotal" with an integer value of 1

  # 404 
  Scenario: Put request to collection exercise service for invalid exercise id
    Given I make the PUT call to the collection exercise endpoint for exercise id "14fb3e68-4dca-46db-bf49-04b84e07e01c"
    When the response status should be 404
    Then the response should contain the field "error.code" with value "RESOURCE_NOT_FOUND"
    And the response should contain the field "error.message" with value "Sample not found for collection exercise Id 14fb3e68-4dca-46db-bf49-04b84e07e01c"
    And the response should contain the field "error.timestamp"


  # TODO Write test to confirm state change.


  # GET /collectionexercises/survey/{surveyid}
  # 200
  @cases
  Scenario: Get request to cases for iac
    Given I make the GET call to the collection exercise endpoint for survey by survey id "99f6cd6d-880c-4b36-b157-aeda409ec441"
    And the response status should be 200
    And the response should contain a JSON array of size 1
    And one element of the JSON array must be {"id":"14fb3e68-4dca-46db-bf49-04b84e07e77c","name":"CucTest_Bres","scheduledExecutionDateTime":1504220400000}


  # GET /collectionexercises/{exerciseid}
  # 200
  @cases
  Scenario: Get request to cases for iac
    Given I make the GET call to the collection exercise endpoint for exercise by exercise id "14fb3e68-4dca-46db-bf49-04b84e07e87c"
    And the response status should be 200
    And the response should contain the field "id" with value "14fb3e68-4dca-46db-bf49-04b84e07e87c"
    And the response should contain the field "surveyId" with a null value
    And the response should contain the field "name" with value "CucTest_Census"
    And the response should contain the field "actualExecutionDateTime" with a null value
    And the response should contain the field "scheduledExecutionDateTime" with a long value of 1009800000000
    And the response should contain the field "scheduledStartDateTime" with a long value of 1009800000000
    And the response should contain the field "actualPublishDateTime" with a null value
    And the response should contain the field "periodStartDateTime" with a long value of 1009800000000
    And the response should contain the field "periodEndDateTime" with a null value
    And the response should contain the field "scheduledReturnDateTime" with a null value
    And the response should contain the field "scheduledEndDateTime" with a long value of 1009800000000
    And the response should contain the field "executedBy" with a null value
    And the response should contain the field "state" with value "PENDING"
    And the response should contain the field "caseTypes" with one element of the JSON array must be []
