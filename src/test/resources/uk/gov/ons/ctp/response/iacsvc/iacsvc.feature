# Author: Stephen Goddard 23/09/2017
#
# Keywords Summary : This feature file contains the scenario tests for the iac service - details are in the swagger spec
#                    https://github.com/ONSdigital/iac-service/blob/master/API.md
#
# Feature: List of scenarios: Clean DB to pre test condition
#															Create Sample
#															Confirms system is ready for test
#															Post to create IAC
#															Post to create IAC with invalid input
#															Get IAC using valid IAC
#															Get IAC using invalid IAC
#															Put to update using valid IAC
#															Put to update using invalid input
#
# Feature Tags: @iacsvc
#
# Scenario Tags: @iacCleanEnvironment
#								 @iac
#								 @createIacSample
#								 @generateIAC
#
@iacSvc
Feature: Validating iacsvc requests

  # Pre Test DB Environment Set Up -----

  Scenario: Reset sample service database to pre test condition
    When for the "samplesvc" run the "samplereset.sql" postgres DB script
    Then the samplesvc database has been reset

  Scenario: Reset collection exercise service database to pre test condition
    Given for the "collectionexercisesvc" run the "collectionexercisereset.sql" postgres DB script
    When the collectionexercisesvc database has been reset

  Scenario: Reset case service database to pre test condition
    When for the "casesvc" run the "casereset.sql" postgres DB script
    Then the casesvc database has been reset


  # Pre Test Sample Service Environment Set Up -----

  Scenario: Test business sample load
    When I make the POST call to the sample "bres" service endpoint for the "BSD" survey "valid" file to trigger ingestion
    When the response status should be 201
    Then the response should contain the field "sampleSummaryPK" with an integer value of 1
    And after a delay of 50 seconds


  # Pre Test Collection Exercise Service Environment Set Up -----

   Scenario: Test repuest to sample service service links the sample summary to a collection exercise
    Given I retrieve From Sample DB the Sample Summary
    Given I make the PUT call to the collection exercise for id "14fb3e68-4dca-46db-bf49-04b84e07e77c" endpoint for sample summary id
    And after a delay of 50 seconds
    
  Scenario: Put request to collection exercise service for specific business survey by exercise id 2.1, 2.2
    Given I make the PUT call to the collection exercise endpoint for exercise id "14fb3e68-4dca-46db-bf49-04b84e07e77c"
    When the response status should be 200
    Then the response should contain the field "sampleUnitsTotal" with an integer value of 500


  # Pre Test Case Service Environment Set Up -----

  Scenario: Test casesvc case DB state
    Given after a delay of 400 seconds
    When check "casesvc.case" records in DB equal 500 for "statefk = 'ACTIONABLE'"
    Then check "casesvc.case" distinct records in DB equal 500 for "iac" where "statefk = 'ACTIONABLE'"


	# Endpoint Tests -----

  # POST /iacs
	# 201
  Scenario: Post request for IAC endpoint
  	Given I make the POST call to the iacsvc endpoint for count 1
		When the response status should be 201
		Then the response length should be 16 characters

	# 400
  Scenario: Post request for IAC endpoint for invalid input
  	Given I make the POST call to the iacsvc endpoint with invalid input
		When the response status should be 400
		Then the response should contain the field "error.code" with value "VALIDATION_FAILED"
		And the response should contain the field "error.message" with value "Provided json fails validation."
		And the response should contain the field "error.timestamp"


  # GET /iacs/{iac}
	# 200
  Scenario: Get request to the IAC endpoint
  	Given I make the GET call to the IAC service endpoint
  	When the response status should be 200
  	Then the response should contain the field "caseId"
  	And the response should contain the field "caseRef"
  	And the response should contain the field "iac"
    And the response should contain the field "active" with boolean value "true"
    And the response should contain the field "questionSet" with a null value
    And the response should contain the field "lastUsedDateTime"

	# 404
  Scenario: Get request to the IAC endpoint for a non existing IAC
  	Given I make the GET call to the iacsvc endpoint for IAC "101020023003"
		When the response status should be 404
		Then the response should contain the field "error.code" with value "RESOURCE_NOT_FOUND"
		And the response should contain the field "error.message" with value "IAC not found for iac 101020023003"
		And the response should contain the field "error.timestamp"


  # PUT /iacs/{iac}
	# 200
  Scenario: Put request to the IAC endpoint
  	Given I make the PUT call to the IAC service endpoint
  	When the response status should be 200
  	Then the response should contain the field "code"
  	And the response should contain the field "active" with boolean value "false"
  	And the response should contain the field "code"
  	And the response should contain the field "createdBy" with value "SYSTEM"
  	And the response should contain the field "createdDateTime"
  	And the response should contain the field "updatedBy" with value "Cucumber Test"
  	And the response should contain the field "updatedDateTime"
  	And the response should contain the field "lastUsedDateTime"

	# 400
  Scenario: Put request to the IAC endpoint for invalid input
  	Given I make the PUT call to the iacsvc endpoint with invalid input
		When the response status should be 400
		Then the response should contain the field "error.code" with value "VALIDATION_FAILED"
		And the response should contain the field "error.message" with value "Provided json fails validation."
		And the response should contain the field "error.timestamp"

  #404
  Scenario: Put request to the IAC endpoint for iac not found
    Given I make the PUT call to the IAC service endpoint "237hblnxs101"
    When the response status should be 404
    Then the response should contain the field "error.code" with value "RESOURCE_NOT_FOUND"
    And the response should contain the field "error.message" with value "IAC not found for code 237hblnxs101"
    And the response should contain the field "error.timestamp"


  # INFO /info
  # 200
  Scenario: Info request to sample service for current verison number
    Given I make the call to the IAC service endpoint for info
    When the response status should be 200
    Then the response should contain the field "name" with value "iacsvc"
    And the response should contain the field "version"
    And the response should contain the field "origin" with value "git@github.com:ONSdigital/iac-service.git"
    And the response should contain the field "commit"
    And the response should contain the field "branch"
    And the response should contain the field "built"
