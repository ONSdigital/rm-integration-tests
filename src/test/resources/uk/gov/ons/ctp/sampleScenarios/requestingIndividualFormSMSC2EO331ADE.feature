#Author: Kieran Wardle 21/12/16
#
#Keywords Summary :  Testing Requesting Individual Form via SMS
#                    Detailed in: https://collaborate2.ons.gov.uk/confluence/pages/viewpage.action?spaceKey=SDC&title=Test+Scenarios
#                    Note: Assumption that the DB has been loaded with seed data.
#
#Feature: List of Scenarios - Initial Setup
#					                    Initial case data check
#				 	                    Individual Form request
#					                    New case data check
#					                    Individual form request case event check
#
# Feature Tags: @sampleScenarios @SMSindividualC2EO331ADE

@sampleScenarios @SMSindividualC2EO331ADE
Feature: Testing user requesting Individual form by SMS

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


	Scenario: Reset survey date
		When the survey start and is reset to 20 days ahead for "2017 Test"
		Then the survey end and is reset to 50 days ahead for "2017 Test"


	Scenario: Put request for sample to create online cases for the specified sample id
		When I make the PUT call to the caseservice sample endpoint for sample id "6" for area "REGION" code "E12000005"
		Then the response status should be 200
		And the response should contain the field "name" with value "C2EO331ADE"
		Then check "casesvc.case" records in DB equal 10 for "state = 'SAMPLED_INIT'"
		And check "casesvc.caseevent" records in DB equal 10


	Scenario: Each case has a unique IAC assigned to it
			and in Actionable state
			and action service has been notified case has been created
		Given after a delay of 30 seconds
		When check "casesvc.case" distinct records in DB equal 10 for "iac" where "state = 'ACTIONABLE'"
		And check "casesvc.case" records in DB equal 10 for "state = 'ACTIONABLE' AND casetypeid = 22"
		And check "action.case" records in DB equal 1 for "caseid = 1"


	Scenario: check that the Case appears in the UI with the correct address
    Given the "Test" user has logged in using "Chrome"
    When the user gets the addresses for postcode "TF2 6HS"
    Then selects case for address "11 ABBOTS CLOSE"
    And navigates to the cases page for case "5"
    And the user logs out


  Scenario: Get request to check CaseTypeId is correct
    When I make the GET call to the caseservice cases endpoint for case "5"
    Then the response status should be 200
    And the response should contain the field "caseTypeId" with an integer value of 22
    And the response should contain the field "actionPlanMappingId" with an integer value of 22


  Scenario: Get request to check the questionSet is correct
    Given I make the GET call to the caseservice cases endpoint for case "5"
    And the response status should be 200
    When I make the GET call to the IAC service endpoint
    Then the response status should be 200
		And the response should contain the field "questionSet" with value "H1"


  Scenario: Get request to check the responseType is correct
		Then I make the GET call to the caseservice for casetypes by casetype "22"
		And the response status should be 200
    And the response should contain the field "respondentType" with value "H"


  Scenario: Get request to action plan mapping for specific mappingid
    When I make the GET call to the caseservice actionplanmapping endpoint for mappingid "22"
    Then the response status should be 200
    And the response should contain the field "actionPlanMappingId" with an integer value of 22
    And the response should contain the field "actionPlanId" with an integer value of 16


	Scenario: Ui request for individual online request
		Given the "Test" user has logged in using "Chrome"
    When the user gets the addresses for postcode "TF26HS"
    And selects case for address "11 ABBOTS CLOSE"
    And the case state should be "ACTIONABLE"
    And navigates to the cases page for case "5"
    And the user requests an individual request for
      | Online | Dr | Integration | Tester |  | 07777123456 | |
    And the user logs out
    And after a delay of 30 seconds


	Scenario: check that the Case appears in the UI with the correct address
    Given the "Test" user has logged in using "Chrome"
    When the user gets the addresses for postcode "TF2 6HS"
    Then selects case for address "11 ABBOTS CLOSE"
    And navigates to the cases page for case "11"
    And the user logs out


  Scenario: Get request to check CaseTypeId is correct
    When I make the GET call to the caseservice cases endpoint for case "11"
    Then the response status should be 200
    And the response should contain the field "caseTypeId" with an integer value of 26
    And the response should contain the field "actionPlanMappingId" with an integer value of 50


  Scenario: Get request to check the responseType is correct
		Then I make the GET call to the caseservice for casetypes by casetype "26"
		And the response status should be 200
    And the response should contain the field "respondentType" with value "HI"


  Scenario: Get request to action plan mapping for specific mappingid
    When I make the GET call to the caseservice actionplanmapping endpoint for mappingid "50"
    Then the response status should be 200
    And the response should contain the field "actionPlanMappingId" with an integer value of 50
    And the response should contain the field "actionPlanId" with an integer value of 19


  Scenario: This scenario tests that the case event created
    Given after a delay of 150 seconds
    When the "Test" user has logged in using "Chrome"
    Then the user gets the addresses for postcode "TF2 6HS"
    And selects case for address "11 ABBOTS CLOSE"
    And the case state should be "ACTIONABLE"
    And navigates to the cases page for case "11"
    And the case event should be "Action Created"
    And the case event description should be "Send Internet Access Code (English)"
    And the user logs out


  Scenario: Get request to check the questionSet is correct
    Given I make the GET call to the caseservice cases endpoint for case "11"
    And the response status should be 200
    When I make the GET call to the IAC service endpoint
    Then the response status should be 200
		And the response should contain the field "questionSet" with value "I1"
