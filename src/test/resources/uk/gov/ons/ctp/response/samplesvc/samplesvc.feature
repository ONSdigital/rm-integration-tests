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
    Given clean sftp folders of all previous ingestions for "BSD" surveys
    And the sftp exit status should be "-1"
    When for the "BSD" survey move the "valid" file to trigger ingestion
    And the sftp exit status should be "-1"
    And after a delay of 70 seconds
    Then for the "BSD" survey confirm processed file "BSD-survey-full*.xml.processed" is found
    And the sftp exit status should be "-1"

  Scenario: Load empty Census example survey
    Given clean sftp folders of all previous ingestions for "CTP" surveys
    And the sftp exit status should be "-1"
    When for the "CTP" survey move the "min" file to trigger ingestion
    And the sftp exit status should be "-1"
    And after a delay of 10 seconds
    Then for the "CTP" survey confirm processed file "CTP-survey-min*.xml.processed" is found
    And the sftp exit status should be "-1"


  # Endpoint Tests -----

  # POST /samples/sampleunitrequests
  # 201
  Scenario: Post request to sample service for specific survey reference and start time stamp
    Given I make the POST call to the sample service endpoint for surveyRef "221" and for "c6467711-21eb-4e78-804c-1db8392f93fb" with a start of "2017-08-29T23:00:00.000+0000"
    When the response status should be 201
    Then the response should contain the field "sampleUnitsTotal" with an integer value of 500

  Scenario: Post request to sample service for an empty survey reference and start time stamp
    Given I make the POST call to the sample service endpoint for surveyRef "CENSUS" and for "c6467711-21eb-4e78-804c-1db8392f93fc" with a start of "2001-12-31T12:00:00.000+0000"
    When the response status should be 201
    Then the response should contain the field "sampleUnitsTotal" with an integer value of 0

  Scenario: Post request to sample service for invalid survey reference and start time stamp
    Given I make the POST call to the sample service endpoint for surveyRef "InvalidRef" and for "c6467711-21eb-4e78-804c-1db8392f93fd" with a start of "2001-12-31T12:00:00.000+0000"
    When the response status should be 201
    Then the response should contain the field "sampleUnitsTotal" with an integer value of 0

  # 400
  Scenario: Post request to sample service for specific survey reference and start time stamp with a collection exercise job that already exists
    Given I make the POST call to the sample service endpoint for surveyRef "221" and for "c6467711-21eb-4e78-804c-1db8392f93fb" with a start of "2017-08-29T23:00:00.000+0000"
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
    And the response should contain the field "origin" with value "git@github.com:ONSdigital/rm-sample-service.git"
    And the response should contain the field "commit"
    And the response should contain the field "branch" with value "master"
    And the response should contain the field "built"
