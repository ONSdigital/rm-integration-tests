# Author: Stephen Goddard 11/04/2017
#
# Keywords Summary : This feature file contains the scenario tests for the sample service endpoints - details are in the swagger spec
#                    https://github.com/ONSdigital/rm-sample-service/blob/master/samplesvc-api/swagger.yml
#
# Feature: List of cases scenarios: Clean sample service DB to pre test condition
#                                   Get sample units by valid surveyid
#                                   Get sample units by invalid surveyid
#
# Feature Tags: @sampleSvc
#               @sampleEndpoints
#
# Scenario Tags:
#
@sampleSvc @sampleEndpoints
Feature: Runs the sample service endpoints

  # Pre Test Environment Set Up -----

  Scenario: Reset sample service database to pre test condition
    When for the "samplesvc" run the "samplereset.sql" postgres DB script
    Then the samplesvc database has been reset

  Scenario: Load Census example survey
    Given clean sftp folders of all previous ingestions for "census" surveys
    And the sftp exit status should be "-1"
    When for the "census" survey move the "valid" file to trigger ingestion
    And the sftp exit status should be "-1"
    And after a delay of 10 seconds
    Then for the "census" survey confirm processed file "census-survey-full*.xml.processed" is found
    And the sftp exit status should be "-1"
    
  Scenario: Load empty Business example survey
    Given clean sftp folders of all previous ingestions for "business" surveys
    And the sftp exit status should be "-1"
    When for the "business" survey move the "min" file to trigger ingestion
    And the sftp exit status should be "-1"
    And after a delay of 10 seconds
    Then for the "business" survey confirm processed file "business-survey-min*.xml.processed" is found
    And the sftp exit status should be "-1"


  # Endpoint Tests -----

  # POST /samples/sampleunitrequests
  # 200
  Scenario: Post request to sample service for specific survey reference and start time stamp
    Given I make the POST call to the sample service endpoint for surveyRef "CENSUS" and for "1234" with a start of "2001-12-31T12:00:00.000+0000"
    When the response status should be 201
    Then the response should contain the field "sampleUnitsTotal" with an integer value of 1

  Scenario: Post request to sample service for invalid survey reference and start time stamp
    Given I make the POST call to the sample service endpoint for surveyRef "InvalidRef" and for "1234" with a start of "2001-12-31T12:00:00.000+0000"
    When the response status should be 201
    Then the response should contain the field "sampleUnitsTotal" with an integer value of 0

  # 201
  @empty
  Scenario: Post request to sample service for an empty survey reference and start time stamp
    Given I make the POST call to the sample service endpoint for surveyRef "BRES" and for "1234" with a start of "2001-12-31T12:00:00.000+0000"
    When the response status should be 201
    Then the response should contain the field "sampleUnitsTotal" with an integer value of 0

  # 400
  Scenario: Post request to sample service for specific survey reference and start time stamp with a collection exercise job
    Given I make the POST call to the sample service endpoint for surveyRef "CENSUS" and for "1234" with a start of "2001-12-31T12:00:00.000+0000"
    When the response status should be 400
    Then the response should contain the field "error.code" with value "BAD_REQUEST"
		And the response should contain the field "error.message" with value "CollectionExerciseId 1234 already exists in the collectionexercisejob table"
		And the response should contain the field "error.timestamp"


