# Author: Stephen Goddard 23/09/2017
#
# Keywords Summary : This feature file contains the scenario tests for the iac service - details are in the swagger spec
#                    https://github.com/ONSdigital/iac-service/blob/master/iacsvc-api/swagger.yml
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

@iacsvc
Feature: Validating iacsvc requests

	# Clean Environment -----

  @iacCleanEnvironment
  Scenario: Clean DB to pre test condition
    When reset the postgres DB
    Then check "casesvc.case" records in DB equal 0
    And check "casesvc.caseevent" records in DB equal 0
		And check "casesvc.casegroup" records in DB equal 0
		And check "casesvc.contact" records in DB equal 0
		And check "casesvc.response" records in DB equal 0
    And check "casesvc.messagelog" records in DB equal 0
    And check "casesvc.unlinkedcasereceipt" records in DB equal 0
    And check "action.action" records in DB equal 0
    And check "action.actionplanjob" records in DB equal 0
    And check "action.case" records in DB equal 0
    And check "action.messagelog" records in DB equal 0
    And check "casesvc.caseeventidseq" sequence in DB equal 1
    And check "casesvc.caseidseq" sequence in DB equal 1
    And check "casesvc.casegroupidseq" sequence in DB equal 1
    And check "casesvc.caserefseq" sequence in DB equal 1000000000000001
    And check "casesvc.responseidseq" sequence in DB equal 1
    And check "casesvc.messageseq" sequence in DB equal 1
    And check "action.actionidseq" sequence in DB equal 1
    And check "action.actionplanjobseq" sequence in DB equal 1
    And check "action.messageseq" sequence in DB equal 1


	# Online Sample Creation -----

	@createIacSample
	Scenario: Put request for sample to create online cases for the specified sample id
		When I make the PUT call to the caseservice sample endpoint for sample id "1" for area "REGION" code "E12000005"
		Then the response status should be 200
		And the response should contain the field "name" with value "C2EO332E"
		And the response should contain the field "survey" with value "2017 TEST"
		And check "casesvc.caseevent" records in DB equal 10
		And after a delay of 30 seconds

	@generateIAC
	Scenario: Each case has a unique IAC assigned to it - confirms system is ready for test
			and in Actionable state
			and action service has been notified case has been created
		When check "casesvc.case" distinct records in DB equal 10 for "iac" where "state = 'ACTIONABLE'"
		And check "casesvc.case" records in DB equal 10 for "state = 'ACTIONABLE' AND casetypeid = 17"
		And check "action.case" records in DB equal 1 for "caseid = 10"


	# Endpoint Tests -----

  # POST /iacs
	# 201
  @iac
  Scenario: Post request for IAC endpoint
  	When I make the POST call to the iacsvc endpoint for count 1
		Then the response status should be 201
		And the response length should be 16 characters

	# 400
  @iac
  Scenario: Post request for IAC endpoint for invalid input
  	When I make the POST call to the iacsvc endpoint with invalid input
		Then the response status should be 400
		And the response should contain the field "error.code" with value "VALIDATION_FAILED"
		And the response should contain the field "error.message" with value "Provided json is incorrect."
		And the response should contain the field "error.timestamp"


  # GET /iacs/{iac}
	# 200
  @iac
  Scenario: Get request to the IAC endpoint
  	Given I make the GET call to the caseservice cases endpoint for case "1"
  	And the response status should be 200
  	And the response should contain the field "iac"
  	Then I make the GET call to the IAC service endpoint
  	And the response status should be 200
  	And the response should contain the field "caseId" with an integer value of 1
  	And the response should contain the field "caseRef" with value "1000000000000001"
  	And the response should contain the field "iac"
  	And the response should contain the field "active" with boolean value "true"
  	And the response should contain the field "questionSet" with value "H1"

	# 404
  @iac
  Scenario: Get request to the IAC endpoint for a non existing IAC
  	When I make the GET call to the iacsvc endpoint for IAC "100120023003"
		Then the response status should be 404
		And the response should contain the field "error.code" with value "RESOURCE_NOT_FOUND"
		And the response should contain the field "error.message" with value "IAC not found for iac 100120023003"
		And the response should contain the field "error.timestamp"


  # PUT /iacs/{iac}
	# 200
  @iac
  Scenario: Put request to the IAC endpoint
  	Given I make the GET call to the caseservice cases endpoint for case "1"
  	And the response status should be 200
  	And the response should contain the field "iac"
  	Then I make the PUT call to the IAC service endpoint
  	And the response status should be 200
  	And the response should contain the field "code"
  	And the response should contain the field "active" with boolean value "false"
  	And the response should contain the field "code"
  	And the response should contain the field "createdBy" with value "SYSTEM"
  	And the response should contain the field "createdDateTime"
  	And the response should contain the field "updatedBy" with value "Cucumber Test"
  	And the response should contain the field "updatedDateTime"

	# 400
  @iac
  Scenario: Put request to the IAC endpoint for invalid input
  	When I make the PUT call to the iacsvc endpoint with invalid input
		Then the response status should be 400
		And the response should contain the field "error.code" with value "VALIDATION_FAILED"
		And the response should contain the field "error.message" with value "Provided json is incorrect."
		And the response should contain the field "error.timestamp"
  