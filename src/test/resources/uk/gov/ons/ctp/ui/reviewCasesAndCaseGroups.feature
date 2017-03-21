# Author: Edward Stevens 22/11/16
# Keywords Summary : This feature tests case association and visibility
# Requirements Link: https://collaborate2.ons.gov.uk/confluence/pages/viewpage.action?spaceKey=SDC&title=Helpline+Interface+Test+Scenarios
#
# Feature: List of scenarios:	Viewing all cases associated to an address
#															Viewing contact details for a case (either Individual or Replacement)
#															Identifying that there are no cases associated to an address
#
# Feature Tag: @responseManagementUiReviewCasesCaseGroups
#
# Scenario Tags: @viewAllCasesForAddress
#                @viewContactNameAssociatedIndividualCase
#                @viewContactNameAssociatedToReplacementCase
#	               @identifyThatPostcodeHasNoAddressesAssociated

@helplineUI @rmUiReviewCasesCaseGroups
Feature: Review Cases and Case Groups

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

  Scenario: Delay	to allow the system to process cases
    Given after a delay of 20 seconds

  # Run UI Case and Casegroup Tests -----
  @viewAllCasesForAddress
  Scenario: See all cases related to an address
    Given the "Test" user has logged in using "Chrome"
    When the user gets the addresses for postcode "TF107BH"
    And selects case for address "BEDSIT 1"
    Then check if any cases associated with address
    And the user logs out

  @viewContactNameAssociatedToIndividualCase
  Scenario: Ui request for individual online request
    Given the "Test" user has logged in using "Chrome"
    When the user gets the addresses for postcode "TF107BH"
    And selects case for address "BEDSIT 1"
    And the case state for "1" should be "ACTIONABLE"
    And navigates to the cases page for case "1"
    And the user requests an individual request for
      | Online | Mr | Integration | Tester |  |07777123456 | |
    And the user logs out

  @viewContactNameAssociatedToIndividualCase
  Scenario: See contact name associated to individual case
    Given the "Test" user has logged in using "Chrome"
    When the user gets the addresses for postcode "TF107BH"
    And selects case for address "BEDSIT 1"
    And navigates to the cases page for case "1"
    And the case event description should be "Individual Form sent to Mr Integration Tester"
    And the user logs out

  @viewContactNameAssociatedToReplacementCase
  Scenario: Ui request for HH replacement IAC
    Given the "Test" user has logged in using "Chrome"
    When the user gets the addresses for postcode "TF107BH"
    And selects case for address "BEDSIT 10"
    And navigates to the cases page for case "10"
    And the user requests a replacement IAC
      | Online | Rev. | Integration | Tester |  | 07777123456 | |
    And the case event description should be "Replacement Access Code sent to Rev Integration Tester"
    And the user logs out

  @identifyThatPostcodeHasNoCasesAssociated
  Scenario: Test if no cases for address
    Given the "Test" user has logged in using "Chrome"
    When the user gets the addresses for postcode "TF11PX"
    And selects case for address "10 HEATHER DRIVE"
    Then check if any cases associated with address
    And the user logs out
