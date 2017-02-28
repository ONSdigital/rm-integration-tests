# Author: Stephen Goddard 17/01/2017
# Keywords Summary : CTPA-979 This script tests that responded cases does not leave action in cancel_pending state.
#										 Note: Assumption that the DB has been loaded with seed data.
#
# Tasks Covered: CTPA-979 - Responded case not left in cancel pending state
#
# Feature: List of scenarios: Clean DB to pre test condition
#															Create Sample
#															Test Cases Created - max number of cases
#															Test UI initial print file
#															Adjust action case date to simulate the passing of time to trigger reminder letter
#															Simulate online replied for five cases evenly spread
#															Adjust action case date to simulate the passing of time to trigger second reminder letter
#															test DB for any cancelled pending states
#
# Feature Tags: @other
#								@ctpa979
#
# Scenario Tags: @fieldCleanEnvironment
#								 @fieldSample
#								 @fieldCases
#								 @fieldInitialUI
#								 @fieldLetter1Date
#								 @onlineResponseReceived
#								 @fieldLetter2Date
#								 @dbCancelPending

@other @ctpa979
Feature: Test that responded cases does not leave action in cancel_pending state

	# Clean Environment -----

  @fieldCleanEnvironment
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


	# Paper Sample Creation -----

	@fieldSample
	Scenario: Get request for samples for sample id
		When I make the PUT call to the caseservice sample endpoint for sample id "17" for area "REGION" code "E12000005"
		Then the response status should be 200
		And the response should contain the field "name" with value "C2EP331E"
		And the response should contain the field "survey" with value "2017 TEST"
		And check "casesvc.caseevent" records in DB equal 10


	@fieldCases
	Scenario: Get request to case for highest expected case id
		Given after a delay of 20 seconds
		When I make the GET call to the caseservice cases endpoint for case "10"
		Then the response status should be 200
		And the response should contain the field "caseId" with an integer value of 10
		And the response should contain the field "caseGroupId" with an integer value of 10
		And the response should contain the field "caseRef" with value "1000000000000010"
		And the response should contain the field "state" with value "ACTIONABLE"
		And the response should contain the field "caseTypeId" with an integer value of 11
		And the response should contain the field "actionPlanMappingId" with an integer value of 11
		And the response should contain the field "createdDateTime"
		And the response should contain the field "createdBy" with value "SYSTEM"
		And the response should contain the field "iac"
		And the response should contain the field "responses" with one element of the JSON array must be []
		And the response should contain the field "contact" with a null value
		And after a delay of 120 seconds


	# Test Initial Print File Generation -----

	@fieldInitialUI
	Scenario: Confirmed the UI reflects the print file generation
		Given the user has logged in using "Chrome"
    Then the user gets the addresses for postcode "TF15LB"
    And selects case for address "1 FOLDSTON TERRACE"
    And the case state should be "ACTIONABLE"
    And navigates to the cases page for case "1"
    Then the case event description should be "Print household paper questionnaire (English without sexual ID)"
		And the user logs out


	# Reminder letter 1 -----

	# CTPA-822
	@fieldLetter1Date
	Scenario: Post request to actionplans to create jobs for specified action plan - reminder letter 1
		Given the case start date is adjusted to trigger action plan
			| actionPlanId  | actiontypeid | total |
			| 7  						| 5   				 | 10		 |
		And after a delay of 10 seconds


	# Response Received -----

  @onlineResponseReceived
  Scenario: The system has successfully registered an online response
  	Given I make the POST call to the SDX Gateway online receipt for caseref "1000000000000001"
		And the response status should be 201
		When after a delay of 10 seconds
		Then I make the GET call to the caseservice cases endpoint for case "1"
		And the response status should be 200
		And the response should contain the field "caseId" with an integer value of 1
		And the response should contain the field "caseGroupId" with an integer value of 1
		And the response should contain the field "caseRef" with value "1000000000000001"
		And the response should contain the field "state" with value "INACTIONABLE"
		And the response should contain the field "caseTypeId" with an integer value of 11
		And the response should contain the field "actionPlanMappingId" with an integer value of 11
		And the response should contain the field "createdDateTime"
		And the response should contain the field "createdBy" with value "SYSTEM"
		And the response should contain the field "iac"
		And the response should contain the field "responses" with one element of the JSON array must be [{"inboundChannel":"ONLINE","dateTime":
		And the response should contain the field "contact" with a null value

  @onlineResponseReceived
  Scenario: The system has successfully registered an online response
  	Given I make the POST call to the SDX Gateway online receipt for caseref "1000000000000002"
		And the response status should be 201
		When after a delay of 10 seconds
		Then I make the GET call to the caseservice cases endpoint for case "2"
		And the response status should be 200
		And the response should contain the field "caseId" with an integer value of 2
		And the response should contain the field "caseGroupId" with an integer value of 2
		And the response should contain the field "caseRef" with value "1000000000000002"
		And the response should contain the field "state" with value "INACTIONABLE"
		And the response should contain the field "caseTypeId" with an integer value of 11
		And the response should contain the field "actionPlanMappingId" with an integer value of 11
		And the response should contain the field "createdDateTime"
		And the response should contain the field "createdBy" with value "SYSTEM"
		And the response should contain the field "iac"
		And the response should contain the field "responses" with one element of the JSON array must be [{"inboundChannel":"ONLINE","dateTime":
		And the response should contain the field "contact" with a null value

	@onlineResponseReceived
  Scenario: The system has successfully registered an online response
  	Given I make the POST call to the SDX Gateway online receipt for caseref "1000000000000005"
		And the response status should be 201
		When after a delay of 10 seconds
		Then I make the GET call to the caseservice cases endpoint for case "5"
		And the response status should be 200
		And the response should contain the field "caseId" with an integer value of 5
		And the response should contain the field "caseGroupId" with an integer value of 5
		And the response should contain the field "caseRef" with value "1000000000000005"
		And the response should contain the field "state" with value "INACTIONABLE"
		And the response should contain the field "caseTypeId" with an integer value of 11
		And the response should contain the field "actionPlanMappingId" with an integer value of 11
		And the response should contain the field "createdDateTime"
		And the response should contain the field "createdBy" with value "SYSTEM"
		And the response should contain the field "iac"
		And the response should contain the field "responses" with one element of the JSON array must be [{"inboundChannel":"ONLINE","dateTime":
		And the response should contain the field "contact" with a null value

	@onlineResponseReceived
  Scenario: The system has successfully registered an online response
  	Given I make the POST call to the SDX Gateway online receipt for caseref "1000000000000008"
		And the response status should be 201
		When after a delay of 10 seconds
		Then I make the GET call to the caseservice cases endpoint for case "8"
		And the response status should be 200
		And the response should contain the field "caseId" with an integer value of 8
		And the response should contain the field "caseGroupId" with an integer value of 8
		And the response should contain the field "caseRef" with value "1000000000000008"
		And the response should contain the field "state" with value "INACTIONABLE"
		And the response should contain the field "caseTypeId" with an integer value of 11
		And the response should contain the field "actionPlanMappingId" with an integer value of 11
		And the response should contain the field "createdDateTime"
		And the response should contain the field "createdBy" with value "SYSTEM"
		And the response should contain the field "iac"
		And the response should contain the field "responses" with one element of the JSON array must be [{"inboundChannel":"ONLINE","dateTime":
		And the response should contain the field "contact" with a null value

	@onlineResponseReceived
  Scenario: The system has successfully registered an online response
  	Given I make the POST call to the SDX Gateway online receipt for caseref "1000000000000010"
		And the response status should be 201
		When after a delay of 10 seconds
		Then I make the GET call to the caseservice cases endpoint for case "10"
		And the response status should be 200
		And the response should contain the field "caseId" with an integer value of 10
		And the response should contain the field "caseGroupId" with an integer value of 10
		And the response should contain the field "caseRef" with value "1000000000000010"
		And the response should contain the field "state" with value "INACTIONABLE"
		And the response should contain the field "caseTypeId" with an integer value of 11
		And the response should contain the field "actionPlanMappingId" with an integer value of 11
		And the response should contain the field "createdDateTime"
		And the response should contain the field "createdBy" with value "SYSTEM"
		And the response should contain the field "iac"
		And the response should contain the field "responses" with one element of the JSON array must be [{"inboundChannel":"ONLINE","dateTime":
		And the response should contain the field "contact" with a null value


	# Reminder letter 2 -----

	# CTPA-822
	@fieldLetter2Date
	Scenario: Post request to actionplans to create jobs for specified action plan - reminder letter 2
		Given the case start date is adjusted to trigger action plan
			| actionPlanId  | actiontypeid | total |
			| 7  						| 8   				 | 5		 |
		And after a delay of 90 seconds


	@dbCancelPending
	Scenario: Confirmed the DB has no cancel pending state entries
		When check "action.action" records in DB equal 0 for "state = 'CANCEL_PENDING'"
