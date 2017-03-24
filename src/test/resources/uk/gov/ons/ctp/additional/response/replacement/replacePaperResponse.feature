# Author: Stephen Goddard 22/11/2016
# Keywords Summary : This feature file contains the scenario tests for replacement paper response HH and individual.
#										 Detailed in: https://collaborate2.ons.gov.uk/confluence/pages/viewpage.action?pageId=3690875
#										 Note: Assumption that the DB has been loaded with seed data.
#
# Tasks Covered: CTPA-813 Load the HH & IND Replacement Set Up Data (England)
#								 CTPA-814 Load the HH & IND Replacement Action Plans (England)
#								 CTPA-867 Load the Set Up Data and Action Plans for Welsh Samples
#								 CTPA-756 Process service requests from the UI for replacement IAC's
#								 CTPA-675 Deactivate existing Internet Access Codes when replacement ones are issued.
#								 CTPA-815 Create Replacement HH and IND cases (England)
#								 CTPA-826 Generate Print Files
#								 CTPA-838 Post print file to SFTP
#								 CTPA-539 Receive Paper Response
#								 CTPA-537 Capture Mode
#								 CTPA-770 Cancel Distribute Actions
#
# Feature: List of scenarios: Ajust survey start and end date
#															Clean DB to pre test condition
#															Create Sample
#															Helpline UI request individual online and validate case
#															Helpline UI request for HH and individual replacement IAC
#															Confirm old cases have been made inactionable
#															Confirm old IAC and no longer valid
#															Confirm new cases have been create and are actionable
#															Confirm new cases have an active IAC
#															Create Event - currently place holder as nice to have for 2017 test
#															Receive Successfully Online Response
#															Distributed Actions Cancelled
#															Confirm replacement IAC are now deactivated
#															UI case event confirm QuestionnaireResponded and cases inactionable
#
# Feature Tags: @replaceOnlineResponse
#								@additionalReplacementResponse
#
# Scenario Tags: @replaceAdjustSurveyDate
#								 @cleanPrintFiles
#								 @replaceCleanEnvironment
#								 @createReplacementSample
#								 @requestIndividualUI
#								 @checkIndividualCase
#								 @checkGeneratedIAC
#								 @requestHHReplaceUI
#								 @requestIndividualReplaceUI
#								 @generateReplaceIAC
#								 @deactiveHHCase
#								 @deactivateIndividualCase
#								 @deactivateHHCase
#								 @deactivateIndividualIAC
#								 @activateHHCase
#								 @activateIndividualCase
#								 @replaceValidateIAC
#								 @createEventPlaceHolder
#								 @replacePaperResponseReceived
#								 @replaceDistributedActionsCancelled
#								 @replaceValidateIAC
#								 @replacePaperRespondedUI

