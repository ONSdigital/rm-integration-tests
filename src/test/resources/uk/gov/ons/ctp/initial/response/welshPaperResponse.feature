# Author: Stephen Goddard 25/11/2016
# Keywords Summary : This feature file contains the scenario tests welsh initial paper response.
#										 Detailed in: https://collaborate2.ons.gov.uk/confluence/pages/viewpage.action?pageId=3690875
#										 Note: Assumption that the DB has been loaded with seed data.
#
# Tasks Covered: CTPA-624 Create Sample
#								 CTPA-709 Create Case
#								 CTPA-673 Generate IAC
#								 CTPA-524 Update Case State
#								 CTPA-526 Run Action Plan
#								 CTPA-579 Generate PQ Print File
#													Create Event
#								 CTPA-580 Send File To Printer
#								 CTPA-653 Provide Landing Page – unable to test as Respondent Home is not available in CI environment
#								 CTPA-651 Validate IAC
#								 CTPA-538 Receive Paper Response
#								 CTPA-537 Capture Mode
#								 CTPA-524 Change Case State
#								 CTPA-770 Cancel Distribute Actions
#
# Feature: List of scenarios: Adjust survey start and end date
#															Clean print file directory
#															Clean DB to pre test condition
#															Create Sample
#															Test Cases Created - max number of cases
#															Test Cases Created - max number of cases +1
#															Test Generated IAC
#															UI case state confirm Actionable
#															UI case event confirm Created
#															Run printer action plan
#															Generate PQ print file
#															Create Event
#															Send file To printer
#															UI printer case event confirm Created
#															Receive Successfully Paper Response
#															Distributed Actions Cancelled
#															UI case state confirm Responded and response mode Paper
#															UI case event confirm QuestionnaireResponded
#
# Feature Tags: @paperReponse
#								@initialResponse
#
# Scenario Tags: @paperAdjustSurveyDate
#								 @cleanPrintFiles
#								 @paperCleanEnvironment
#								 @createPaperSample
#								 @createPaperCases
#								 @generatePaperIAC
#								 @paperActionableUI
#								 @paperPrinterAction
#								 @paperPrinterFile
#								 @paperPrinterUI
#								 @validateIAC
#								 @createEventPlaceHolder
#								 @paperResponseReceived
#								 @distributedActionsCancelled
#								 @paperRespondedUI
#								 @chrome

