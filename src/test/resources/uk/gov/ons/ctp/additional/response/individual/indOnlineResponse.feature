# Author: Stephen Goddard 12/10/2016
# Keywords Summary : This feature file contains the scenario tests individual online response.
#										 Detailed in: https://collaborate2.ons.gov.uk/confluence/pages/viewpage.action?pageId=3690875
#										 Note: Assumption that the DB has been loaded with seed data.
#
# Tasks Covered: CTPA-558 Helpline request
#								 CTPA-760 Process Service Request
#								 CTPA-522 Create new cases
#								 CTPA-673 Generate IAC
#								 CTPA-524 Change Case State
#								 CTPA-526 Run Action Plan
#								 CTPA-579 Generate IC Print File
#													Create Event
#								 CTPA-727 Send Actions To Notify
#								 CTPA-651 Validate IAC
#								 CTPA-538 Receive Online Response
#								 CTPA-537 Capture Mode
#								 CTPA-524 Change Case State
#								 CTPA-770 Cancel Distribute Actions
#
# Feature: List of scenarios: Adjust survey start and end date
#															Clean DB to pre test condition
#															Create Sample
#															Test Cases Created - max number of cases
#															Helpline UI request individual online
#															Create Cases
#															Generate IAC
#															UI case state confirm Actionable
#															Run Action Plan
#															Generate Notify Print File
#															UI printer case event confirm Created
#															Validate IAC
#															Create Event - currently place holder as nice to have for 2017 test
#															Receive Successfully Online Response
#															Distributed Actions Cancelled
#															Confirm original case still actionable
#															Confirm individual case now inactionable
#															UI case event confirm QuestionnaireResponded
#
# Feature Tags: @individualOnlineResponse
#								@additionalIndividualResponse
#
# Scenario Tags: @indAdjustSurveyDate
#								 @indCleanEnvironment
#								 @createIndSample
#								 @createIndCases
#								 @requestIndSMSUI
#								 @createIndCases
#								 @generateIndIAC
#								 @indActionableUI
#								 @indPrinterAction
#								 @indPrinterFile
#								 @indPrinterUI
#								 @indValidateIAC
#								 @createEventPlaceHolder
#								 @indOnlineResponseReceived
#								 @indDistributedActionsCancelled
#								 @activeIndOnlineIAC
#								 @inactiveIndOnlineIAC
#								 @indOnlineRespondedUI

