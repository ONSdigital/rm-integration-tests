# URL:  https://collaborate2.ons.gov.uk/confluence/pages/viewpage.action?spaceKey=SDC&title=Helpline+Interface+Test+Scenarios
# Author: Chris Hardman 21/11/2016
# Keywords Summary : This feature tests User login Authentication
#										 Note: Assumption that the DB has been loaded with seed data.
#
# Feature: List of scenarios: Enable user to see question set
#															Enable user to see current case state
#
# Feature Tag: @reviewCaseInformation
#
#
# Scenario Tags: @caseInformation

@helplineUI @reviewCaseInformation
Feature: Review Case Information

  # Clean Environment -----

  @replaceCleanEnvironment
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

  # Online Sample Creation -----
  @createOnlineSample
  Scenario: Put request for sample to create online cases for the specified sample id
    When I make the PUT call to the caseservice sample endpoint for sample id "1" for area "REGION" code "E12000005"
    Then the response status should be 200
    And the response should contain the field "name" with value "C2EO332E"
    And the response should contain the field "survey" with value "2017 TEST"
    And check "casesvc.caseevent" records in DB equal 10

  Scenario: Delay to allow the system to process cases
    Given after a delay of 20 seconds

  # Run UI Case and Casegroup Tests -----
  @caseInformation
  Scenario: Enable user to see question set
    Given the "Test" user has logged in using "Chrome"
    When the user gets the addresses for postcode "TF107BH"
    And selects case for address "BEDSIT 1"
    And navigates to the cases page for case "1"
    Then reviews and validates information "QuestionSet"
    And the user logs out 

  @caseInformation
  Scenario: Enable user to see address type HH or CE and the type of CE
    Given the "Test" user has logged in using "Chrome"
    When the user gets the addresses for postcode "TF107BH"
    And selects case for address "BEDSIT 1"
    And navigates to the cases page for case "1"
    Then reviews and validates information "AddressType"
    And the user logs out

  @caseInformation
  Scenario: Enable user to see current case state
    Given the "Test" user has logged in using "Chrome"
    When the user gets the addresses for postcode "TF107BH"
    And selects case for address "BEDSIT 1"
    And navigates to the cases page for case "1"
    Then reviews and validates information "CaseState"
    And the user logs out
 