# Author: Gareth Turner 21/12/2016
# Keywords Summary : This feature file contains the scenario for initial set up and folows the action plan for no response
#										 Detailed in: https://collaborate2.ons.gov.uk/confluence/pages/viewpage.action?spaceKey=SDC&title=Test+Scenarios
#										 Note: Assumption that the DB has been loaded with seed data.
#
# Tasks Covered: CTPA-1014 - initial set up and follow action plans for no response test
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
# Feature Tags: @sampleScenarios 
#								@setUpHOTEL
#
# Scenario Tags: @initialSetUpAdjustSurveyDate
#								 @initialSetUpPrintFiles
#								 @initialSetUpCleanEnvironment
#								 @initialSetUpSample
#								 @initialSetUpCases
#								 @initialSetUpInitialFile
#								 @initialSetUpInitialUI


@sampleScenarios @setUpHOTEL
Feature: Initial set up HOTEL

	# Clean Environment -----

	@initialSetUpAdjustSurveyDate
	Scenario: Reset survey date
		When the survey start and is reset to 20 days ahead for "2017 Test"
		Then the survey end and is reset to 50 days ahead for "2017 Test"


	@initialSetUpPrintFiles
	Scenario: Clean folder of previous print files by coping all existing files to /previousTests
		When create test directory "/var/actionexporter-sftp/previousTests/"
		And the exit status should be 0
		Then move print files from "/var/actionexporter-sftp/" to "/var/actionexporter-sftp/previousTests/"
		And the exit status should be 0


  @initialSetUpCleanEnvironment
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


	# Hotel Sample Creation -----

	@initialSetUpSample
	Scenario: Put request for sample to create paper cases for the specified sample id
		When I make the PUT call to the caseservice sample endpoint for sample id "24" for area "REGION" code "E12000006"
		Then the response status should be 200
		And the response should contain the field "name" with value "HOTEL"
		And the response should contain the field "survey" with value "2017 TEST"
		And the response should contain the field "sampleCaseTypes" with one element of the JSON array must be {"caseTypeId":30,"respondentType":"C"}
		And check "casesvc.caseevent" records in DB equal 10


	@initialSetUpCases
	Scenario: Get request to case for highest expected case id
		Given after a delay of 30 seconds
		When I make the GET call to the caseservice cases endpoint for case "10"
		Then the response status should be 200
		And the response should contain the field "caseId" with an integer value of 10
		And the response should contain the field "caseGroupId" with an integer value of 10
		And the response should contain the field "caseRef" with value "1000000000000010"
		And the response should contain the field "state" with value "ACTIONABLE"
		And the response should contain the field "caseTypeId" with an integer value of 30
		And the response should contain the field "actionPlanMappingId" with an integer value of 83
		And the response should contain the field "createdDateTime"
		And the response should contain the field "createdBy" with value "SYSTEM"
		And the response should contain the field "iac"
		And the response should contain the field "responses" with one element of the JSON array must be []
		And the response should contain the field "contact" with a null value

		
	@initialSetUpInitialFile
	Scenario: Test action plan has created paper questionnaire file for printer
		Given after a delay of 150 seconds
		When get the contents of the file from "/var/actionexporter-sftp/" where the filename begins "ICLH1_2003"
		And the exit status should be 0
		Then and each line should start with an iac
		And and the contents should contain "|THE DANESCOURT HOTEL|||||10 STATION ROAD|||FY4 1BE"
		And and the contents should contain "|1000000000000002|MORRISY HOTEL|||||17 DEAN STREET|||FY4 1AU"
		And and the contents should contain "|1000000000000006|VIKING HOTEL||||479-483|PROMENADE|||FY4 1AX"
		And and the contents should contain "|1000000000000003|HILLBRE HOTEL|||||23 DEAN STREET|||FY4 1AU"
		And and the contents should contain "|1000000000000004|BEVERLEY HOTEL|||||25 DEAN STREET|||FY4 1AU"
		And and the contents should contain "|1000000000000007|QUEENS HOTEL||||469-477|PROMENADE|||FY4 1AY"
		And and the contents should contain "|1000000000000005|WATERS EDGE HOTEL|||||5 DEAN STREET|||FY4 1AU"
		And and the contents should contain "|1000000000000010|GRANVILLE HOTEL|||||12 STATION ROAD|||FY4 1BE"
		And and the contents should contain "|1000000000000001|MANHATTAN HOTEL|||||15 DEAN STREET|||FY4 1AU"
		And and the contents should contain "|1000000000000008|SANDS HOTEL|||||485 PROMENADE|||FY4 1AZ"

	@initialSetUpInitialUI
	Scenario: Confirmed the UI reflects the online response receipt
		Given the user has logged in using "Chrome"
    Then the user gets the addresses for postcode "FY41AY"
    And selects case for address "469-477"
    And the case state should be "ACTIONABLE"
    And navigates to the cases page for case "7"
    Then the case event description should be "Print Initial Contact Letter (Hotel)"
		And the user logs out