@individualOnlineResponse @additionalIndividualResponse
Feature: Test successful individual online response

	# Clean Environment -----
	
	@indAdjustSurveyDate
	Scenario: Reset survey date
		When the survey start and is reset to 20 days ahead for "2017 Test"
		Then the survey end and is reset to 50 days ahead for "2017 Test"


  @indCleanEnvironment
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

	# CTPA-624
	@createIndSample
	Scenario: Put request for sample to create online cases for the specified sample id
		When I make the PUT call to the caseservice sample endpoint for sample id "1" for area "REGION" code "E12000005"
		Then the response status should be 200
		And the response should contain the field "name" with value "C2EO332E"
		And the response should contain the field "survey" with value "2017 TEST"
		And check "casesvc.caseevent" records in DB equal 10


	# CTPA-709
	@createIndCases
	Scenario: Get request to case for highest expected case id
		Given after a delay of 30 seconds
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


	# Individual Online Creation -----							 
	
	# CTPA-558
	# CTPA-760
	@requestIndSMSUI
	Scenario: Ui request for individual online request
		Given the "Test" user has logged in using "Chrome"
    When the user gets the addresses for postcode "TF107BH"
    And selects case for address "BEDSIT 1"
    And the case state should be "ACTIONABLE"
    And navigates to the cases page for case "1"
    And the user requests an individual request for
      | Online | Dr | Integration | Tester |  | 07777123456 |  |
    And the user logs out


	# CTPA-522
	@createIndCases
	Scenario: Get request to case newly created case
		Given after a delay of 40 seconds
		When I make the GET call to the caseservice cases endpoint for case "11"
		Then the response status should be 200
		And the response should contain the field "caseId" with an integer value of 11
		And the response should contain the field "caseGroupId" with an integer value of 1
		And the response should contain the field "caseRef" with value "1000000000000011"
		And the response should contain the field "state" with value "ACTIONABLE"
		And the response should contain the field "caseTypeId" with an integer value of 26
		And the response should contain the field "actionPlanMappingId" with an integer value of 50
		And the response should contain the field "createdDateTime"
		And the response should contain the field "createdBy" with value "integration.tester"
		And the response should contain the field "iac"
		And the response should contain the field "responses" with one element of the JSON array must be []
		And the response should contain the field "contact" with list value "{title=dr, forename=Integration, surname=Tester, phoneNumber=07777123456, emailAddress=null}"


	# CTPA-673
	@generateIndIAC
	Scenario: Each case has a unique IAC assigned to it and in ACTIONABLE state
		When check "casesvc.case" distinct records in DB equal 11 for "iac" where "state = 'ACTIONABLE'"
		And check "casesvc.case" records in DB equal 10 for "state = 'ACTIONABLE' AND casetypeid = 17"
		And check "casesvc.case" records in DB equal 1 for "state = 'ACTIONABLE' AND casetypeid = 26"
		And check "action.case" records in DB equal 1 for "caseid = 11"


	# CTPA-524
	@indActionableUI
	Scenario: Tests that the case is in a state of ACTIONABLE
    Given the "Test" user has logged in using "Chrome"
    When the user gets the addresses for postcode "TF107BH"
    And selects case for address "BEDSIT 1"
    And the case state should be "ACTIONABLE"
    And navigates to the cases page for case "11"
    And the user logs out
 

	# Individual Online Notify File Action -----

	#	CTPA-526
	#	CTPA-579
	#	CTPA-727
	@indNotify
	Scenario: Test action plan has created action for notify
		Given after a delay of 90 seconds
		# How to notify? Currently a text is sent to the number in this test


	@indPrinterUI
  Scenario: This scenario tests that the case event created
    Given the "Test" user has logged in using "Chrome"
    When the user gets the addresses for postcode "TF107BH"
    And selects case for address "BEDSIT 1"
    And the case state should be "ACTIONABLE"
    And navigates to the cases page for case "11"
    Then the case event should contain "Action Created"
    And the case event description should be "Send Internet Access Code (English)"
    And the user logs out


	# Individual Online Response -----

	#	CTPA-651
	@indValidateIAC
  Scenario: Validate IAC and confirm the case iac is active
  	Given I make the GET call to the caseservice cases endpoint for case "11"
  	And the response status should be 200
  	And the response should contain the field "iac"
  	When I make the GET call to the IAC service endpoint
  	Then the response status should be 200
  	And the response should contain the field "caseId" with an integer value of 11
  	And the response should contain the field "caseRef" with value "1000000000000011"
  	And the response should contain the field "iac"
  	And the response should contain the field "active" with boolean value "true"
  	And the response should contain the field "questionSet" with value "I1"


	@onlineRespondedUI
	Scenario: Create event to show the IAC has been accessed
		Given the "Test" user has logged in using "Chrome"
    Then the user gets the addresses for postcode "TF107BH"
    And selects case for address "BEDSIT 1"
    And the case state should be "ACTIONABLE"
    And navigates to the cases page for case "11"
    Then the case event should contain "Access Code Authenticated By Respondent"
		And the user logs out


	# CTPA-538
	# CTPA-537
	# CTPA-524
	@indOnlineResponseReceived
  Scenario: Test the system has successfully registered an online response
  	Given I make the POST call to the SDX Gateway online receipt for caseref "1000000000000011"
		And the response status should be 201
		When after a delay of 30 seconds
		Then I make the GET call to the caseservice cases endpoint for case "11"
		And the response status should be 200
		And the response should contain the field "caseId" with an integer value of 11
		And the response should contain the field "caseGroupId" with an integer value of 1
		And the response should contain the field "caseRef" with value "1000000000000011"
		And the response should contain the field "state" with value "INACTIONABLE"
		And the response should contain the field "caseTypeId" with an integer value of 26
		And the response should contain the field "actionPlanMappingId" with an integer value of 50
		And the response should contain the field "createdDateTime"
		And the response should contain the field "createdBy" with value "integration.tester"
		And the response should contain the field "iac"
		And the response should contain the field "responses" with one element of the JSON array must be [{"inboundChannel":"ONLINE","dateTime":
		And the response should contain the field "contact" with list value "{title=dr, forename=Integration, surname=Tester, phoneNumber=07777123456, emailAddress=null}"


	#	CTPA-770
	@indDistributedActionsCancelled
  Scenario: Cancel Distributed Actions
  	Then check "action.case" records in DB equal 0 for "caseid = 11"
  	# NOTE: Does not yet test distributed actions are cancelled only no new actions aganist case cannot be created


	@indOnlineRespondedUI
	Scenario: Confirmed the UI reflects the online response receipt
		Given the "Test" user has logged in using "Chrome"
    Then the user gets the addresses for postcode "TF107BH"
    And selects case for address "BEDSIT 1"
    And the case state for "11" and "INACTIONABLE"
    And navigates to the cases page for case "11"
    Then the case event should contain "Online Questionnaire Response"
		And the user logs out


  @activeOnlineIAC
  Scenario: Validate inactive IAC
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

  @inactiveOnlineIAC
  Scenario: Validate inactive IAC
  	Given I make the GET call to the caseservice cases endpoint for case "11"
  	And the response status should be 200
  	And the response should contain the field "iac"
  	Then I make the GET call to the IAC service endpoint
  	And the response status should be 200
  	And the response should contain the field "caseId" with an integer value of 11
  	And the response should contain the field "caseRef" with value "1000000000000011"
  	And the response should contain the field "iac"
  	And the response should contain the field "active" with boolean value "false"
  	And the response should contain the field "questionSet" with value "I1"

		
	@onlineRespondedUI
	Scenario: Create event to show the IAC has been accessed
		Given the "Test" user has logged in using "Chrome"
    Then the user gets the addresses for postcode "TF107BH"
    And selects case for address "BEDSIT 1"
    And the case state should be "INACTIONABLE"
    And navigates to the cases page for case "11"
    Then the case event should contain "Access Code Authenticated By Respondent"
		And the user logs out