@paperResponse @initialResponse @welshPaperResponse
Feature: Test successfull Welsh paper response

	# Clean Environment -----

	@paperAdjustSurveyDate
	Scenario: Reset survey date
		When the survey start and is reset to 20 days ahead for "2017 Test"
		Then the survey end and is reset to 50 days ahead for "2017 Test"


	@cleanPrintFiles
	Scenario: Clean folder of previous print files by coping all existing files to /previousTests
		When create test directory "/var/actionexporter-sftp/previousTests/"
		And the exit status should be 0
		Then move print files from "/var/actionexporter-sftp/" to "/var/actionexporter-sftp/previousTests/"
		And the exit status should be 0


  @paperCleanEnvironment
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

	# CTPA-624
	@createPaperSample
	Scenario: Put request for sample to create paper cases for the specified sample id
		When I make the PUT call to the caseservice sample endpoint for sample id "16" for area "REGION" code "E12000005"
		Then the response status should be 200
		And the response should contain the field "name" with value "C2SP331W"
		And the response should contain the field "survey" with value "2017 TEST"
		And check "casesvc.caseevent" records in DB equal 10


	# CTPA-709
	@createPaperCases
	Scenario: Get request to case for highest expected case id
		Given after a delay of 40 seconds
		When I make the GET call to the caseservice cases endpoint for case "10"
		Then the response status should be 200
		And the response should contain the field "caseId" with an integer value of 10
		And the response should contain the field "caseGroupId" with an integer value of 10
		And the response should contain the field "caseRef" with value "1000000000000010"
		And the response should contain the field "state" with value "ACTIONABLE"
		And the response should contain the field "caseTypeId" with an integer value of 10
		And the response should contain the field "actionPlanMappingId" with an integer value of 10
		And the response should contain the field "createdDateTime"
		And the response should contain the field "createdBy" with value "SYSTEM"
		And the response should contain the field "iac"
		And the response should contain the field "responses" with one element of the JSON array must be []
		And the response should contain the field "contact" with a null value

	@createPaperCases
	Scenario: Get request to case for first not expected case id
		When I make the GET call to the caseservice cases endpoint for case "11"
		Then the response status should be 404


	# CTPA-673
	@generatePaperIAC
	Scenario: Each case has a unique IAC assigned to it and cases have been sent to the action service
			and in Actionable state
			and action service has been notified case has been created
		When check "casesvc.case" distinct records in DB equal 10 for "iac" where "state = 'ACTIONABLE'"
		And check "casesvc.case" records in DB equal 10 for "state = 'ACTIONABLE' AND casetypeid = 10"
		And check "action.case" records in DB equal 1 for "caseid = 10"


	# CTPA-524
  @paperActionableUI
  Scenario: Test that the case is in a state of Actionable using UI
    Given the "Test" user has logged in using "Chrome"
    When the user gets the addresses for postcode "TF15GJ"
    And selects case for address "15 GLEN COTTAGES"
    And the case state for "10" should be "ACTIONABLE"
    And the user logs out


	# Paper Print File Action -----

	# CTPA-526
	# CTPA-579
	# CTPA-580
	@paperPrinterFile
	Scenario: Test action plan has created paper questionnaire file for printer
		Given after a delay of 180 seconds
		Then get the contents of the file from "/var/actionexporter-sftp/" where the filename begins "H2S_2003"
		And the exit status should be 0
		When and each line should start with an iac
		And and the contents should contain "|1000000000000008|||||9 GLEN COTTAGES|BRICKHILL LANE|KETLEY|TELFORD|TF1 5GJ"
		And and the contents should contain "|1000000000000003|||||37 GLEN COTTAGES|BRICKHILL LANE|KETLEY|TELFORD|TF1 5GJ"
		And and the contents should contain "|1000000000000004|||||39 GLEN COTTAGES|BRICKHILL LANE|KETLEY|TELFORD|TF1 5GJ"
		And and the contents should contain "|1000000000000010|||||15 GLEN COTTAGES|BRICKHILL LANE|KETLEY|TELFORD|TF1 5GJ"
		And and the contents should contain "|1000000000000001|||||29 GLEN COTTAGES|BRICKHILL LANE|KETLEY|TELFORD|TF1 5GJ"
		And and the contents should contain "|1000000000000009|||||11 GLEN COTTAGES|BRICKHILL LANE|KETLEY|TELFORD|TF1 5GJ"
		And and the contents should contain "|1000000000000005|||||43 GLEN COTTAGES|BRICKHILL LANE|KETLEY|TELFORD|TF1 5GJ"
		And and the contents should contain "|1000000000000007|||||5 GLEN COTTAGES|BRICKHILL LANE|KETLEY|TELFORD|TF1 5GJ"
		And and the contents should contain "|1000000000000006|||||7 GLEN COTTAGES|BRICKHILL LANE|KETLEY|TELFORD|TF1 5GJ"
		And and the contents should contain "|1000000000000002|||||35 GLEN COTTAGES|BRICKHILL LANE|KETLEY|TELFORD|TF1 5GJ"

  @paperPrinterUI
  Scenario: This scenario tests that the case event created
    Given the "Test" user has logged in using "Chrome"
    When the user gets the addresses for postcode "TF15GJ"
    And selects case for address "15 GLEN COTTAGES"
    And the case state for "10" should be "ACTIONABLE"
    And navigates to the cases page for case "10"
    Then the case event should be "Action Created"
    And the case event description should be "Print household paper questionnaire (Welsh with sexual ID)"
    And the user logs out


	# Paper Response -----

	# CTPA-538
	# CTPA-537
	# CTPA-524
  @paperResponseReceived
  Scenario: Test the system has successfully registered an paper response
  	Given I make the POST call to the SDX Gateway paper receipt for caseref "1000000000000010"
		And the response status should be 201
		When after a delay of 20 seconds
		Then I make the GET call to the caseservice cases endpoint for case "10"
		And the response status should be 200
		And the response should contain the field "caseId" with an integer value of 10
		And the response should contain the field "caseGroupId" with an integer value of 10
		And the response should contain the field "caseRef" with value "1000000000000010"
		And the response should contain the field "state" with value "INACTIONABLE"
		And the response should contain the field "caseTypeId" with an integer value of 10
		And the response should contain the field "actionPlanMappingId" with an integer value of 10
		And the response should contain the field "createdDateTime"
		And the response should contain the field "createdBy" with value "SYSTEM"
		And the response should contain the field "iac"
		And the response should contain the field "responses" with one element of the JSON array must be [{"inboundChannel":"PAPER","dateTime":
		And the response should contain the field "contact" with a null value


	# CTPA-770
  @distributedActionsCancelled
  Scenario: Cancel Distributed Actions
  	Then check "action.case" records in DB equal 0 for "caseid = 10"
  	# NOTE: Does not yet test distributed actions are cancelled only no new actions aganist case cannot be created


	@paperRespondedUI
	Scenario: Confirmed the UI reflects the paper response receipt
		Given the "Test" user has logged in using "Chrome"
    Then the user gets the addresses for postcode "TF15GJ"
    And selects case for address "15 GLEN COTTAGES"
    And the case state for "10" should be "INACTIONABLE"
    And navigates to the cases page for case "10"
    Then the case event should be "Paper Questionnaire Response"
		And the user logs out
