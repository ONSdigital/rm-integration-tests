# Author: Stephen Goddard 03/10/2016
# Keywords Summary : This feature file contains the scenario tests no response from helpline.
#										 Detailed in: https://collaborate2.ons.gov.uk/confluence/pages/viewpage.action?pageId=3690875
#										 Note: Assumption that cases have been generated in the DB.
#
# Tasks Covered: CTPA-765 Process Service Request
#								 CTPA-753 Flag cases where a response is no longer expected - missing card?
#								 CTPA-770 Cancel Distribute Actions
#								 
# Feature: List of scenarios: Clean DB to pre test condition
#															Create Sample
#															Test Cases Created - max number of cases
#															Create an refusal case event
#															Create an classification incorrect case event
#															Create an undeliverable case event
#															Test successful notification for a refusal event
#															Test successful notification for a classification incorrect event
#															Test successful notification for a undeliverable event
#															Cancel Distributed Actions
#															Test successful notification for a refusal event
#															
# Feature Tags: @refusal
#								@helpline
#
# Scenario Tags: @onlineCleanEnvironment
#								 @createSample
#								 @generateIAC
#								 @refusalRequest
#								 @classificationIncorrectRequest
#								 @undeliverableRequest
#								 @caseStateRefusalCheck
#								 @caseStateClassificationIncorrectCheck
#								 @caseStateUndeliverableCheck
#								 @distributedActionsCancelled

@refusal @helpline
Feature: Test helpline no response expected

	# Clean Environment -----

  @onlineCleanEnvironment
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

	@createSample
	Scenario: Put request for sample to create online cases for the specified sample id
		When I make the PUT call to the caseservice sample endpoint for sample id "1" for area "REGION" code "E12000005"
		Then the response status should be 200
		And the response should contain the field "name" with value "C2EO332E"
		And the response should contain the field "survey" with value "2017 TEST"
		And check "casesvc.caseevent" records in DB equal 10


	@generateIAC
	Scenario: Each case has a unique IAC assigned to it and cases have been sent to the action service
			and in Actionable state
			and action service has been notified case has been created
		Given after a delay of 150 seconds
		When check "casesvc.case" distinct records in DB equal 10 for "iac" where "state = 'ACTIONABLE'"
		And check "casesvc.case" records in DB equal 10 for "state = 'ACTIONABLE' AND casetypeid = 17"
		And check "action.case" records in DB equal 1 for "caseid = 10"


	# CTPA-765
  @refusalRequest
  Scenario: Create an refusal case event
    Given the user has logged in using "Chrome"
    When the user gets the addresses for postcode "TF107BH"
    And selects case for address "BEDSIT 1"
    And the case state should be "ACTIONABLE"
    And navigates to the cases page for case "1"
    And the user creates a new event for
      | Refusal | Test description. | integration.tester | 01234 567890 |
    And the user logs out
    
  @classificationIncorrectRequest
  Scenario: Create an Classification Incorrect case event
    Given the user has logged in using "Chrome"
    When the user gets the addresses for postcode "TF107BH"
    And selects case for address "BEDSIT 3"
    And the case state should be "ACTIONABLE"
    And navigates to the cases page for case "3"
    And the user creates a new event for
      | Classification Incorrect | Test description. | integration.tester | 01234 567890 |
    And the user logs out
    
  @undeliverableRequest
  Scenario: Create an Undeliverable case event
    Given the user has logged in using "Chrome"
    When the user gets the addresses for postcode "TF107BH"
    And selects case for address "BEDSIT 10"
    And the case state should be "ACTIONABLE"
    And navigates to the cases page for case "10"
    And the user creates a new event for
      | Undeliverable | Test description. | integration.tester | 01234 567890 |
    And the user logs out


	# No Response Expected -----

	# CTPA-753
  @caseStateRefusalCheck
  Scenario: Test successful notification for a refusal event
    Given the user has logged in using "Chrome"
    When the user gets the addresses for postcode "TF107BH"
    And selects case for address "BEDSIT 1"
    And the case state should be "INACTIONABLE"
    And navigates to the cases page for case "1"
    Then the case event should be "Refusal"
    And the user logs out

  @caseStateClassificationIncorrectCheck
  Scenario: Test successful notification for a classification incorrect event
    Given the user has logged in using "Chrome"
    When the user gets the addresses for postcode "TF107BH"
    And selects case for address "BEDSIT 3"
    And the case state should be "INACTIONABLE"
    And navigates to the cases page for case "3"
    Then the case event should be "Classification Incorrect"
    And the user logs out

  @caseStateUndeliverableCheck
  Scenario: Test successful notification for a undeliverable event
    Given the user has logged in using "Chrome"
    When the user gets the addresses for postcode "TF107BH"
    And selects case for address "BEDSIT 10"
    And the case state should be "INACTIONABLE"
    And navigates to the cases page for case "10"
    Then the case event should be "Undeliverable"
    And the user logs out 


  # CTPA-770
  @distributedActionsCancelled
  Scenario: Cancel Distributed Actions
  	Then check "action.case" records in DB equal 0 for "caseid = 1"
  	And check "action.case" records in DB equal 0 for "caseid = 3"
  	And check "action.case" records in DB equal 0 for "caseid = 10"
  	# NOTE: Does not yet test distributed actions are cancelled only no new actions aganist case cannot be created
