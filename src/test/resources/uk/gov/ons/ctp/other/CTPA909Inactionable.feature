# Author: Stephen Goddard 03/10/2016
# Keywords Summary : CTPA-909 This script tests that an inactionable case can have events raise against it.
#										 Note: Assumption that the DB has been loaded with seed data.
#
# Tasks Covered: Clean Environment
#								 Create Sample
#								 Create Case
#								 Receive Online Response
#								 Create Event
#
# Feature: List of scenarios: Clean DB to pre test condition
#															Create Sample
#															Test Cases Created - max number of cases
#															Test Cases Created - max number of cases +1
#															Test Generated IAC
#															Receive Successfully Online Response
#															UI case event confirm Online Questionnaire Response
#															Invalid iac on iscsvc
#															CTPA-909 Create an event against inactionable case
#
# Feature Tags: @other
#								@ctpa909
#
# Scenario Tags: @onlineCleanEnvironment
#								 @createOnlineSample
#								 @createdOnlineCases
#								 @generateOnlineIAC
#								 @validateOnlineIAC
#								 @onlineRespondedUI
#								 @onlineResponseReceived
#								 @onlineRespondedUI
#								 @inactiveOnlineIAC
#								 @createEvent

@other @ctpa909
Feature: Test successfull creation of events against an inactionable case 

	# Clean Environment -----

  @onlineCleanEnvironment
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

	@createOnlineSample
	Scenario: Put request for sample to create online cases for the specified sample id
		When I make the PUT call to the caseservice sample endpoint for sample id "1" for area "REGION" code "E12000005"
		Then the response status should be 200
		And the response should contain the field "name" with value "C2EO332E"
		And the response should contain the field "survey" with value "2017 TEST"
		And check "casesvc.caseevent" records in DB equal 10


	@createOnlineCases
	Scenario: Get request to case for highest expected case id
		Given after a delay of 40 seconds
		When I make the GET call to the caseservice cases endpoint for case "10"
		Then the response status should be 200
		And the response should contain the field "caseId" with an integer value of 10
		And the response should contain the field "caseGroupId" with an integer value of 10
		And the response should contain the field "caseRef" with value "1000000000000010"
		And the response should contain the field "state" with value "ACTIONABLE"
		And the response should contain the field "caseTypeId" with an integer value of 17
		And the response should contain the field "actionPlanMappingId" with an integer value of 17
		And the response should contain the field "createdDateTime"
		And the response should contain the field "createdBy" with value "SYSTEM"
		And the response should contain the field "iac"
		And the response should contain the field "responses" with one element of the JSON array must be []
		And the response should contain the field "contact" with a null value

	@createOnlineCases
	Scenario: Get request to case for first not expected case id
		When I make the GET call to the caseservice cases endpoint for case "11"
		Then the response status should be 404


	@generateOnlineIAC
	Scenario: Each case has a unique IAC assigned to it and cases have been sent to the action service
			and in Actionable state
			and action service has been notified case has been created
		When check "casesvc.case" distinct records in DB equal 10 for "iac" where "state = 'ACTIONABLE'"
		And check "casesvc.case" records in DB equal 10 for "state = 'ACTIONABLE' AND casetypeid = 17"
		And check "action.case" records in DB equal 1 for "caseid = 10"
		And after a delay of 150 seconds


	# Online Response -----

  @validateOnlineIAC
  Scenario: Validate IAC and confirm the case iac is active
  	Given I make the GET call to the caseservice cases endpoint for case "10"
  	And the response status should be 200
  	And the response should contain the field "iac"
  	When I make the GET call to the IAC service endpoint
  	Then the response status should be 200
  	And the response should contain the field "caseId" with an integer value of 10
  	And the response should contain the field "caseRef" with value "1000000000000010"
  	And the response should contain the field "iac"
  	And the response should contain the field "active" with boolean value "true"
  	And the response should contain the field "questionSet" with value "H1"


  @onlineResponseReceived
  Scenario: Test the system has successfully registered an online response
  	Given I make the POST call to the SDX Gateway online receipt for caseref "1000000000000010"
		And the response status should be 201
		When after a delay of 20 seconds
		Then I make the GET call to the caseservice cases endpoint for case "10"
		And the response status should be 200
		And the response should contain the field "caseId" with an integer value of 10
		And the response should contain the field "caseGroupId" with an integer value of 10
		And the response should contain the field "caseRef" with value "1000000000000010"
		And the response should contain the field "state" with value "INACTIONABLE"
		And the response should contain the field "caseTypeId" with an integer value of 17
		And the response should contain the field "actionPlanMappingId" with an integer value of 17
		And the response should contain the field "createdDateTime"
		And the response should contain the field "createdBy" with value "SYSTEM"
		And the response should contain the field "iac"
		And the response should contain the field "responses" with one element of the JSON array must be [{"inboundChannel":"ONLINE","dateTime":
		And the response should contain the field "contact" with a null value


	@onlineRespondedUI
	Scenario: Confirmed the UI reflects the online response receipt
		Given the "Test" user has logged in using "Chrome"
    Then the user gets the addresses for postcode "TF107BH"
    And selects case for address "BEDSIT 10"
    And the case state for "10" should be "INACTIONABLE"
    And navigates to the cases page for case "10"
    Then the case event category should be "Online Questionnaire Response"
		And the user logs out


  @inactiveOnlineIAC
  Scenario: Validate inactive IAC
  	Given I make the GET call to the caseservice cases endpoint for case "10"
  	And the response status should be 200
  	And the response should contain the field "iac"
  	Then I make the GET call to the IAC service endpoint
  	And the response status should be 200
  	And the response should contain the field "caseId" with an integer value of 10
  	And the response should contain the field "caseRef" with value "1000000000000010"
  	And the response should contain the field "iac"
  	And the response should contain the field "active" with boolean value "false"
  	And the response should contain the field "questionSet" with value "H1"


	# CTPA-909 Create event -----

	@createEvent
  Scenario: Create a General Complaint case event
    Given the "Test" user has logged in using "Chrome"
    When the user gets the addresses for postcode "TF107BH"
    And selects case for address "BEDSIT 10"
    And navigates to the cases page for case "10"
    And the user creates a new event for
      | General Complaint | Test description. | Mr | Integration | Tester | 01234 567890 |
    Then the case event category should be "General Complaint"
    And the case event description should be "name: Mr integration tester phone: 01234 567890 Test description."
    And the user navigates back to the cases page
    And the case state for "10" should be "INACTIONABLE"
    #And the user logs out
