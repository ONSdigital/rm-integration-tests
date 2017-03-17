# Author: Chris Hardman 19/12/2016
# Keywords Summary : This feature file contains the scenario testing the requesting a paper form in welsh.
#                    Detailed in: https://collaborate2.ons.gov.uk/confluence/pages/viewpage.action?spaceKey=SDC&title=Test+Scenarios
#                    Note: Assumption that the DB has been loaded with seed data.
#
#
# Feature: List of scenarios: Request a paper form
#                             Check case has changed to ACTIONABLE and removed from action.case
#                             Checks new case in Ui
#                             Get request for samples for sample id
#                             Test action plan has created paper file for printer
#
# Feature Tags: @sampleScenarios @requestingPaperForm

@sampleScenarios @requestingPaperForm
Feature: Test successful follow up reminder letters with no response

	@cleanPrintFiles
	Scenario: Clean folder of previous print files by coping all existing files to /previousTests
		When create test directory "/var/actionexporter-sftp/previousTests/"
		And the exit status should be 0
		Then move print files from "/var/actionexporter-sftp/" to "/var/actionexporter-sftp/previousTests/"
		And the exit status should be 0


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


  Scenario: Put request for sample to create online cases for the specified sample id
    When I make the PUT call to the caseservice sample endpoint for sample id "9" for area "REGION" code "E12000005"
    Then the response status should be 200
    And the response should contain the field "sampleId" with an integer value of 9
    And the response should contain the field "name" with value "C1SO331D10E"
    And the response should contain the field "description" with value "component 1 sex id online first 331 day 10 england"
    And the response should contain the field "addressCriteria" with value "SAMPLE = C1SO331D10E"
    And the response should contain the field "survey" with value "2017 TEST"
    And the response should contain the field "sampleCaseTypes" with one element of the JSON array must be {"caseTypeId":3,"respondentType":"H"}
    And the response should contain the field "sampleCaseTypes" with one element of the JSON array must be {"caseTypeId":23,"respondentType":"HI"}


  Scenario: Request a paper form
  	Given after a delay of 30 seconds
    When the "CSO" user has logged in using "Chrome"
    Then the user gets the addresses for postcode "TF1 1LZ"
    And selects case for address "6 LOWE COURT"
    And navigates to the cases page for case "6"
    And the user requests a replacement paper form
      | Paper | Dr | Integration | Tester |  | 07777123456 | |
    And the user logs out


  Scenario: Check case has changed to INACTIONABLE and removed from action.case
    Given after a delay of 30 seconds
    When check "casesvc.case" records in DB equal 1 for "state = 'INACTIONABLE'"
    And check "action.case" records in DB equal 0 for "caseid = 6"


  Scenario: Checks new case
    Given the "CSO" user has logged in using "Chrome"
    When the user gets the addresses for postcode "TF1 1LZ"
    And selects case for address "6 LOWE COURT"
    And navigates to the cases page for case "11"
    And the user logs out


  Scenario: Get request for samples for sample id - Checks that the new case has the correct action plan changed
    When I make the GET call to the caseservice for samples for sample id "9"
    Then the response status should be 200
    And the response should contain the field "sampleId" with an integer value of 9
    And the response should contain the field "name" with value "C1SO331D10E"
    And the response should contain the field "description" with value "component 1 sex id online first 331 day 10 england"
    And the response should contain the field "addressCriteria" with value "SAMPLE = C1SO331D10E"
    And the response should contain the field "survey" with value "2017 TEST"
    And the response should contain the field "sampleCaseTypes" with one element of the JSON array must be {"caseTypeId":3,"respondentType":"H"}
    And the response should contain the field "sampleCaseTypes" with one element of the JSON array must be {"caseTypeId":23,"respondentType":"HI"}


  Scenario: Test action plan has created paper file for printer
    Given after a delay of 160 seconds
    Then get the contents of the file from "/var/actionexporter-sftp/" where the filename begins "H1S"
    And the exit status should be 0
    When and each line should start with an iac
    And and the contents should contain "|1000000000000011||dr|Integration|Tester||6 LOWE COURT|WELLINGTON|TELFORD|TF1 1LZ"
    
    
	Scenario: Post request to actionplans to create jobs for specified action plan - create field job
		Given the case start date is adjusted to trigger action plan
			| actionPlanId  | actiontypeid | total |
			| 21  					| 14   				 | 1 		 |
		And after a delay of 160 seconds


  Scenario: Check Field visit is created
    Given the "CSO" user has logged in using "Chrome"
    When the user gets the addresses for postcode "TF1 1LZ"
    And selects case for address "6 LOWE COURT"
    And navigates to the cases page for case "11"
    Then the case event description should be "Create Household Visit"
    And the user logs out
