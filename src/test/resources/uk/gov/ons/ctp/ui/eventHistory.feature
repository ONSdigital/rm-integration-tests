# Author: Edward Stevens 23/11/16
# Keywords Summary : This feature tests event and response history of a case
#
# Requirements Link: https://collaborate2.ons.gov.uk/confluence/pages/viewpage.action?spaceKey=SDC&title=Helpline+Interface+Test+Scenarios
#
# Feature: List of scenarios:	Test the system has successfully registered an online response
#                             View all events associated to a case
#															Identify if a response has been submitted to a case
#
# Feature Tag: @eventHistory
#
# Scenario Tags: @createOnlineCases
#                @onlineResponseReceived
#                @viewAllEventsForCase
#                @viewCaseResponse

@helplineUI @eventHistory
Feature: Review Event History of Case

  @createOnlineCases
  Scenario: Get request to case for highest expected case id
    Given after a delay of 20 seconds
    When I make the GET call to the caseservice cases endpoint for case "10"
    Then the response status should be 200
    And the response should contain the field "caseId" with an integer value of 10
    And the response should contain the field "caseGroupId" with an integer value of 10
    And the response should contain the field "caseRef" with value "1000000000000010"
    And the response should contain the field "state" with value "ACTIONABLE"
    And the response should contain the field "caseTypeId" with an integer value of 17
    And the response should contain the field "actionPlanMappingId" with an integer value of 17
    And the response should contain the field "createdDateTime"
    And the response should contain the field "createdBy" with value "SYSTEM"
    And the response should contain the field "iac"
    And the response should contain the field "responses" with one element of the JSON array must be []
    And the response should contain the field "contact" with a null value

  @onlineResponseReceived
  Scenario: Test the system has successfully registered an online response
    Given I make the POST call to the SDX Gateway online receipt for caseref "1000000000000010"
    And the response status should be 201
    When after a delay of 20 seconds
    Then I make the GET call to the caseservice cases endpoint for case "10"
    And the response status should be 200
    And the response should contain the field "caseId" with an integer value of 10
    And the response should contain the field "caseGroupId" with an integer value of 10
    And the response should contain the field "caseRef" with value "1000000000000010"
    And the response should contain the field "state" with value "INACTIONABLE"
    And the response should contain the field "caseTypeId" with an integer value of 17
    And the response should contain the field "actionPlanMappingId" with an integer value of 17
    And the response should contain the field "createdDateTime"
    And the response should contain the field "createdBy" with value "SYSTEM"
    And the response should contain the field "iac"
    And the response should contain the field "responses" with one element of the JSON array must be [{"inboundChannel":"ONLINE","dateTime":
    And the response should contain the field "contact" with a null value

  @viewAllEventsForCase
  Scenario: View all events associated to a case
    Given the user has logged in using "Chrome"
    When the user gets the addresses for postcode "TF107BH"
    And selects case for address "BEDSIT 10"
    And navigates to the cases page for case "10"
    Then event history should be visible

  @viewCaseResponse
  Scenario: Identify if a response has been submitted to a case
    Given the user has logged in using "Chrome"
    When the user gets the addresses for postcode "TF107BH"
    And selects case for address "BEDSIT 10"
    And navigates to the cases page for case "10"
    Then check if a response has been submitted
