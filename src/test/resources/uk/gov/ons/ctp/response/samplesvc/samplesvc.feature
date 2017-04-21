# Author: Stephen Goddard 11/04/2017
#
# Keywords Summary : This feature file contains the scenario tests for the sample service endpoints - details are in the swagger spec
#										 https://github.com/ONSdigital/rm-sample-service/blob/master/samplesvc-api/swagger.yml
#
# Feature: List of cases scenarios: Clean sample service DB to pre test condition
#																		Get sample units by valid surveyid
#																		Get sample units by invalid surveyid
#
# Feature Tags: @sampleSvc
#								@sampleEndpoints
#
# Scenario Tags:

@sampleSvc @sampleEndpoints
Feature: Runs the sample service endpoints

	# Pre Test Environment Set Up -----

  Scenario: Reset sample service database to pre test condition
    Given the samplesvc database has been reset

  Scenario: Load Census example survey
    Given clean sftp folders of all previous ingestions for "census" surveys
    And the exit status should be 0
    When for the "census" survey move the "valid" file to trigger ingestion
    Then for the "census" survey confirm processed file "census-survey-full*.xml.processed" is found
    And the exit status should be 0

	# Endpoint Tests -----

	# POST /samples/{surveyRef}/{startTimestamp}???
	# 200
  Scenario: Get request to sample service for specific survey referance and start time stamp
    Given I make the POST call to the sample service endpoint for surveyRef "CENSUS" with a start of "2001-12-31%2012:00:00"
    When the response status should be 200
    Then the response should contain a JSON array of size 1
    And one element of the JSON array must be {"sampleUnitId":1,"sampleId":1,"sampleUnitRef":"sampleUnitRef","sampleUnitType":"H"}

	# 404?
  Scenario: Get request to sample service for specific survey referance and start time stamp
    Given I make the POST call to the sample service endpoint for surveyRef "InvalidRef" with a start of "2001-12-31%2012:00:00"
    When the response status should be 204
    Then the response should contain the field "error.code" with value "SYSTEM_ERROR"
		And the response should contain the field "error.message" with value ""
		And the response should contain the field "error.timestamp"


	# PUT /samples/{sampleId}
	# 200
	Scenario: Put request for sample to create online cases for the specified sample id
		Given Update "sample.samplesummary" to "state = 'INIT'" where "sampleid = 1"
		When I make the PUT call to the sample service endpoint for sample id "1"
		Then the response status should be 200
		And the response should contain the field "sampleId" with an integer value of 1
		And the response should contain the field "effectiveStartDateTime"
		And the response should contain the field "surveyRef" with value "CENSUS"
		And the response should contain the field "effectiveStartDateTime"
		And the response should contain the field "state" with value "ACTIVE"

	# 404?
  Scenario: Get request to sample service for specific survey referance and start time stamp
    Given I make the PUT call to the sample service endpoint for sample id "101"
    When the response status should be 404
    Then the response should contain the field "error.code" with value "SYSTEM_ERROR"
		And the response should contain the field "error.message" with value ""
		And the response should contain the field "error.timestamp"
