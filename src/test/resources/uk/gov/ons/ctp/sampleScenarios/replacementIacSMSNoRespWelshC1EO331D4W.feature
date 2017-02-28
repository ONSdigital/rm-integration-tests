#Author: Kieran Wardle 20/12/16
#
#Keywords Summary : Testing Requesting a replacement IAC via SMS in Wales
#
#Feature: List of Scenarios - Initial Setup
#					                    Initial case data check
#                             Request replacement IAC
#                             New case data check
#                             IAC replacement case event check
#                             Trigger field visit
#                             Field visit case event check
#
# Feature Tag:@sampleScenarios  @SMSIACWelshC1EO331D4W

@sampleScenarios @SMSIACWelshC1EO331D4W
Feature: Testing user requesting replacement IAC by SMS in Welsh with no response  C1EO331D4W

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
    When I make the PUT call to the caseservice sample endpoint for sample id "12" for area "REGION" code "E12000005"
    Then the response status should be 200
    And the response should contain the field "name" with value "C1EO331D4W"
    Then check "casesvc.case" records in DB equal 10 for "state = 'SAMPLED_INIT'"
    And check "casesvc.caseevent" records in DB equal 10


  Scenario: Each case has a unique IAC assigned to it
    and in Actionable state
    and action service has been notified case has been created
    Given after a delay of 30 seconds
    When check "casesvc.case" distinct records in DB equal 10 for "iac" where "state = 'ACTIONABLE'"
    And check "casesvc.case" records in DB equal 10 for "state = 'ACTIONABLE' AND casetypeid = 6"
    And check "action.case" records in DB equal 1 for "caseid = 4"


  Scenario: check that the Case appears in the UI with the correct address
    Given the user has logged in using "Chrome"
    When the user gets the addresses for postcode "TF1 3JD"
    Then selects case for address "2 THE SAVANNAHS"
    And navigates to the cases page for case "4"
    And the user logs out


  Scenario: Get request to check CaseTypeId is correct
    When I make the GET call to the caseservice cases endpoint for case "1"
    Then the response status should be 200
    And the response should contain the field "caseTypeId" with an integer value of 6
    And the response should contain the field "actionPlanMappingId" with an integer value of 4


  Scenario: Get request to check the questionSet is correct
    Given I make the GET call to the caseservice cases endpoint for case "1"
    And the response status should be 200
    When I make the GET call to the IAC service endpoint
    Then the response status should be 200
    And the response should contain the field "questionSet" with value "H2"


  Scenario: Get request to check the responseType is correct
    Then I make the GET call to the caseservice for casetypes by casetype "6"
    And the response status should be 200
    And the response should contain the field "respondentType" with value "H"


  Scenario: Get request to action plan mapping for specific mappingid
    When I make the GET call to the caseservice actionplanmapping endpoint for mappingid "4"
    Then the response status should be 200
    And the response should contain the field "actionPlanMappingId" with an integer value of 4
    And the response should contain the field "actionPlanId" with an integer value of 2


  Scenario: Request replacement IAC Online
    Given the user has logged in using "Chrome"
    When the user gets the addresses for postcode "TF1 3JD"
    And selects case for address "2 THE SAVANNAHS"
    And navigates to the cases page for case "4"
    And the user requests a replacement IAC
      | Online | Rev. | Integration | Tester |  | 07777123456 |  |
    And the user logs out
    And after a delay of 30 seconds


  Scenario: check that the Case appears in the UI with the correct address
    Given the user has logged in using "Chrome"
    When the user gets the addresses for postcode "TF1 3JD"
    Then selects case for address "2 THE SAVANNAHS"
    And navigates to the cases page for case "11"
    And the user logs out


  Scenario: Get request to check CaseTypeId is correct
    When I make the GET call to the caseservice cases endpoint for case "11"
    Then the response status should be 200
    And the response should contain the field "caseTypeId" with an integer value of 6
    And the response should contain the field "actionPlanMappingId" with an integer value of 65


  Scenario: Get request to check the questionSet is correct
    Given I make the GET call to the caseservice cases endpoint for case "11"
    And the response status should be 200
    When I make the GET call to the IAC service endpoint
    Then the response status should be 200
    And the response should contain the field "questionSet" with value "H2"


  Scenario: Get request to check the responseType is correct
    Then I make the GET call to the caseservice for casetypes by casetype "6"
    And the response status should be 200
    And the response should contain the field "respondentType" with value "H"


  Scenario: Get request to action plan mapping for specific mappingid
    When I make the GET call to the caseservice actionplanmapping endpoint for mappingid "65"
    Then the response status should be 200
    And the response should contain the field "actionPlanMappingId" with an integer value of 65
    And the response should contain the field "actionPlanId" with an integer value of 47
    And after a delay of 90 seconds

  #Check IAC replacement case event triggered in UI
  Scenario: Confirmed the UI reflects the online response receipt
    Given the user has logged in using "Chrome"
    When the user gets the addresses for postcode "TF1 3JD"
    And selects case for address "2 THE SAVANNAHS"
    And the case state should be "ACTIONABLE"
    And navigates to the cases page for case "11"
    And the case event description should contain "Send Internet Access Code (Bilingual)"
    And the user logs out


  Scenario: Post request to actionplans to create jobs for specified action plan
    Given the case start date is adjusted to trigger action plan
      | actionPlanId | actiontypeid | total |
      |           47 |           14 |     1 |
    And after a delay of 120 seconds


  Scenario: Confirmed the UI reflects the online response receipt
    Given the user has logged in using "Chrome"
    When the user gets the addresses for postcode "TF1 3JD"
    And selects case for address "2 THE SAVANNAHS"
    And the case state should be "ACTIONABLE"
    And navigates to the cases page for case "11"
    And the case event description should contain "Create Household Visit"
    And the user logs out
