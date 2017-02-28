#Author: Edward Stevens 19/12/16
#Keywords Summary : This feature tests that the a replacement IAC can be succesfully requested
#                   https://collaborate2.ons.gov.uk/confluence/display/SDC/Test+Scenarios
#                   Note: Assumption that the DB has been loaded with seed data.
#
#Feature: List of Scenarios - Clean Postgres DB to pre test condition
#                             Generate samples based on sampleId
#                             Generate iac
#                             Check initial associated question set is correct.
#                             Request replacement iac
#                             Check respondent type
#                             Check caseTypeId and actionPlanMappingId
#                             Check new associated question set is correct
#                             Check actionplanId
#                             Check SMS sent.
#
# Feature Tag:@sampleScenarios  @replacementIACSMSUNIVERSITY
#
# Scenario Tags: @uiCleanEnvironment
#                 @uiCreateSample
#                 @generateIAC
#                 @indValidateIAC
#                 @requestReplacementIACOnline
#                 @casetypes
#                 @createIndCases
#                 @indValidateIAC
#                 @actionPlanMappings
#                 @replaceOnlineRespondedUI

@sampleScenarios @replacementIACSMSUNIVERSITY
Feature: Request replacement IAC SMS UNIVERSITY

  @uiCleanEnvironment
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


  @uiCreateSample
  Scenario: Put request for sample to create online cases for the specified sample id
    When I make the PUT call to the caseservice sample endpoint for sample id "25" for area "REGION" code "E12000003"
    Then the response status should be 200
    And the response should contain the field "name" with value "UNIVERSITY"
    And the response should contain the field "survey" with value "2017 TEST"
    And the response should contain the field "sampleCaseTypes" with one element of the JSON array must be {"caseTypeId":31,"respondentType":"CI"}
    Then check "casesvc.case" records in DB equal 1804 for "state = 'SAMPLED_INIT'"
    And check "casesvc.caseevent" records in DB equal 1804


  @generateIAC
  Scenario: Each case has a unique IAC assigned to it
      and in Actionable state
      and action service has been notified case has been created
    Given after a delay of 120 seconds
    When check "casesvc.case" distinct records in DB equal 1804 for "iac" where "state = 'ACTIONABLE'"
    And check "casesvc.case" records in DB equal 1804 for "state = 'ACTIONABLE' AND casetypeid = 31"
    And check "action.case" records in DB equal 1 for "caseid = 1804"


  @indValidateIAC
  Scenario: Validate IAC and confirm the case iac is active
    Given I make the GET call to the caseservice cases endpoint for case "1"
    And the response status should be 200
    And the response should contain the field "iac"
    When I make the GET call to the IAC service endpoint
    Then the response status should be 200
    And the response should contain the field "active" with boolean value "true"
    And the response should contain the field "questionSet" with value "I1"


  @requestReplacementIACOnline
  Scenario: Request replacement IAC Online
    Given the user has logged in using "Chrome"
    When the user gets the addresses for postcode "S14GJ"
    And selects case for address "FLAT D1"
    And navigates to the cases page for case "1"
    And the user requests a replacement IAC
      | Online | Rev. | Integration | Tester |  | 07777123456 | |
    And after a delay of 30 seconds


  @casetypes
  Scenario: Get request for casetypes by casetype
    When I make the GET call to the caseservice for casetypes by casetype "31"
    Then the response status should be 200
    And the response should contain the field "caseTypeId" with an integer value of 31
    And the response should contain the field "respondentType" with value "CI"


  @createIndCases
  Scenario: Get request to case for highest expected case id fir university
    #Given after a delay of 300 seconds
    When I make the GET call to the caseservice cases endpoint for case "1805"
    Then the response status should be 200
    And the response should contain the field "caseTypeId" with an integer value of 31
    And the response should contain the field "actionPlanMappingId" with an integer value of 85


  @indValidateIAC
  Scenario: Validate IAC and confirm the case iac is active
    Given I make the GET call to the caseservice cases endpoint for case "1805"
    And the response status should be 200
    And the response should contain the field "iac"
    When I make the GET call to the IAC service endpoint
    Then the response status should be 200
    And the response should contain the field "questionSet" with value "I1"


  @actionPlanMappings
  Scenario: Get request to action plan mapping for specific mappingid
    When I make the GET call to the caseservice actionplanmapping endpoint for mappingid "36"
    Then the response status should be 200
    And the response should contain the field "actionPlanMappingId" with an integer value of 36
    And the response should contain the field "actionPlanId" with an integer value of 28
    And after a delay of 60 seconds


  @replaceOnlineRespondedUI
  Scenario: Confirmed the UI reflects the online response receipt
    Given the user has logged in using "Chrome"
    When the user gets the addresses for postcode "S14GJ"
    And selects case for address "FLAT D1"
    And the case state should be "ACTIONABLE"
    And navigates to the cases page for case "1805"
    And the case event description should contain "Send Internet Access Code (English)"
    And the user logs out
