# Author: Stephen Goddard 19/05/2017
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
@caseSvc
Feature: Runs the case creation

  # Pre Test Sample Service Environment Set Up -----

  Scenario: Reset sample service database to pre test condition
    When for the "samplesvc" run the "samplereset.sql" postgres DB script
    Then the samplesvc database has been reset

  Scenario: Load Business example survey
    Given clean sftp folders of all previous ingestions for "business" surveys
    And the sftp exit status should be "-1"
    When for the "business" survey move the "valid" file to trigger ingestion
    And the sftp exit status should be "-1"
    And after a delay of 10 seconds
    Then for the "business" survey confirm processed file "business-survey-full*.xml.processed" is found
    And the sftp exit status should be "-1"

  Scenario: Load Census example survey
    Given clean sftp folders of all previous ingestions for "census" surveys
    And the sftp exit status should be "-1"
    When for the "census" survey move the "valid" file to trigger ingestion
    And the sftp exit status should be "-1"
    And after a delay of 10 seconds
    Then for the "census" survey confirm processed file "census-survey-full*.xml.processed" is found
    And the sftp exit status should be "-1"

  Scenario: Load Social example survey
    Given clean sftp folders of all previous ingestions for "social" surveys
    And the sftp exit status should be "-1"
    When for the "social" survey move the "valid" file to trigger ingestion
    And the sftp exit status should be "-1"
    And after a delay of 10 seconds
    Then for the "social" survey confirm processed file "social-survey-full*.xml.processed" is found
    And the sftp exit status should be "-1"


  # Pre Test Collection Exercise Service Environment Set Up -----

  Scenario: Reset collection exercise service database to pre test condition
    Given for the "collectionexercisesvc" run the "collectionexercisereset.sql" postgres DB script
    When the collectionexercisesvc database has been reset

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


  # Pre Test Case Service Environment Set Up -----

  Scenario: Reset collection exercise service database to pre test condition
    When for the "casesvc" run the "casereset.sql" postgres DB script
    Then the casesvc database has been reset


  # Endpoint Tests -----

  # GET /cases/{caseId}
  # 200
  @cases
  Scenario: Get request to cases for specific case id
    When I make the GET call to the caseservice cases endpoint for case "2"
    Then the response status should be 200
    And the response should contain the field "caseId" with an integer value of 2
    And the response should contain the field "caseGroupId" with an integer value of 2
    And the response should contain the field "caseRef" with value "1000000000000002"
    And the response should contain the field "state" with value "ACTIONABLE"
    And the response should contain the field "caseTypeId" with an integer value of 17
    And the response should contain the field "actionPlanMappingId" with an integer value of 17
    And the response should contain the field "createdDateTime"
    And the response should contain the field "createdBy" with value "SYSTEM"
    And the response should contain the field "iac"
    And the response should contain the field "responses" with one element of the JSON array must be []
    And the response should contain the field "contact" with a null value

  # 404
  @cases
  Scenario: Get request to the cases endpoint for a non existing case id
    When I make the GET call to the caseservice cases endpoint for case "101"
    Then the response status should be 404
    And the response should contain the field "error.code" with value "RESOURCE_NOT_FOUND"
    And the response should contain the field "error.message" with value "Case not found for case id 101"
    And the response should contain the field "error.timestamp"  


  # TODO Write test to confirm state change.
