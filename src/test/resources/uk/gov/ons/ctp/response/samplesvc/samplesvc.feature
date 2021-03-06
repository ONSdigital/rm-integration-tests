# Author: Stephen Goddard 11/04/2017
#
# Keywords Summary : This feature file contains the scenario tests for the sample service endpoints - details are in the swagger spec
#                    https://github.com/ONSdigital/rm-sample-service/blob/master/API.md
#                    http://localhost:8125/swagger-ui.html#/sample-endpoint
#
# Feature: List of cases scenarios: Clean sample service DB to pre test condition
#                                   Load samples
#                                   Post valid sample
#                                   Post empty sample
#                                   Post invalid sample
#                                   Post sample that already exists
#
# Feature Tags: @sampleSvc
#               @sampleEndpoints
#
@sampleSvc @sampleEndpoints
Feature: Runs the sample service endpoints

  # Pre Test Environment Set Up -----

  Scenario: Reset sample service database to pre test condition
    When for the "samplesvc" run the "samplereset.sql" postgres DB script
    Then the samplesvc database has been reset


  Scenario: Load Business example survey
    Given I make the POST call to the sample "bres" service endpoint for the "BSD" survey "valid" file to trigger ingestion
    When the response status should be 201
    Then the response should contain the field "sampleSummaryPK" with an integer value of 1
    And after a delay of 50 seconds
    
# Skipping all Census & Social test scenarios. The Census & Social surveys have been removed from SurveySvc.
  # Test fails until defect CTPA-1691 is resolved
#  Scenario: Load Census example survey
#    Given I make the POST call to the sample "census" service endpoint for the "CTP" survey "min" file to trigger ingestion
#    When the response status should be 201
#    Then the response should contain the field "sampleSummaryPK" with an integer value of 2
#    And the response should contain the field "state" with value "INIT"
#    And after a delay of 50 seconds


  # Endpoint Tests -----

  # POST /samples/sampleunitrequests
  # 201
@pub
  Scenario: Post request to sample service for specific survey reference and start time stamp
    Given I make the POST call to the sample service endpoint for surveyRef "221" and for "c6467711-21eb-4e78-804c-1db8392f93fb" with a start of "2017-09-11T23:00:00.000+0000" for ref "1"
    When the response status should be 201
    Then the response should contain the field "sampleUnitsTotal" with an integer value of 500

  # Test fails until defect CTPA-1691 is resolved
#  Scenario: Post request to sample service for an empty survey reference and start time stamp
#    Given I make the POST call to the sample service endpoint for surveyRef "CENSUS" and for "c6467711-21eb-4e78-804c-1db8392f93fc" with a start of "2001-12-31T12:00:00.000+0000"
#    When the response status should be 201
#    Then the response should contain the field "sampleUnitsTotal" with an integer value of 0

  # 400
  Scenario: Post request to sample service for specific survey reference and start time stamp with a collection exercise job that already exists
    Given I make the POST call to the sample service endpoint for surveyRef "221" and for "c6467711-21eb-4e78-804c-1db8392f93fb" with a start of "2017-09-11T23:00:00.000+0000" for ref "1"
    When the response status should be 400
    Then the response should contain the field "error.code" with value "BAD_REQUEST"
		And the response should contain the field "error.message" with value "CollectionExerciseId c6467711-21eb-4e78-804c-1db8392f93fb already exists in the collectionexercisejob table"
		And the response should contain the field "error.timestamp"


  # GET /info
  # 200
  Scenario: Info request to sample service for current verison number
    Given I make the call to the sample service endpoint for info
    When the response status should be 200
    Then the response should contain the field "name" with value "samplesvc"
    And the response should contain the field "version"
    And the response should contain the field "origin"
    And the response should contain the field "commit"
    And the response should contain the field "branch"
    And the response should contain the field "built"
