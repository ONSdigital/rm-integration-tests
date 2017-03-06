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
#                             Generate reminder letter
#                             Confirm reminder letter sent in Ui
#
# Feature Tag:@sampleScenarios  @replacementIACSMSSHOUSING
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
#                 @reminderLetter1Date
#                 @replaceOnlineRespondedUI

@sampleScenarios @replacementIACSMSSHOUSING
Feature: Request replacement IAC SMS SHOUSING

  @reminderAdjustSurveyDate
  Scenario: Reset survey date
    When the survey start and is reset to 20 days ahead for "2017 Test"
    Then the survey end and is reset to 50 days ahead for "2017 Test"


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
    When I make the PUT call to the caseservice sample endpoint for sample id "23" for area "REGION" code "E12000006"
    Then the response status should be 200
    And the response should contain the field "name" with value "SHOUSING"
    And the response should contain the field "survey" with value "2017 TEST"
    And the response should contain the field "sampleCaseTypes" with one element of the JSON array must be {"caseTypeId":29,"respondentType":"H"}
    Then check "casesvc.case" records in DB equal 10 for "state = 'SAMPLED_INIT'"
    And check "casesvc.caseevent" records in DB equal 10


  @generateIAC
  Scenario: Each case has a unique IAC assigned to it
      and in Actionable state
      and action service has been notified case has been created
    Given after a delay of 30 seconds
    When check "casesvc.case" distinct records in DB equal 10 for "iac" where "state = 'ACTIONABLE'"
    And check "casesvc.case" records in DB equal 10 for "state = 'ACTIONABLE' AND casetypeid = 29"
    And check "action.case" records in DB equal 1 for "caseid = 10"


  @indValidateIAC
  Scenario: Validate IAC and confirm the case iac is active
    Given I make the GET call to the caseservice cases endpoint for case "4"
    And the response status should be 200
    And the response should contain the field "iac"
    When I make the GET call to the IAC service endpoint
    Then the response status should be 200
    And the response should contain the field "active" with boolean value "true"
    And the response should contain the field "questionSet" with value "H1"


  @requestReplacementIACOnline
  Scenario: Request replacement IAC Online
    Given the user has logged in using "Chrome"
    When the user gets the addresses for postcode "BA201DG"
    And selects case for address "FLAT 12 PARK LODGE"
    And navigates to the cases page for case "4"
    And the user requests a replacement IAC
      | Online | Rev. | Integration | Tester |  | 07777123456 | |
    And after a delay of 30 seconds


  @casetypes
  Scenario: Get request for casetypes by casetype
    When I make the GET call to the caseservice for casetypes by casetype "29"
    Then the response status should be 200
    And the response should contain the field "caseTypeId" with an integer value of 29
    And the response should contain the field "respondentType" with value "H"


  @createIndCases
  Scenario: Get request to case for highest expected case id for shousing
    Given after a delay of 30 seconds
    When I make the GET call to the caseservice cases endpoint for case "11"
    Then the response status should be 200
    And the response should contain the field "caseTypeId" with an integer value of 29
    And the response should contain the field "actionPlanMappingId" with an integer value of 82


  @indValidateIAC
  Scenario: Validate IAC and confirm the case iac is active
    Given I make the GET call to the caseservice cases endpoint for case "11"
    And the response status should be 200
    And the response should contain the field "iac"
    When I make the GET call to the IAC service endpoint
    And the response status should be 200
    And the response should contain the field "questionSet" with value "H1"


  @actionPlanMappings
  Scenario: Get request to action plan mapping for specific mappingid
    When I make the GET call to the caseservice actionplanmapping endpoint for mappingid "82"
    Then the response status should be 200
    And the response should contain the field "actionPlanMappingId" with an integer value of 82
    And the response should contain the field "actionPlanId" with an integer value of 53
    And after a delay of 60 seconds


  @replaceOnlineRespondedUI
  Scenario: Confirmed the UI reflects the online response receipt
    Given the user has logged in using "Chrome"
    When the user gets the addresses for postcode "BA201DG"
    And selects case for address "FLAT 12 PARK LODGE"
    And the case state should be "ACTIONABLE"
    And navigates to the cases page for case "11"
    And the case event description should contain "Send Internet Access Code (English)"
    And the user logs out


  @reminderLetter1Date
  Scenario: Post request to actionplans to create jobs for specified action plan
    Given the case start date is adjusted to trigger action plan
      | actionPlanId | actiontypeid | total |
      |           53 |           52 |     1 |
    And after a delay of 120 seconds


  @replaceOnlineRespondedUI
  Scenario: Confirmed the UI reflects the online response receipt
    Given the user has logged in using "Chrome"
    When the user gets the addresses for postcode "BA201DG"
    And selects case for address "FLAT 12 PARK LODGE"
    And the case state should be "ACTIONABLE"
    And navigates to the cases page for case "11"
    And the case event description should contain "Create Sheltered Housing Visit"
    And the user logs out
