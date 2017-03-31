#Author: Kieran Wardle 20/12/16
#
#Keywords Summary : Testing Requesting a replacement IAC via SMS in Wales
#
#Feature: List of Scenarios - Initial Setup
#                             Initial case data check
#                             Request replacement IAC
#                             New case data check
#                             IAC replacement case event check
#                             Trigger field visit
#                             Field visit case event check
#
# Feature Tag:@sampleScenarios  @SMSIACWelshC1EO331D4W

@sampleScenarios @SMSIACWelshC1SO331D10W
Feature: Testing user requesting replacement IAC by SMS in Welsh with no response - C1SO331D10W

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
    When I make the PUT call to the caseservice sample endpoint for sample id "10" for area "REGION" code "E12000005"
    Then the response status should be 200
    And the response should contain the field "name" with value "C1SO331D10W"
    Then check "casesvc.case" records in DB equal 10 for "state = 'SAMPLED_INIT'"
    And check "casesvc.caseevent" records in DB equal 10


  Scenario: Each case has a unique IAC assigned to it
    and in Actionable state
    and action service has been notified case has been created
    Given after a delay of 30 seconds
    When check "casesvc.case" distinct records in DB equal 10 for "iac" where "state = 'ACTIONABLE'"
    And check "casesvc.case" records in DB equal 10 for "state = 'ACTIONABLE' AND casetypeid = 4"
    And check "action.case" records in DB equal 1 for "caseid = 1"


  Scenario: check that the Case appears in the UI with the correct address
    Given the "Test" user has logged in using "Chrome"
    When the user gets the addresses for postcode "TF1 3EE"
    Then selects case for address "11 DEER PARK ROAD"
    And navigates to the cases page for case "1"
    And the user logs out


  Scenario: Get request to check CaseTypeId is correct
    When I make the GET call to the caseservice cases endpoint for case "1"
    Then the response status should be 200
    And the response should contain the field "caseTypeId" with an integer value of 4
    And the response should contain the field "actionPlanMappingId" with an integer value of 7


  Scenario: Get request to check the questionSet is correct
    Given I make the GET call to the caseservice cases endpoint for case "1"
    And the response status should be 200
    When I make the GET call to the IAC service endpoint
    Then the response status should be 200
    And the response should contain the field "questionSet" with value "H2S"


  Scenario: Get request to check the responseType is correct
    Then I make the GET call to the caseservice for casetypes by casetype "4"
    And the response status should be 200
    And the response should contain the field "respondentType" with value "H"


  Scenario: Get request to action plan mapping for specific mappingid
    When I make the GET call to the caseservice actionplanmapping endpoint for mappingid "7"
    Then the response status should be 200
    And the response should contain the field "actionPlanMappingId" with an integer value of 7
    And the response should contain the field "actionPlanId" with an integer value of 4


  Scenario: Request replacement IAC Online
    Given the "Test" user has logged in using "Chrome"
    When the user gets the addresses for postcode "TF1 3EE"
    And selects case for address "11 DEER PARK ROAD"
    And navigates to the cases page for case "1"
    And the user requests a replacement IAC
      | Online | Rev. | Integration | Tester |  | 07777123456 |  |
    And the user logs out
    And after a delay of 60 seconds


  Scenario: check that the Case appears in the UI with the correct address
    Given the "Test" user has logged in using "Chrome"
    When the user gets the addresses for postcode "TF1 3EE"
    Then selects case for address "11 DEER PARK ROAD"
    And navigates to the cases page for case "11"
    And the user logs out


  Scenario: Get request to check CaseTypeId is correct
    When I make the GET call to the caseservice cases endpoint for case "11"
    Then the response status should be 200
    And the response should contain the field "caseTypeId" with an integer value of 4
    And the response should contain the field "actionPlanMappingId" with an integer value of 62


  Scenario: Get request to check the responseType is correct
    Then I make the GET call to the caseservice for casetypes by casetype "11"
    And the response status should be 200
    And the response should contain the field "respondentType" with value "H"


  Scenario: Get request to action plan mapping for specific mappingid
    When I make the GET call to the caseservice actionplanmapping endpoint for mappingid "62"
    Then the response status should be 200
    And the response should contain the field "actionPlanMappingId" with an integer value of 62
    And the response should contain the field "actionPlanId" with an integer value of 48
    And after a delay of 60 seconds


  Scenario: Confirmed the UI reflects the online response receipt
    Given the "Test" user has logged in using "Chrome"
    When the user gets the addresses for postcode "TF13EE"
    And selects case for address "11 DEER PARK ROAD"
    And the case state for "11" should be "ACTIONABLE"
    And navigates to the cases page for case "11"
    And the case event description should be "Send Internet Access Code (Bilingual)"
    And the user logs out


  Scenario: Get request to check the questionSet is correct
    Given I make the GET call to the caseservice cases endpoint for case "11"
    And the response status should be 200
    When I make the GET call to the IAC service endpoint
    Then the response status should be 200
    And the response should contain the field "questionSet" with value "H2S"


  Scenario: Post request to actionplans to create jobs for specified action plan
    Given the case start date is adjusted to trigger action plan
      | actionPlanId | actiontypeid | total |
      |           48 |           14 |     1 |
    And after a delay of 120 seconds


  Scenario: Confirmed the UI reflects the online response receipt
    Given the "Test" user has logged in using "Chrome"
    When the user gets the addresses for postcode "TF13EE"
    And selects case for address "11 DEER PARK ROAD"
    And the case state for "11" should be "ACTIONABLE"
    And navigates to the cases page for case "11"
    And the case event description should be "Create Household Visit"
    And the user logs out
