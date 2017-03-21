# Author: Stephen Goddard 15/06/2016
# Keywords Summary : This feature tests create events using the UI
#										 Detailed in: https://collaborate2.ons.gov.uk/confluence/display/SDC/Helpline+Interface+Test+Scenarios
#										 Note: Assumption that the DB has been loaded with seed data.
#
# Feature: List of scenarios: Clean DB to pre test condition
#															Create Sample
#															IAC Generation
#                             UI created case event and test event and case states using Chrome
#                             UI created case escalated event and test event and case states using Chrome
#
# Feature Tag: @helplineUI
#							 @uiEvents
#
# Scenario Tags: @uiCleanEnvironment
#                @uiCreateSample
#                @generateIAC
#                @createEvent

@helplineUI @uiEvents
Feature: Test UI create events scenarios

	# Clean Environment -----

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


	# Sample Creation -----

	@uiCreateSample
	Scenario: Put request for sample to create online cases for the specified sample id
		When I make the PUT call to the caseservice sample endpoint for sample id "1" for area "REGION" code "E12000005"
		Then the response status should be 200
		And the response should contain the field "name" with value "C2EO332E"
		And the response should contain the field "survey" with value "2017 TEST"
		Then I make the PUT call to the caseservice sample endpoint for sample id "2" for area "REGION" code "E12000005"
		And the response status should be 200
		And the response should contain the field "name" with value "C2EO331BIE"
		And the response should contain the field "survey" with value "2017 TEST"
		And check "casesvc.caseevent" records in DB equal 20

	@generateIAC
	Scenario: Each case has a unique IAC assigned to it
			and in Actionable state
			and action service has been notified case has been created
		Given after a delay of 90 seconds
		When check "casesvc.case" distinct records in DB equal 20 for "iac" where "state = 'ACTIONABLE'"
		And check "casesvc.case" records in DB equal 10 for "state = 'ACTIONABLE' AND casetypeid = 17"
		And check "casesvc.case" records in DB equal 10 for "state = 'ACTIONABLE' AND casetypeid = 18"
		And check "action.case" records in DB equal 1 for "caseid = 20"


  @createEvent
  Scenario: Create an Accessibility case event
    Given the "Test" user has logged in using "Chrome"
    When the user gets the addresses for postcode "TF107BH"
    And selects case for address "BEDSIT 1"
    And navigates to the cases page for case "1"
    And the user creates a new event for
      | Accessibility Materials | Test description. | integration.tester | 01234 567890 |
    Then the case event should be "Accessibility Materials"
    And the case event description should be "name: Lord integration.tester integration.tester phone: 01234 567890 Test description."
    And the user goes back to the cases page
    And the case state for "1" should be "ACTIONABLE"
    And the user logs out

  @createEvent
  Scenario: Create an address details incorrect case event
    Given the "Test" user has logged in using "Chrome"
    When the user gets the addresses for postcode "TF107BH"
    And selects case for address "BEDSIT 2"
    And navigates to the cases page for case "2"
    And the user creates a new event for
      | Address Details Incorrect | Test description. | integration.tester | 01234 567890 |
    Then the case event should be "Address Details Incorrect"
    And the case event description should be "name: Lord integration.tester integration.tester phone: 01234 567890 Test description."
    And the user goes back to the cases page
    And the case state for "2" should be "ACTIONABLE"
    And the user logs out

	@createEvent
  Scenario: Create a Classification Incorrect case event - full testing found in helpline.feature
    Given the "Test" user has logged in using "Chrome"
    When the user gets the addresses for postcode "TF107BH"
    And selects case for address "BEDSIT 3"
    And navigates to the cases page for case "3"
    And the user creates a new event for
      | Classification Incorrect | Test description. | integration.tester | 01234 567890 |
    Then the case event should be "Classification Incorrect"
    And the case event description should be "name: Lord integration.tester integration.tester phone: 01234 567890 Test description."
    And after a delay of 20 seconds
    And the user goes back to the cases page
    And the case state for "3" should be "INACTIONABLE"
    And the user logs out

  @createEvent
  Scenario: Create a Field Complaint Escalated case event
    Given the "Test" user has logged in using "Chrome"
    When the user gets the addresses for postcode "TF107BH"
    And selects case for address "BEDSIT 4"
    And navigates to the cases page for case "4"
    And the user creates a new event for
      | Field Complaint - Escalated | Test description. | integration.tester | 01234 567890 |
    Then the case event should be "Field Complaint - Escalated"
    And the case event description should be "name: Lord integration.tester integration.tester phone: 01234 567890 Test description."
    And the user goes back to the cases page
    And the case state for "4" should be "ACTIONABLE"
    And the user logs out

  @createEvent
  Scenario: Create a Field Emergency Escalated case event
    Given the "Test" user has logged in using "Chrome"
    When the user gets the addresses for postcode "TF107BH"
    And selects case for address "BEDSIT 5"
    And navigates to the cases page for case "5"
    And the user creates a new event for
      | Field Emergency - Escalated | Test description. | integration.tester | 01234 567890 |
    Then the case event should be "Field Emergency - Escalated"
    And the case event description should be "name: Lord integration.tester integration.tester phone: 01234 567890 Test description."
    And the user goes back to the cases page
    And the case state for "5" should be "ACTIONABLE"
    And the user logs out

	@createEvent
  Scenario: Create a General Complaint case event
    Given the "Test" user has logged in using "Chrome"
    When the user gets the addresses for postcode "TF107BH"
    And selects case for address "BEDSIT 6"
    And navigates to the cases page for case "6"
    And the user creates a new event for
      | General Complaint | Test description. | integration.tester | 01234 567890 |
    Then the case event should be "General Complaint"
    And the case event description should be "name: Lord integration.tester integration.tester phone: 01234 567890 Test description."
    And the user goes back to the cases page
    And the case state for "6" should be "ACTIONABLE"
    And the user logs out

	@createEvent
  Scenario: Create a General Complaint - Escalated case event
    Given the "Test" user has logged in using "Chrome"
    When the user gets the addresses for postcode "TF107BH"
    And selects case for address "BEDSIT 7"
    And navigates to the cases page for case "7"
    And the user creates a new event for
      | General Complaint - Escalated | Test description. | integration.tester | 01234 567890 |
    Then the case event should be "General Complaint - Escalated"
    And the case event description should be "name: Lord integration.tester integration.tester phone: 01234 567890 Test description."
    And the user goes back to the cases page
    And the case state for "7" should be "ACTIONABLE"
    And the user logs out

	@createEvent
  Scenario: Create a General Enquiry case event
    Given the "Test" user has logged in using "Chrome"
    When the user gets the addresses for postcode "TF107BH"
    And selects case for address "BEDSIT 8"
    And navigates to the cases page for case "8"
    And the user creates a new event for
      | General Enquiry | Test description. | integration.tester | 01234 567890 |
    Then the case event should be "General Enquiry"
    And the case event description should be "name: Lord integration.tester integration.tester phone: 01234 567890 Test description."
    And the user goes back to the cases page
    And the case state for "8" should be "ACTIONABLE"
    And the user logs out

	@createEvent
  Scenario: Create a General Enquiry – Escalated case event
    Given the "Test" user has logged in using "Chrome"
    When the user gets the addresses for postcode "TF107BH"
    And selects case for address "BEDSIT 9"
    And navigates to the cases page for case "9"
    And the user creates a new event for
      | General Enquiry - Escalated | Test description. | integration.tester | 01234 567890 |
    Then the case event should be "General Enquiry - Escalated"
    And the case event description should be "name: Lord integration.tester integration.tester phone: 01234 567890 Test description."
    And the user goes back to the cases page
    And the case state for "9" should be "ACTIONABLE"
    And the user logs out

  @createEvent
  Scenario: Create a Miscellaneous case event
    Given the "Test" user has logged in using "Chrome"
    When the user gets the addresses for postcode "TF107BH"
    And selects case for address "BEDSIT 10"
    And navigates to the cases page for case "10"
    And the user creates a new event for
      | Miscellaneous | Test description. | integration.tester | 01234 567890 |
    Then the case event should be "Miscellaneous"
    And the case event description should be "name: Lord integration.tester integration.tester phone: 01234 567890 Test description."
    And the user goes back to the cases page
    And the case state for "10" should be "ACTIONABLE"
    And the user logs out

  @createEvent
  Scenario: Create a refusal case event - full testing found in helpline.feature
    Given the "Test" user has logged in using "Chrome"
    When the user gets the addresses for postcode "TF107BN"
    And selects case for address "THE FLAT"
    And navigates to the cases page for case "11"
    And the user creates a new event for
      | Refusal | Test description. | integration.tester | 01234 567890 |
    #And after a delay of 10 seconds
    Then the case event should be "Refusal"
    And the case event description should be "name: Lord integration.tester integration.tester phone: 01234 567890 Test description."
    And after a delay of 20 seconds
    And the user goes back to the cases page
    And the case state for "11" should be "INACTIONABLE"
    And the user logs out

  @createEvent
  Scenario: Create a Technical Query case event
    Given the "Test" user has logged in using "Chrome"
    When the user gets the addresses for postcode "TF107BN"
    And selects case for address "1 BEAUMARIS ROAD"
    And navigates to the cases page for case "12"
    And the user creates a new event for
      | Technical Query | Test description. | integration.tester | 01234 567890 |
    Then the case event should be "Technical Query"
    And the case event description should be "name: Lord integration.tester integration.tester phone: 01234 567890 Test description."
    And the user goes back to the cases page
    And the case state for "12" should be "ACTIONABLE"
    And the user logs out

	@createEvent
  Scenario: Create an Undeliverable case event - full testing found in helpline.feature
    Given the "Test" user has logged in using "Chrome"
    When the user gets the addresses for postcode "TF107BN"
    And selects case for address "2 BEAUMARIS ROAD"
    And navigates to the cases page for case "13"
    And the user creates a new event for
      | Undeliverable | Test description. | integration.tester | 01234 567890 |
    Then the case event should be "Undeliverable"
    And the case event description should be "name: Lord integration.tester integration.tester phone: 01234 567890 Test description."
    And after a delay of 20 seconds
    And the user goes back to the cases page
    And the case state for "13" should be "INACTIONABLE"
    And the user logs out

  @createEvent
  Scenario: Create a case event with 250 characters
    Given the "Test" user has logged in using "Chrome"
    When the user gets the addresses for postcode "TF107BN"
    And selects case for address "3 BEAUMARIS ROAD"
    And navigates to the cases page for case "14"
    And the user creates a new event for
      | Technical Query | Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. Aenean massa. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Donec quam felis, ultricies nec, pellentesque eu, pretium. | integration.tester | 01234 567890 |
    Then the case event should be "Technical Query"
    And the case event description should be "name: Lord integration.tester integration.tester phone: 01234 567890 Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. Aenean massa. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Donec quam felis, ultricies nec, pellentesque eu, pretium."
    And the user goes back to the cases page
    And the case state for "14" should be "ACTIONABLE"
    And the user logs out