@replacePaperResponse @additionalReplacementResponse
Feature: Test successfull replacements for HH and individual paper response

	# Clean Environment -----
	
	@replaceAdjustSurveyDate
	Scenario: Reset survey date
		When the survey start and is reset to 20 days ahead for "2017 Test"
		Then the survey end and is reset to 50 days ahead for "2017 Test"


	@cleanPrintFiles
	Scenario: Clean folder of previous print files by coping all existing files to /previousTests
		When create test directory "/var/actionexporter-sftp/previousTests/"
		And the exit status should be 0
		Then move print files from "/var/actionexporter-sftp/" to "/var/actionexporter-sftp/previousTests/"
		And the exit status should be 0


  @replaceCleanEnvironment
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

	@createReplacementSample
	Scenario: Put request for sample to create paper cases for the specified sample id
		When I make the PUT call to the caseservice sample endpoint for sample id "15" for area "REGION" code "E12000005"
		Then the response status should be 200
		And the response should contain the field "name" with value "C2SP331E"
		And the response should contain the field "survey" with value "2017 TEST"
		And check "casesvc.caseevent" records in DB equal 10


	Scenario: Delay	to allow the system to process cases
		Given after a delay of 30 seconds


	# Create an Individual Online Case -----							 

	@requestIndividualUI
	Scenario: Ui request for individual paper request
		Given the "Test" user has logged in using "Test"
    When the user gets the addresses for postcode "TF13LG"
    And selects case for address "11 EMRAL RISE"
    And the case state for "1" should be "ACTIONABLE"
    And navigates to the cases page for case "1"
    And the user requests an individual request for
      | Paper | Mr | Integration | Tester |  | 07777123456 | |
    And the user logs out


	@checkIndividualCase
	Scenario: Get request to case newly created case
		Given after a delay of 30 seconds
		When I make the GET call to the caseservice cases endpoint for case "11"
		Then the response status should be 200
		And the response should contain the field "caseId" with an integer value of 11
		And the response should contain the field "caseGroupId" with an integer value of 1
		And the response should contain the field "caseRef" with value "1000000000000011"
		And the response should contain the field "state" with value "ACTIONABLE"
		And the response should contain the field "caseTypeId" with an integer value of 23
		And the response should contain the field "actionPlanMappingId" with an integer value of 45
		And the response should contain the field "createdDateTime"
		And the response should contain the field "createdBy" with value "integration.tester"
		And the response should contain the field "iac"
		And the response should contain the field "responses" with one element of the JSON array must be []
		And the response should contain the field "contact" with list value "{title=mr, forename=Integration, surname=Tester, phoneNumber=07777123456, emailAddress=null}"


	@checkGeneratedIAC
	Scenario: Each case has a unique IAC assigned to it and in ACTIONABLE state
		When check "casesvc.case" distinct records in DB equal 11 for "iac" where "state = 'ACTIONABLE'"
		And check "casesvc.case" records in DB equal 10 for "state = 'ACTIONABLE' AND casetypeid = 9"
		And check "casesvc.case" records in DB equal 1 for "state = 'ACTIONABLE' AND casetypeid = 23"
		And check "action.case" records in DB equal 1 for "caseid = 11"


	# HH and Individual Request Replacement IAC -----

	# CTPA-813
	# CTPA-814
	# CTPA-867
	# CTPA-756
	@requestHHReplaceUI @pomtest
	Scenario: Ui request for HH replacement IAC
		Given the "Test" user has logged in using "Chrome"
    When the user gets the addresses for postcode "TF13LG"
    And selects case for address "20 EMRAL RISE"
    And the case state for "10" should be "ACTIONABLE"
    And navigates to the cases page for case "10"
    And the user requests a replacement paper form
      | Paper | Capt. | Integration | Tester |  | 07777123456 | |
    And the user logs out

  @requestIndividualReplaceUI
	Scenario: Ui request for individual replacement IAC
		Given the "Test" user has logged in using "Chrome"
    When the user gets the addresses for postcode "TF13LG"
    And selects case for address "11 EMRAL RISE"
    And the case state for "11" should be "ACTIONABLE"
    And navigates to the cases page for case "11"
		And the user requests a replacement paper form
      | Paper | Dr | Integration | Tester |  | 07777123456 | |
    And the user logs out


	# CTPA-675
	@generateReplaceIAC
	Scenario: Check two cases have changed to INACTIONABLE and removed from action.case
		Given after a delay of 30 seconds
		When check "casesvc.case" records in DB equal 2 for "state = 'INACTIONABLE'"
		And check "action.case" records in DB equal 0 for "caseid = 10"
		And check "action.case" records in DB equal 0 for "caseid = 11"


	# Confirm Old Cases Have Been Deactivated

	# CTPA-675
	@deactiveHHCase
	Scenario: Confirm old HH case has been deactivated
		When I make the GET call to the caseservice cases endpoint for case "10"
		Then the response status should be 200
		And the response should contain the field "caseId" with an integer value of 10
		And the response should contain the field "caseGroupId" with an integer value of 10
		And the response should contain the field "caseRef" with value "1000000000000010"
		And the response should contain the field "state" with value "INACTIONABLE"
		And the response should contain the field "caseTypeId" with an integer value of 9
		And the response should contain the field "actionPlanMappingId" with an integer value of 9
		And the response should contain the field "createdDateTime"
		And the response should contain the field "createdBy" with value "SYSTEM"
		And the response should contain the field "iac"
		And the response should contain the field "responses" with one element of the JSON array must be []
		And the response should contain the field "contact" with a null value

	@deactivateIndividualCase
	Scenario: Confirm old individual case has been deactivated
		When I make the GET call to the caseservice cases endpoint for case "11"
		Then the response status should be 200
		And the response should contain the field "caseId" with an integer value of 11
		And the response should contain the field "caseGroupId" with an integer value of 1
		And the response should contain the field "caseRef" with value "1000000000000011"
		And the response should contain the field "state" with value "INACTIONABLE"
		And the response should contain the field "caseTypeId" with an integer value of 23
		And the response should contain the field "actionPlanMappingId" with an integer value of 45
		And the response should contain the field "createdDateTime"
		And the response should contain the field "createdBy" with value "integration.tester"
		And the response should contain the field "iac"
		And the response should contain the field "responses" with one element of the JSON array must be []
		And the response should contain the field "contact" with list value "{title=mr, forename=Integration, surname=Tester, phoneNumber=07777123456, emailAddress=null}"


	# Confirm Old Case IAC Have Been Deactivated

	#	CTPA-675
	@deactivateHHCase
  Scenario: Confirm old HH case IAC has been deactivated
  	Given I make the GET call to the caseservice cases endpoint for case "10"
  	And the response status should be 200
  	And the response should contain the field "iac"
  	When I make the GET call to the IAC service endpoint
  	And the response status should be 200
  	And the response should contain the field "caseId" with an integer value of 10
  	And the response should contain the field "caseRef" with value "1000000000000010"
  	And the response should contain the field "iac"
  	And the response should contain the field "active" with boolean value "true"
  	And the response should contain the field "questionSet" with value "H1S"

	@deactivateIndividualIAC
  Scenario: Confirm old individual case IAC has been deactivated
  	Given I make the GET call to the caseservice cases endpoint for case "11"
  	And the response status should be 200
  	And the response should contain the field "iac"
  	When I make the GET call to the IAC service endpoint
  	And the response status should be 200
  	And the response should contain the field "caseId" with an integer value of 11
  	And the response should contain the field "caseRef" with value "1000000000000011"
  	And the response should contain the field "iac"
  	And the response should contain the field "active" with boolean value "true"
  	And the response should contain the field "questionSet" with value "I1S"


	# Confirm New Cases Have Been Activated

	# CTPA-815
	# CTPA-673
	@activateHHCase
	Scenario: Get request to case newly created case
		When I make the GET call to the caseservice cases endpoint for case "12"
		Then the response status should be 200
		And the response should contain the field "caseId" with an integer value of 12
		And the response should contain the field "caseGroupId" with an integer value of 10
		And the response should contain the field "caseRef" with value "1000000000000012"
		And the response should contain the field "state" with value "ACTIONABLE"
		And the response should contain the field "caseTypeId" with an integer value of 9
		And the response should contain the field "actionPlanMappingId" with an integer value of 31
		And the response should contain the field "createdDateTime"
		And the response should contain the field "createdBy" with value "integration.tester"
		And the response should contain the field "iac"
		And the response should contain the field "responses" with one element of the JSON array must be []
		And the response should contain the field "contact" with list value "{title=capt, forename=Integration, surname=Tester, phoneNumber=07777123456, emailAddress=null}"

	@activateIndividualCase
	Scenario: Get request to case newly created case
		When I make the GET call to the caseservice cases endpoint for case "13"
		Then the response status should be 200
		And the response should contain the field "caseId" with an integer value of 13
		And the response should contain the field "caseGroupId" with an integer value of 1
		And the response should contain the field "caseRef" with value "1000000000000013"
		And the response should contain the field "state" with value "ACTIONABLE"
		And the response should contain the field "caseTypeId" with an integer value of 23
		And the response should contain the field "actionPlanMappingId" with an integer value of 45
		And the response should contain the field "createdDateTime"
		And the response should contain the field "createdBy" with value "integration.tester"
		And the response should contain the field "iac"
		And the response should contain the field "responses" with one element of the JSON array must be []
		And the response should contain the field "contact" with list value "{title=dr, forename=Integration, surname=Tester, phoneNumber=07777123456, emailAddress=null}"


	# Confirm New Case IAC Is Activated

	#	CTPA-673
	@replaceValidateIAC
  Scenario: Validate IAC and confirm the case iac is active
  	Given I make the GET call to the caseservice cases endpoint for case "12"
  	And the response status should be 200
  	And the response should contain the field "iac"
  	When I make the GET call to the IAC service endpoint
  	And the response status should be 200
  	And the response should contain the field "caseId" with an integer value of 12
  	And the response should contain the field "caseRef" with value "1000000000000012"
  	And the response should contain the field "iac"
  	And the response should contain the field "active" with boolean value "true"
  	And the response should contain the field "questionSet" with value "H1S"

	@replaceValidateIAC
  Scenario: Validate IAC and confirm the case iac is active
  	Given I make the GET call to the caseservice cases endpoint for case "13"
  	And the response status should be 200
  	And the response should contain the field "iac"
  	When I make the GET call to the IAC service endpoint
  	And the response status should be 200
  	And the response should contain the field "caseId" with an integer value of 13
  	And the response should contain the field "caseRef" with value "1000000000000013"
  	And the response should contain the field "iac"
  	And the response should contain the field "active" with boolean value "true"
  	And the response should contain the field "questionSet" with value "I1S"


	@replacePaperRespondedUI
	Scenario: Confirmed the UI reflects the online response receipt
		Given the "Test" user has logged in using "Chrome"
    Then the user gets the addresses for postcode "TF13LG"
    And selects case for address "20 EMRAL RISE"
    And the case state for "12" should be "ACTIONABLE"
    And navigates to the cases page for case "12"
    Then the case event category should contain "Access Code Authenticated By Respondent"
		And the user logs out
		
	@replacePaperRespondedUI
	Scenario: Confirmed the UI reflects the online response receipt
		Given the "Test" user has logged in using "Chrome"
    Then the user gets the addresses for postcode "TF13LG"
    And selects case for address "11 EMRAL RISE"
    And the case state for "13" should be "ACTIONABLE"
    And navigates to the cases page for case "13"
    Then the case event category should contain "Access Code Authenticated By Respondent"
		And the user logs out


	# Replacement Paper Print File Action -----

	#	CTPA-526
	#	CTPA-579
	#	CTPA-580
	@indPrintFile
	Scenario: Test action plan has created paper file for printer
		Given after a delay of 180 seconds
		Then get the contents of the file from "/var/actionexporter-sftp/" where the filename begins "H1S_OR"
		And the exit status should be 0
		When and each line should start with an iac
		And and the contents should contain "|1000000000000012||capt|Integration|Tester||20 EMRAL RISE|DOTHILL|TELFORD|TF1 3LG"
		Then get the contents of the file from "/var/actionexporter-sftp/" where the filename begins "I1S_OR"
		And the exit status should be 0
		When and each line should start with an iac
		And and the contents should contain "|1000000000000013||dr|Integration|Tester||11 EMRAL RISE|DOTHILL|TELFORD|TF1 3LG"


	# Online Response -----

	# CTPA-538
	# CTPA-537
	@replacePaperResponseReceived
  Scenario: Test the system has successfully registered an online response
  	Given I make the POST call to the SDX Gateway paper receipt for caseref "1000000000000012"
		And the response status should be 201
		When after a delay of 30 seconds
		Then I make the GET call to the caseservice cases endpoint for case "12"
		And the response status should be 200
		And the response should contain the field "caseId" with an integer value of 12
		And the response should contain the field "caseGroupId" with an integer value of 10
		And the response should contain the field "caseRef" with value "1000000000000012"
		And the response should contain the field "state" with value "INACTIONABLE"
		And the response should contain the field "caseTypeId" with an integer value of 9
		And the response should contain the field "actionPlanMappingId" with an integer value of 31
		And the response should contain the field "createdDateTime"
		And the response should contain the field "createdBy" with value "integration.tester"
		And the response should contain the field "iac"
		And the response should contain the field "responses" with one element of the JSON array must be [{"inboundChannel":"PAPER","dateTime":
		And the response should contain the field "contact" with list value "{title=capt, forename=Integration, surname=Tester, phoneNumber=07777123456, emailAddress=null}"

	@replacePaperResponseReceived
  Scenario: Test the system has successfully registered an online response
  	Given I make the POST call to the SDX Gateway paper receipt for caseref "1000000000000013"
		And the response status should be 201
		When after a delay of 30 seconds
		Then I make the GET call to the caseservice cases endpoint for case "13"
		And the response status should be 200
		And the response should contain the field "caseId" with an integer value of 13
		And the response should contain the field "caseGroupId" with an integer value of 1
		And the response should contain the field "caseRef" with value "1000000000000013"
		And the response should contain the field "state" with value "INACTIONABLE"
		And the response should contain the field "caseTypeId" with an integer value of 23
		And the response should contain the field "actionPlanMappingId" with an integer value of 45
		And the response should contain the field "createdDateTime"
		And the response should contain the field "createdBy" with value "integration.tester"
		And the response should contain the field "iac"
		And the response should contain the field "responses" with one element of the JSON array must be [{"inboundChannel":"PAPER","dateTime":
		And the response should contain the field "contact" with list value "{title=dr, forename=Integration, surname=Tester, phoneNumber=07777123456, emailAddress=null}"


	#	CTPA-770
	@replaceDistributedActionsCancelled
  Scenario: Cancel Distributed Actions
  	Then check "action.case" records in DB equal 0 for "caseid = 12"
  	And check "action.case" records in DB equal 0 for "caseid = 13"
  	# NOTE: Does not yet test distributed actions are cancelled only no new actions aganist case cannot be created


	@replacePaperRespondedUI
	Scenario: Confirmed the UI reflects the online response receipt
		Given the "Test" user has logged in using "Chrome"
    Then the user gets the addresses for postcode "TF13LG"
    And selects case for address "20 EMRAL RISE"
    And the case state for "12" should be "INACTIONABLE"
    And navigates to the cases page for case "12"
    Then the case event category should contain "Paper Questionnaire Response"
		And the user logs out
		
	@replacePaperRespondedUI
	Scenario: Confirmed the UI reflects the online response receipt
		Given the "Test" user has logged in using "Chrome"
    Then the user gets the addresses for postcode "TF13LG"
    And selects case for address "11 EMRAL RISE"
    And the case state for "13" should be "INACTIONABLE"
    And navigates to the cases page for case "13"
    Then the case event category should contain "Paper Questionnaire Response"
		And the user logs out


  @replaceValidateIAC
  Scenario: Validate IAC and confirm the case iac is active
  	Given I make the GET call to the caseservice cases endpoint for case "12"
  	And the response status should be 200
  	And the response should contain the field "iac"
  	When I make the GET call to the IAC service endpoint
  	And the response status should be 200
  	And the response should contain the field "caseId" with an integer value of 12
  	And the response should contain the field "caseRef" with value "1000000000000012"
  	And the response should contain the field "iac"
  	And the response should contain the field "active" with boolean value "true"
  	And the response should contain the field "questionSet" with value "H1S"
 
	@replaceValidateIAC
  Scenario: Validate IAC and confirm the case iac is active
  	Given I make the GET call to the caseservice cases endpoint for case "13"
  	And the response status should be 200
  	And the response should contain the field "iac"
  	When I make the GET call to the IAC service endpoint
  	And the response status should be 200
  	And the response should contain the field "caseId" with an integer value of 13
  	And the response should contain the field "caseRef" with value "1000000000000013"
  	And the response should contain the field "iac"
  	And the response should contain the field "active" with boolean value "true"
  	And the response should contain the field "questionSet" with value "I1S"


	@replacePaperRespondedUI
	Scenario: Confirmed the UI reflects the online response receipt
		Given the "Test" user has logged in using "Chrome"
    Then the user gets the addresses for postcode "TF13LG"
    And selects case for address "20 EMRAL RISE"
    And the case state for "12" should be "INACTIONABLE"
    And navigates to the cases page for case "12"
    Then the case event category should contain "Access Code Authenticated By Respondent"
		And the user logs out
		
	@replacePaperRespondedUI
	Scenario: Confirmed the UI reflects the online response receipt
		Given the "Test" user has logged in using "Chrome"
    Then the user gets the addresses for postcode "TF13LG"
    And selects case for address "11 EMRAL RISE"
    And the case state for "13" should be "INACTIONABLE"
    And navigates to the cases page for case "13"
    Then the case event category should contain "Access Code Authenticated By Respondent"
		And the user logs out