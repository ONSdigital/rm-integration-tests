# Author: Stephen Goddard 12/10/2016
# Keywords Summary : This feature file contains the scenario tests individual paper response.
#										 Detailed in: https://collaborate2.ons.gov.uk/confluence/pages/viewpage.action?pageId=3690875
#										 Note: Assumption that the DB has been loaded with seed data.
#
# Tasks Covered: CTPA-558 Helpline request
#								 CTPA-760 Process Service Request
#								 CTPA-522 Create new cases
#								 CTPA-524 Change Case State
#								 CTPA-526 Run Action Plan
#								 CTPA-579 Generate PQ Print File
#													Create Event
#								 CTPA-580 Send File To Printer
#								 CTPA-539 Receive Paper Response
#								 CTPA-537 Capture Mode
#								 CTPA-524 Change Case State
#								 CTPA-770 Cancel Distribute Actions
#
# Feature: List of scenarios: Adjust survey start and end date
#															Clean print file directory
#															Clean DB to pre test condition
#															Create Sample
#															Test Cases Created - max number of cases
#															Helpline UI request individual paper
#															Create Cases
#															UI case state confirm Actionable
#															UI case event confirm Created
#															Run Action Plan
#															Generate Notify Print File
#															UI printer case event confirm Created
#															Receive Successfully Paper Response
#															Distributed Actions Cancelled
#															UI case event confirm QuestionnaireResponded
#
# Feature Tags: @individualPaperResponse
#								@additionalIndividualResponse
#
# Scenario Tags: @indAdjustSurveyDate
#								 @cleanPrintFiles
#								 @indCleanEnvironment
#								 @createIndPaperSample
#								 @createIndPaperCases
#								 @requestPapeerIndividualUI
#								 @createIndCases
#								 @generateIndIAC
#								 @indActionableUI
#								 @indPrintAction
#								 @indPrintFile
#								 @indPrinterUI
#								 @paperResponseRceived
#								 @distributedActionsCancelled
#								 @paperRespondedUI

