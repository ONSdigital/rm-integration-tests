# Author: Stephen Goddard 30/11/2016
# Keywords Summary : This feature file contains the scenario tests the follow up where field visits are sent.
#										 Detailed in: https://collaborate2.ons.gov.uk/confluence/pages/viewpage.action?pageId=3690875
#										 Note: Assumption that the DB has been loaded with seed data.
#
# Tasks Covered: CTPA-830 - Create Event from Field outcome
#
# Feature: List of scenarios: Reset survey date to trigger initial print file
#															Clean print file directory
#															Clean DB to pre test condition
#															Create Sample - Action plan which has 3 reminder letters
#															Test Cases Created - max number of cases
#															Generate PQ print file
#															Adjust action case date to simulate the passing of time
#															Test UI for case events
#
# Feature Tags: @followUp
#								@fieldVisit
#
# Scenario Tags: @fieldAdjustSurveyDate
#								 @fieldPrintFiles
#								 @fieldCleanEnvironment
#								 @fieldSample
#								 @fieldCases
#								 @fieldInitialFile
#								 @fieldInitialUI
#								 @fieldLetter1Date
#								 @fieldVisitDate
#								 @fieldLetter2Date
#								 @fieldLetter3Date
#								 @fieldLetter1File
#								 @fieldLetter2File
#								 @fieldLetter3File
#								 @fieldLetterUI

