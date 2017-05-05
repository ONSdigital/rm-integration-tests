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
    
  Scenario: Load empty Business example survey
    Given clean sftp folders of all previous ingestions for "business" surveys
    And the exit status should be 0
    When for the "business" survey move the "min" file to trigger ingestion
    Then for the "business" survey confirm processed file "census-survey-full*.xml.processed" is found
    And the exit status should be 0


	# Endpoint Tests -----

	# POST /samples/sampleunitrequests
	# 200
  Scenario: Get request to sample service for specific survey referance and start time stamp
    Given I make the POST call to the sample service endpoint for surveyRef "CENSUS" and for "1234" with a start of "2001-12-31T12:00:00+00"
    When the response status should be 200
    Then the response should contain the field "sampleUnitsTotal" with an integer value of 0

	Scenario: Get request to sample service for specific survey referance and start time stamp
    Given I make the POST call to the sample service endpoint for surveyRef "InvalidRef" and for "1234" with a start of "2001-12-31T12:00:00+00"
    When the response status should be 200
    Then the response should contain the field "sampleUnitsTotal" with an integer value of 0

	#201
	@empty
	Scenario: Get request to sample service for specific survey referance and start time stamp
    Given I make the POST call to the sample service endpoint for surveyRef "BRES" and for "1234" with a start of "2001-12-31T12:00:00+00"
    When the response status should be 201
    Then the response should contain the field "sampleUnitsTotal" with an integer value of 0

	# 400
  Scenario: Get request to sample service for specific survey referance and start time stamp
    Given I make the POST call to the sample service endpoint for surveyRef "CENSUS" and for "1234" with a start of "2001-12-31T12:00:00+00"
    When the response status should be 400
    #Then the response should contain the field "error.code" with value "SYSTEM_ERROR"
		#And the response should contain the field "error.message" with value ""
		#And the response should contain the field "error.timestamp"