@individualPaperResponse @additionalIndividualResponse
Feature: Test successfull individual paper response

	# Clean Environment -----
	@indAdjustSurveyDate
	Scenario: Reset survey date
		When the survey start and is reset to 20 days ahead for "2017 Test"
		Then the survey end and is reset to 50 days ahead for "2017 Test"


	@cleanPrintFiles
	Scenario: Clean folder of previous print files by coping all existing files to /previousTests
		When create test directory "/var/actionexporter-sftp/previousTests/"
		And the exit status should be 0
		Then move print files from "/var/actionexporter-sftp/" to "/var/actionexporter-sftp/previousTests/"
		And the exit status should be 0


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
	@createIndPaperSample
	Scenario: Put request for sample to create online cases for the specified sample id
		When I make the PUT call to the caseservice sample endpoint for sample id "15" for area "REGION" code "E12000005"
		Then the response status should be 200
		And the response should contain the field "name" with value "C2SP331E"
		And the response should contain the field "survey" with value "2017 TEST"
		And check "casesvc.caseevent" records in DB equal 10


	# CTPA-709
	@createIndPaperCases
	Scenario: Get request to case for highest expected case id
		Given after a delay of 30 seconds
		When I make the GET call to the caseservice cases endpoint for case "10"
		Then the response status should be 200
		And the response should contain the field "caseId" with an integer value of 10
		And the response should contain the field "caseGroupId" with an integer value of 10
		And the response should contain the field "caseRef" with value "1000000000000010"
		And the response should contain the field "state" with value "ACTIONABLE"
		And the response should contain the field "caseTypeId" with an integer value of 9
		And the response should contain the field "actionPlanMappingId" with an integer value of 9
		And the response should contain the field "createdDateTime"
		And the response should contain the field "createdBy" with value "SYSTEM"
		And the response should contain the field "iac"
		And the response should contain the field "responses" with one element of the JSON array must be []
		And the response should contain the field "contact" with a null value


	# Individual Paper Creation -----

	# CTPA-558
	# CTPA-760
	@requestPaperIndividualUI
	Scenario: Ui request for individual paper request
		Given the user has logged in using "Chrome"
    When the user gets the addresses for postcode "TF13LG"
    And selects case for address "20 EMRAL RISE"
    And the case state should be "ACTIONABLE"
    And navigates to the cases page for case "10"
    And the user requests an individual request for
      | Paper | Lady | Integration | Tester |  | 07777123456 | |
    And the user logs out


	# CTPA-522
	@createIndCases
	Scenario: Get request to case newly created case
		Given after a delay of 30 seconds
		When I make the GET call to the caseservice cases endpoint for case "11"
		Then the response status should be 200
		And the response should contain the field "caseId" with an integer value of 11
		And the response should contain the field "caseGroupId" with an integer value of 10
		And the response should contain the field "caseRef" with value "1000000000000011"
		And the response should contain the field "state" with value "ACTIONABLE"
		And the response should contain the field "caseTypeId" with an integer value of 23
		And the response should contain the field "actionPlanMappingId" with an integer value of 45
		And the response should contain the field "createdDateTime"
		And the response should contain the field "createdBy" with value "integration.tester"
		And the response should contain the field "iac"
		And the response should contain the field "responses" with one element of the JSON array must be []
		And the response should contain the field "contact" with list value "{title=lady, forename=Integration, surname=Tester, phoneNumber=07777123456, emailAddress=null}"


	# CTPA-673
	@generateIndIAC
	Scenario: Each case has a unique IAC assigned to it and in ACTIONABLE state
		When check "casesvc.case" distinct records in DB equal 11 for "iac" where "state = 'ACTIONABLE'"
		And check "casesvc.case" records in DB equal 10 for "state = 'ACTIONABLE' AND casetypeid = 9"
		And check "casesvc.case" records in DB equal 1 for "state = 'ACTIONABLE' AND casetypeid = 23"
		And check "action.case" records in DB equal 1 for "caseid = 11"


	# CTPA-524
	@indActionableUI
	Scenario: Tests that the case is in a state of ACTIONABLE
    Given the user has logged in using "Chrome"
    When the user gets the addresses for postcode "TF13LG"
    And selects case for address "20 EMRAL RISE"
    And the case state should be "ACTIONABLE"
    And navigates to the cases page for case "11"
    And the user logs out


	# Individual Paper Print File Action -----

	#	CTPA-526
	#	CTPA-579
	#	CTPA-580
	@indPrintFile
	Scenario: Test action plan has created paper file for printer
		Given after a delay of 150 seconds
		Then get the contents of the file from "/var/actionexporter-sftp/" where the filename begins "I1S_OR"
		And the exit status should be 0
		When and each line should start with an iac
		And and the contents should contain "|1000000000000011||lady|Integration|Tester||20 EMRAL RISE|DOTHILL|TELFORD|TF1 3LG"


	@indPrinterUI
  Scenario: This scenario tests that the case event created
    Given the user has logged in using "Chrome"
    When the user gets the addresses for postcode "TF13LG"
    And selects case for address "20 EMRAL RISE"
    And the case state should be "ACTIONABLE"
    And navigates to the cases page for case "11"
    Then the case event should be "Action Created"
    And the case event description should be "Print Individual paper questionnaire (English with sexual ID)"
    And the user logs out


	# Individual Paper Response -----

	# CTPA-539
	# CTPA-537
	# CTPA-524
	@paperResponseRceived
  Scenario: Test the system has successfully registered an paper response
  	Given I make the POST call to the SDX Gateway paper receipt for caseref "1000000000000011"
		And the response status should be 201
		When after a delay of 30 seconds
		Then I make the GET call to the caseservice cases endpoint for case "11"
		And the response status should be 200
		And the response should contain the field "caseId" with an integer value of 11
		And the response should contain the field "caseGroupId" with an integer value of 10
		And the response should contain the field "caseRef" with value "1000000000000011"
		And the response should contain the field "state" with value "INACTIONABLE"
		And the response should contain the field "caseTypeId" with an integer value of 23
		And the response should contain the field "actionPlanMappingId" with an integer value of 45
		And the response should contain the field "createdDateTime"
		And the response should contain the field "createdBy" with value "integration.tester"
		And the response should contain the field "iac"
		And the response should contain the field "responses" with one element of the JSON array must be [{"inboundChannel":"PAPER","dateTime":
		And the response should contain the field "contact" with list value "{title=lady, forename=Integration, surname=Tester, phoneNumber=07777123456, emailAddress=null}"


	#	CTPA-770
	@distributedActionsCancelled
  Scenario: Cancel Distributed Actions
  	Then check "action.case" records in DB equal 0 for "caseid = 11"
  	# NOTE: Does not yet test distributed actions are cancelled only no new actions aganist case cannot be created


	@paperRespondedUI
	Scenario: Confirmed the UI reflects the paper response receipt
		Given the user has logged in using "Chrome"
    Then the user gets the addresses for postcode "TF13LG"
    And selects case for address "20 EMRAL RISE"
    And the case state for "11" and "INACTIONABLE"
    And navigates to the cases page for case "11"
    Then the case event should be "Paper Questionnaire Response"
		And the user logs out