@followUp @fieldVisit 
Feature: Test successfull follow up field visit

	# Clean Environment -----

	@fieldAdjustSurveyDate
	Scenario: Reset survey date
		When the survey start and is reset to 20 days ahead for "2017 Test"
		Then the survey end and is reset to 50 days ahead for "2017 Test"


	@fieldPrintFiles
	Scenario: Clean folder of previous print files by coping all existing files to /previousTests
		When create test directory "/var/actionexporter-sftp/previousTests/"
		And the exit status should be 0
		Then move print files from "/var/actionexporter-sftp/" to "/var/actionexporter-sftp/previousTests/"
		And the exit status should be 0


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
		When I make the PUT call to the caseservice sample endpoint for sample id "7" for area "REGION" code "E12000005"
		Then the response status should be 200
		And the response should contain the field "name" with value "C1SO331D4E"
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
		And the response should contain the field "caseTypeId" with an integer value of 1
		And the response should contain the field "actionPlanMappingId" with an integer value of 1
		And the response should contain the field "createdDateTime"
		And the response should contain the field "createdBy" with value "SYSTEM"
		And the response should contain the field "iac"
		And the response should contain the field "responses" with one element of the JSON array must be []
		And the response should contain the field "contact" with a null value


	# Test Initial Print File Generation -----

	@fieldInitialFile
	Scenario: Test action plan has created paper questionnaire file for printer
		Given after a delay of 150 seconds
		Then get the contents of the file from "/var/actionexporter-sftp/" where the filename begins "ICL1_2003"
		And the exit status should be 0
		When and each line should start with an iac
		And and the contents should contain "|1000000000000001||||||11 VINEYARD ROAD|WELLINGTON|TELFORD|TF1 1HB"
		And and the contents should contain "|1000000000000002||||||13 VINEYARD ROAD|WELLINGTON|TELFORD|TF1 1HB"
		And and the contents should contain "|1000000000000003||||||15 VINEYARD ROAD|WELLINGTON|TELFORD|TF1 1HB"
		And and the contents should contain "|1000000000000004||||||17 VINEYARD ROAD|WELLINGTON|TELFORD|TF1 1HB"
		And and the contents should contain "|1000000000000005||||||21A VINEYARD ROAD|WELLINGTON|TELFORD|TF1 1HB"
		And and the contents should contain "|1000000000000006|||||WHITEHAVEN|26A VINEYARD ROAD|WELLINGTON|TELFORD|TF1 1HB"
		And and the contents should contain "|1000000000000007||||||28A VINEYARD ROAD|WELLINGTON|TELFORD|TF1 1HB"
		And and the contents should contain "|1000000000000008||||||7 VINEYARD ROAD|WELLINGTON|TELFORD|TF1 1HB"
		And and the contents should contain "|1000000000000009||||||9 VINEYARD ROAD|WELLINGTON|TELFORD|TF1 1HB"
		And and the contents should contain "|1000000000000010||||||19 VINEYARD ROAD|WELLINGTON|TELFORD|TF1 1HB"


	@fieldInitialUI
	Scenario: Confirmed the UI reflects the online response receipt
		Given the user has logged in using "Chrome"
    Then the user gets the addresses for postcode "TF11HB"
    And selects case for address "11 VINEYARD ROAD"
    And the case state should be "ACTIONABLE"
    And navigates to the cases page for case "1"
    Then the case event description should be "Print initial contact letter (English)"
		And the user logs out


	# Reminder letter 1 -----

	# CTPA-822
	@fieldLetter1Date
	Scenario: Post request to actionplans to create jobs for specified action plan - reminder letter 1
		Given the case start date is adjusted to trigger action plan
			| actionPlanId  | actiontypeid | total |
			| 1  						| 5   				 | 10		 |
		And after a delay of 90 seconds


	# Field Visit -----

	@fieldVisitDate
	Scenario: Post request to actionplans to create jobs for specified action plan - field visit
		Given the case start date is adjusted to trigger action plan
			| actionPlanId  | actiontypeid | total |
			| 1  						| 14   				 | 10		 |
		And after a delay of 90 seconds


	# Reminder letter 2 -----

	# CTPA-822
	@fieldLetter2Date
	Scenario: Post request to actionplans to create jobs for specified action plan - reminder letter 2
		Given the case start date is adjusted to trigger action plan
			| actionPlanId  | actiontypeid | total |
			| 1  						| 8   				 | 10		 |
		And after a delay of 90 seconds


	# Reminder letter 3 -----

	# CTPA-822
	@fieldLetter3Date
	Scenario: Post request to actionplans to create jobs for specified action plan - reminder letter 3
		Given the case start date is adjusted to trigger action plan
			| actionPlanId  | actiontypeid | total |
			| 1  						| 11   				 | 10		 |
		And after a delay of 400 seconds


	# CTPA-838
	@fieldLetter1File
	Scenario: Test action plan has created paper questionnaire file for printer
		Given after a delay of 90 seconds
		Then get the contents of the file from "/var/actionexporter-sftp/" where the filename begins "1RL1_0504"
		And the exit status should be 0
		When and each line should start with an iac
		And and the contents should contain "|1000000000000001||||||11 VINEYARD ROAD|WELLINGTON|TELFORD|TF1 1HB"
		And and the contents should contain "|1000000000000002||||||13 VINEYARD ROAD|WELLINGTON|TELFORD|TF1 1HB"
		And and the contents should contain "|1000000000000003||||||15 VINEYARD ROAD|WELLINGTON|TELFORD|TF1 1HB"
		And and the contents should contain "|1000000000000004||||||17 VINEYARD ROAD|WELLINGTON|TELFORD|TF1 1HB"
		And and the contents should contain "|1000000000000005||||||21A VINEYARD ROAD|WELLINGTON|TELFORD|TF1 1HB"
		And and the contents should contain "|1000000000000006|||||WHITEHAVEN|26A VINEYARD ROAD|WELLINGTON|TELFORD|TF1 1HB"
		And and the contents should contain "|1000000000000007||||||28A VINEYARD ROAD|WELLINGTON|TELFORD|TF1 1HB"
		And and the contents should contain "|1000000000000008||||||7 VINEYARD ROAD|WELLINGTON|TELFORD|TF1 1HB"
		And and the contents should contain "|1000000000000009||||||9 VINEYARD ROAD|WELLINGTON|TELFORD|TF1 1HB"
		And and the contents should contain "|1000000000000010||||||19 VINEYARD ROAD|WELLINGTON|TELFORD|TF1 1HB"

	# CTPA-830
	# How to test field visit?

	# CTPA-838
	@fieldLetter2File
	Scenario: Test action plan has created paper questionnaire file for printer
		Given after a delay of 90 seconds
		Then get the contents of the file from "/var/actionexporter-sftp/" where the filename begins "2RL1_1804"
		And the exit status should be 0
		When and each line should start with an iac
		And and the contents should contain "|1000000000000001||||||11 VINEYARD ROAD|WELLINGTON|TELFORD|TF1 1HB"
		And and the contents should contain "|1000000000000002||||||13 VINEYARD ROAD|WELLINGTON|TELFORD|TF1 1HB"
		And and the contents should contain "|1000000000000003||||||15 VINEYARD ROAD|WELLINGTON|TELFORD|TF1 1HB"
		And and the contents should contain "|1000000000000004||||||17 VINEYARD ROAD|WELLINGTON|TELFORD|TF1 1HB"
		And and the contents should contain "|1000000000000005||||||21A VINEYARD ROAD|WELLINGTON|TELFORD|TF1 1HB"
		And and the contents should contain "|1000000000000006|||||WHITEHAVEN|26A VINEYARD ROAD|WELLINGTON|TELFORD|TF1 1HB"
		And and the contents should contain "|1000000000000007||||||28A VINEYARD ROAD|WELLINGTON|TELFORD|TF1 1HB"
		And and the contents should contain "|1000000000000008||||||7 VINEYARD ROAD|WELLINGTON|TELFORD|TF1 1HB"
		And and the contents should contain "|1000000000000009||||||9 VINEYARD ROAD|WELLINGTON|TELFORD|TF1 1HB"
		And and the contents should contain "|1000000000000010||||||19 VINEYARD ROAD|WELLINGTON|TELFORD|TF1 1HB"

	# CTPA-838
	@fieldLetter3File
	Scenario: Test action plan has created paper questionnaire file for printer
		Given after a delay of 90 seconds
		Then get the contents of the file from "/var/actionexporter-sftp/" where the filename begins "3RL1_2604"
		And the exit status should be 0
		When and each line should start with an iac
		And and the contents should contain "|1000000000000001||||||11 VINEYARD ROAD|WELLINGTON|TELFORD|TF1 1HB"
		And and the contents should contain "|1000000000000002||||||13 VINEYARD ROAD|WELLINGTON|TELFORD|TF1 1HB"
		And and the contents should contain "|1000000000000003||||||15 VINEYARD ROAD|WELLINGTON|TELFORD|TF1 1HB"
		And and the contents should contain "|1000000000000004||||||17 VINEYARD ROAD|WELLINGTON|TELFORD|TF1 1HB"
		And and the contents should contain "|1000000000000005||||||21A VINEYARD ROAD|WELLINGTON|TELFORD|TF1 1HB"
		And and the contents should contain "|1000000000000006|||||WHITEHAVEN|26A VINEYARD ROAD|WELLINGTON|TELFORD|TF1 1HB"
		And and the contents should contain "|1000000000000007||||||28A VINEYARD ROAD|WELLINGTON|TELFORD|TF1 1HB"
		And and the contents should contain "|1000000000000008||||||7 VINEYARD ROAD|WELLINGTON|TELFORD|TF1 1HB"
		And and the contents should contain "|1000000000000009||||||9 VINEYARD ROAD|WELLINGTON|TELFORD|TF1 1HB"
		And and the contents should contain "|1000000000000010||||||19 VINEYARD ROAD|WELLINGTON|TELFORD|TF1 1HB"


	@fieldLetterUI
	Scenario: Confirmed the UI reflects the online response receipt
		Given the user has logged in using "Chrome"
    Then the user gets the addresses for postcode "TF11HB"
    And selects case for address "11 VINEYARD ROAD"
    And the case state should be "ACTIONABLE"
    And navigates to the cases page for case "1"
    Then the case event description should contain "Print reminder letter 1 (English)"
    And the case event description should contain "Create Household Visit"
    And the case event description should contain "Print reminder letter 2 (English)"
    And the case event description should contain "Print reminder letter 3 (English)"
		And the user logs out
