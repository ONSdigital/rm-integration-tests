# Author: Stephen Goddard 30/11/2016
# Keywords Summary : CTPA-0000 This script tests 
#										 Note: Assumption that the DB has been loaded with seed data.
#
# Tasks Covered: CTPA-830 - Create Event from Field outcome
#								 CTPA-770 Cancel Distribute Actions
#
# Feature: List of scenarios: Clean DB to pre test condition
#															Create Sample
#															Reminder Letter 1
#															Create Field Visit
#															Field Refusal
#															Test states of action, case and iac
#															Online response for case which has refused
#															Test case and iac state - currently iac not set to active = false
#
# Feature Tags: @other
#								@ctpa0000
#
# Scenario Tags: @cleanPrintFiles
#								 @fieldCleanEnvironment
#								 @fieldSample
#								 @fieldCases
#								 @fieldLetter1Date
#								 @fieldLetter1File
#								 @fieldVisitDate
#								 @fieldRefusal
#								 @fieldResponse

@other @ctpa1075
Feature: Test iac is made inactive after a refusal

	# Clean Environment -----

	@cleanPrintFiles
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


	# Sample Creation -----

	@fieldSample
	Scenario: Get request for samples for sample id
		When I make the PUT call to the caseservice sample endpoint for sample id "7" for area "REGION" code "E12000005"
		Then the response status should be 200
		And the response should contain the field "name" with value "C1SO331D4E"
		And the response should contain the field "survey" with value "2017 TEST"
		And check "casesvc.caseevent" records in DB equal 10


	@fieldCases
	Scenario: Get request to case for highest expected case id
		Given after a delay of 30 seconds
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


	# Reminder Letter 1 -----

	@fieldLetter1Date
	Scenario: Post request to actionplans to create jobs for specified action plan - reminder letter 1
		Given the case start date is adjusted to trigger action plan
			| actionPlanId  | actiontypeid | total |
			| 1  						| 5   				 | 10		 |
		And after a delay of 150 seconds


	@fieldLetter1File
	Scenario: Test action plan has created paper file for printer
		Given get the contents of the file from "/var/actionexporter-sftp/" where the filename begins "1RL1_0504"
		When the exit status should be 0
		Then and each line should start with an iac
		And and the contents should contain "|1000000000000010||||||19 VINEYARD ROAD|WELLINGTON|TELFORD|TF1 1HB"
		And and the contents should contain "|1000000000000006|||||WHITEHAVEN|26A VINEYARD ROAD|WELLINGTON|TELFORD|TF1 1HB"
		And and the contents should contain "|1000000000000002||||||13 VINEYARD ROAD|WELLINGTON|TELFORD|TF1 1HB"
		And and the contents should contain "|1000000000000008||||||7 VINEYARD ROAD|WELLINGTON|TELFORD|TF1 1HB"
		And and the contents should contain "|1000000000000003||||||15 VINEYARD ROAD|WELLINGTON|TELFORD|TF1 1HB"
		And and the contents should contain "|1000000000000009||||||9 VINEYARD ROAD|WELLINGTON|TELFORD|TF1 1HB"
		And and the contents should contain "|1000000000000007||||||28A VINEYARD ROAD|WELLINGTON|TELFORD|TF1 1HB"
		And and the contents should contain "|1000000000000004||||||17 VINEYARD ROAD|WELLINGTON|TELFORD|TF1 1HB"
		And and the contents should contain "|1000000000000001||||||11 VINEYARD ROAD|WELLINGTON|TELFORD|TF1 1HB"
		And and the contents should contain "|1000000000000005||||||21A VINEYARD ROAD|WELLINGTON|TELFORD|TF1 1HB"


	# Field Visit -----

	@fieldVisitDate
	Scenario: Post request to actionplans to create jobs for specified action plan - field visit
		Given the case start date is adjusted to trigger action plan
			| actionPlanId  | actiontypeid | total |
			| 1  						| 14   				 | 10		 |
		And after a delay of 150 seconds


	Scenario: simulate accept Kirona visit
		Given Update "action.action" to "state = 'ACTIVE'" where "actionId = 21"
		When after a delay of 20 seconds


	# Field Refusal -----

	@fieldRefusal
	Scenario: Simulate a refusal visit organised by Kirona.
		When I make the POST "REFUSAL" call to the DRS Gateway for actionId "21"
		Then the response status should be 200


	Scenario: Get and test requests for the case refused including:
			Action
			Case
			Iacsvc
		Given after a delay of 20 seconds
		When I make the GET call to the actionservice actions endpoint for actionId "21"
		And the response status should be 200
		And the response should contain the field "actionId" with an integer value of 21
		And the response should contain the field "caseId"
		And the response should contain the field "actionPlanId" with an integer value of 1
		And the response should contain the field "actionRuleId" with an integer value of 3
		And the response should contain the field "actionTypeName" with value "HouseholdCreateVisit"
		And the response should contain the field "createdBy" with value "SYSTEM"
		And the response should contain the field "manuallyCreated" with boolean value "false"
		And the response should contain the field "priority" with an integer value of 3
		And the response should contain the field "situation" with value "REFUSAL"
		And the response should contain the field "state" with value "COMPLETED"
		And the response should contain the field "createdDateTime"
		And the response should contain the field "updatedDateTime"
		Then I make the GET call to the caseservice cases endpoint for current case
		And the response status should be 200
		And the response should contain the field "state" with value "INACTIONABLE"
		And the response should contain the field "responses" with one element of the JSON array must be []
		Then I make the GET call to the IAC service endpoint
  	And the response status should be 200
  	And the response should contain the field "iac"
  	And the response should contain the field "active" with boolean value "true"
  	And the response should contain the field "questionSet" with value "H1S"


	Scenario: Confirm the refusal case has been processed without knowing the caseId
		Given check "action.case" records in DB equal 9


	@fieldResponse
  Scenario: Register an online response
  	Given I make the GET call to the actionservice actions endpoint for actionId "21"
  	And the response status should be 200
  	And the response should contain the field "situation" with value "REFUSAL"
		And the response should contain the field "state" with value "COMPLETED"
  	Then I make the GET call to the caseservice cases endpoint for current case
		And the response status should be 200
		And the response should contain the field "state" with value "INACTIONABLE"
  	Then I make the POST call to the SDX Gateway online receipt for current case
		And the response status should be 201
		When after a delay of 20 seconds


	@fieldResponse
	Scenario: Test the system has successfully registered an online response
		Given I make the GET call to the actionservice actions endpoint for actionId "21"
		Then I make the GET call to the caseservice cases endpoint for current case
		And the response status should be 200
		And the response should contain the field "state" with value "INACTIONABLE"
		And the response should contain the field "caseTypeId" with an integer value of 1
		And the response should contain the field "actionPlanMappingId" with an integer value of 1
		And the response should contain the field "createdDateTime"
		And the response should contain the field "createdBy" with value "SYSTEM"
		And the response should contain the field "iac"
		And the response should contain the field "responses" with one element of the JSON array must be [{"inboundChannel":"ONLINE","dateTime":
		And the response should contain the field "contact" with a null value
		Then I make the GET call to the caseservice cases endpoint for current case
		And the response status should be 200
  	And the response should contain the field "iac"
  	Then I make the GET call to the IAC service endpoint
  	And the response status should be 200
  	And the response should contain the field "iac"
  	And the response should contain the field "active" with boolean value "false"
  	And the response should contain the field "questionSet" with value "H1S"
