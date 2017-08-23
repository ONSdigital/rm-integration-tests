# Author: Stephen Goddard 11/05/2017
#
# Keywords Summary : This feature file contains the scenario tests for the collection exercise service endpoints - details are in the swagger spec
#                    https://github.com/ONSdigital/rm-collection-exercise-service/blob/master/API.md
#                    http://localhost:8145/swagger-ui.html#/collection45exercise45endpoint
#
# Feature: List of cases scenarios: Clean sample service DB to pre test condition
#                                   Put collection exercise by valid exerciseid
#                                   Put collection exercise by invalid exerciseid
#                                   Get collection exercise by valid surveyid
#                                   Get collection exercise by invalid surveyid
#                                   Get collection exercise by valid exerciseid
#                                   Get collection exercise by invalid exerciseid
#
# Feature Tags: @collectionExerciseSvc
#               @collectionExerciseEndpoints
#
@collectionExerciseSvc @collectionExerciseEndpoints
Feature: Runs the Collection Exercise endpoints

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


  # Endpoint Tests -----

  # PUT /collectionexercises/{exerciseId}
  # 200
  Scenario: Put request to collection exercise service for specific business survey by exercise id
    Given I make the PUT call to the collection exercise endpoint for exercise id "14fb3e68-4dca-46db-bf49-04b84e07e77c"
    When the response status should be 200
    Then the response should contain the field "sampleUnitsTotal" with an integer value of 500

  Scenario: Put request to collection exercise service for specific census survey by exercise id
    Given I make the PUT call to the collection exercise endpoint for exercise id "14fb3e68-4dca-46db-bf49-04b84e07e87c"
    When the response status should be 200
    # 0 returned as seed data/party svc does not work for Census
    Then the response should contain the field "sampleUnitsTotal" with an integer value of 0

  Scenario: Put request to collection exercise service for specific social survey by exercise id
    Given I make the PUT call to the collection exercise endpoint for exercise id "14fb3e68-4dca-46db-bf49-04b84e07e97c"
    When the response status should be 200
    # 0 returned as seed data/party svc does not work for Social
    Then the response should contain the field "sampleUnitsTotal" with an integer value of 0

  # 404 
  Scenario: Put request to collection exercise service for invalid exercise id
    Given I make the PUT call to the collection exercise endpoint for exercise id "14fb3e68-4dca-46db-bf49-04b84e07e01c"
    When the response status should be 404
    Then the response should contain the field "error.code" with value "RESOURCE_NOT_FOUND"
    And the response should contain the field "error.message" with value "Sample not found for collection exercise Id 14fb3e68-4dca-46db-bf49-04b84e07e01c"
    And the response should contain the field "error.timestamp"


  # GET /collectionexercises/survey/{surveyid}
  # 200
  Scenario: Get request to collection exercise by survey id
    Given I make the GET call to the collection exercise endpoint for survey by survey id "cb0711c3-0ac8-41d3-ae0e-567e5ea1ef87"
    And the response status should be 200
    And the response should contain a JSON array of size 1
    And one element of the JSON array must be {"id":"14fb3e68-4dca-46db-bf49-04b84e07e77c","name":"BRES_2016","scheduledExecutionDateTime":null}

  # 404
  Scenario: Get request to collection exercise by invalid survey id
    Given I make the GET call to the collection exercise endpoint for survey by survey id "87c8b602-aabd-4fc3-8676-bb875f4ce101"
    When the response status should be 404
    Then the response should contain the field "error.code" with value "RESOURCE_NOT_FOUND"
    And the response should contain the field "error.message" with value "Survey not found for survey Id 87c8b602-aabd-4fc3-8676-bb875f4ce101"
    And the response should contain the field "error.timestamp"


  # GET /collectionexercises/{exerciseid}
  # 200
  Scenario: Get request to cases for iac
    Given I make the GET call to the collection exercise endpoint for exercise by exercise id "14fb3e68-4dca-46db-bf49-04b84e07e77c"
    And the response status should be 200
    And the response should contain the field "id" with value "14fb3e68-4dca-46db-bf49-04b84e07e77c"
    And the response should contain the field "surveyId" with value "cb0711c3-0ac8-41d3-ae0e-567e5ea1ef87"
    And the response should contain the field "name" with value "BRES_2016"
    And the response should contain the field "actualExecutionDateTime" with or without a null value
    And the response should contain the field "scheduledExecutionDateTime" with a null value
    And the response should contain the field "scheduledStartDateTime"
    And the response should contain the field "actualPublishDateTime" with or without a null value
    And the response should contain the field "periodStartDateTime"
    And the response should contain the field "periodEndDateTime"
    And the response should contain the field "scheduledReturnDateTime" with a null value
    And the response should contain the field "scheduledEndDateTime"
    And the response should contain the field "executedBy" with a null value
    And the response should contain the field "state" with value "PENDING"
    And the response should contain the field "caseTypes" with one element of the JSON array must be [{"actionPlanId":"e71002ac-3575-47eb-b87f-cd9db92bf9a7","sampleUnitType":"B"}
    And the response should contain the field "caseTypes" with one element of the JSON array must be {"actionPlanId":"0009e978-0932-463b-a2a1-b45cb3ffcb2a","sampleUnitType":"BI"}]

  # 404
  Scenario: Get request to cases for iac
    Given I make the GET call to the collection exercise endpoint for exercise by exercise id "87c8b602-aabd-4fc3-8676-bb875f4ce101"
    When the response status should be 404
    Then the response should contain the field "error.code" with value "RESOURCE_NOT_FOUND"
    And the response should contain the field "error.message" with value "Collection Exercise not found for collection exercise Id 87c8b602-aabd-4fc3-8676-bb875f4ce101"
    And the response should contain the field "error.timestamp"


  # GET /info
  # 200
  Scenario: Info request to collection excerise for current verison number
    Given I make the call to the collection exercise endpoint for info
    When the response status should be 200
    Then the response should contain the field "name" with value "collectionexercisesvc"
    And the response should contain the field "version"
    And the response should contain the field "origin" with value "git@github.com:ONSdigital/rm-collection-exercise-service.git"
    And the response should contain the field "commit"
    And the response should contain the field "branch" with value "master"
    And the response should contain the field "built"
