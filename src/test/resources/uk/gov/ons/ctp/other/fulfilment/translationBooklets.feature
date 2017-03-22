# Author: Stephen Goddard 03/10/2016
# Keywords Summary : This feature file contains the scenario tests other fulfilment from helpline.
#										 Detailed in: https://collaborate2.ons.gov.uk/confluence/pages/viewpage.action?pageId=3690875
#										 Note: Assumption that cases have been generated in the DB.
#
# Tasks Covered: CTPA-558 Send Service Provider Request
#								 CTPA-760 Process Service Request
#								 CTPA-579 Generate IC Print File
#													Create Event
#								 CTPA-580 Send File To Printer
#								 
# Feature: List of scenarios: Clean DB to pre test condition
#															Clean print file directory
#															Create Sample
#															IAC Generation
#															UI create request for translation booklet - Repeated for each available translation (14)
#															Generate Translation Booklet Print File
#															Create Event
#															Send File To Printer
#															UI test action created for translation booklet - Repeated for each available translation (14)
#															
# Feature Tags: @translationBooklets
#
# Scenario Tags: @cleanPrintFiles
#								 @onlineCleanEnvironment
#								 @createSample
#								 @generateIAC
#								 @polishRequest
#								 @cantoneseRequest
#								 @spanishRequest
#								 @arabicRequest
#								 @somaliRequest
#								 @mandarinRequest
#								 @bengaliRequest
#								 @portugueseRequest
#								 @gurmukhiRequest
#								 @shalmukiRequest
#								 @turkishRequest
#								 @lithuanianRequest
#								 @urduRequest
#								 @gujaratiRequest
#								 @printerFile

@translationBooklets
Feature: Test other fulfilment translation booklets

	# Clean Environment -----

	@cleanPrintFiles
	Scenario: Clean folder of previous print files by coping all existing files to /previousTests
		When create test directory "/var/actionexporter-sftp/previousTests/"
		And the exit status should be 0
		Then move print files from "/var/actionexporter-sftp/" to "/var/actionexporter-sftp/previousTests/"
		And the exit status should be 0


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
		Then I make the PUT call to the caseservice sample endpoint for sample id "2" for area "REGION" code "E12000005"
		And the response status should be 200
		And the response should contain the field "name" with value "C2EO331BIE"
		And the response should contain the field "survey" with value "2017 TEST"
		And check "casesvc.caseevent" records in DB equal 20

	@generateIAC
	Scenario: Each case has a unique IAC assigned to it and cases have been sent to the action service
			and in Actionable state
			and action service has been notified case has been created
		# Delay to allow initial print file to be generated
		Given after a delay of 150 seconds
		When check "casesvc.case" distinct records in DB equal 20 for "iac" where "state = 'ACTIONABLE'"
		And check "casesvc.case" records in DB equal 10 for "state = 'ACTIONABLE' AND casetypeid = 17"
		And check "casesvc.case" records in DB equal 10 for "state = 'ACTIONABLE' AND casetypeid = 18"
		And check "action.case" records in DB equal 1 for "caseid = 20"


	# Request Translation Booklets -----

	# CTPA-558
	@arabicRequest
  Scenario: Request Arabic translation booklet
    Given the "Test" user has logged in using "Chrome"
    When the user gets the addresses for postcode "TF107BH"
    And selects case for address "BEDSIT 1"
    And the case state for "1" should be "ACTIONABLE"
    And navigates to the cases page for case "1"
    And the user requests a translation booklet for "Arabic"
    And the user logs out

  @bengaliRequest
  Scenario: Request Bengali translation booklet
    Given the "Test" user has logged in using "Chrome"
    When the user gets the addresses for postcode "TF107BH"
    And selects case for address "BEDSIT 2"
    And the case state for "2" should be "ACTIONABLE"
    And navigates to the cases page for case "2"
    And the user requests a translation booklet for "Bengali"
    And the user logs out

  @cantoneseRequest
  Scenario: Request Cantonese translation booklet
    Given the "Test" user has logged in using "Chrome"
    When the user gets the addresses for postcode "TF107BH"
    And selects case for address "BEDSIT 3"
    And the case state for "3" should be "ACTIONABLE"
    And navigates to the cases page for case "3"
    And the user requests a translation booklet for "Cantonese"
    And the user logs out

  @gujaratiRequest
  Scenario: Request Gujarati translation booklet
    Given the "Test" user has logged in using "Chrome"
    When the user gets the addresses for postcode "TF107BH"
    And selects case for address "BEDSIT 4"
    And the case state for "4" should be "ACTIONABLE"
    And navigates to the cases page for case "4"
    And the user requests a translation booklet for "Gujarati"
    And the user logs out

  @lithuanianRequest
  Scenario: Request Lithuanian translation booklet
    Given the "Test" user has logged in using "Chrome"
    When the user gets the addresses for postcode "TF107BH"
    And selects case for address "BEDSIT 5"
    And the case state for "5" should be "ACTIONABLE"
    And navigates to the cases page for case "5"
    And the user requests a translation booklet for "Lithuanian"
    And the user logs out

  @mandarinRequest
  Scenario: Request Mandarin translation booklet
    Given the "Test" user has logged in using "Chrome"
    When the user gets the addresses for postcode "TF107BH"
    And selects case for address "BEDSIT 6"
    And the case state for "6" should be "ACTIONABLE"
    And navigates to the cases page for case "6"
    And the user requests a translation booklet for "Mandarin"
    And the user logs out

  @polishRequest
  Scenario: Request Polish translation booklet
    Given the "Test" user has logged in using "Chrome"
    When the user gets the addresses for postcode "TF107BH"
    And selects case for address "BEDSIT 7"
    And the case state for "7" should be "ACTIONABLE"
    And navigates to the cases page for case "7"
    And the user requests a translation booklet for "Polish"
    And the user logs out

  @portugueseRequest
  Scenario: Request Portuguese translation booklet
    Given the "Test" user has logged in using "Chrome"
    When the user gets the addresses for postcode "TF107BH"
    And selects case for address "BEDSIT 8"
    And the case state for "8" should be "ACTIONABLE"
    And navigates to the cases page for case "8"
    And the user requests a translation booklet for "Portuguese"
    And the user logs out

  @gurmukhiRequest
  Scenario: Request Punjabi - Gurmukhi translation booklet
    Given the "Test" user has logged in using "Chrome"
    When the user gets the addresses for postcode "TF107BH"
    And selects case for address "BEDSIT 9"
    And the case state for "9" should be "ACTIONABLE"
    And navigates to the cases page for case "9"
    And the user requests a translation booklet for "Punjabi (Gurmukhi)"
    And the user logs out

  @shalmukiRequest
  Scenario: Request Punjabi - Shalmuki translation booklet
    Given the "Test" user has logged in using "Chrome"
    When the user gets the addresses for postcode "TF107BH"
    And selects case for address "BEDSIT 10"
    And the case state for "10" should be "ACTIONABLE"
    And navigates to the cases page for case "10"
    And the user requests a translation booklet for "Punjabi (Shahmuki)"
    And the user logs out

  @somaliRequest
  Scenario: Request Somali translation booklet
    Given the "Test" user has logged in using "Chrome"
    When the user gets the addresses for postcode "TF107BN"
    And selects case for address "THE FLAT"
    And the case state for "11" should be "ACTIONABLE"
    And navigates to the cases page for case "11"
    And the user requests a translation booklet for "Somali"
    And the user logs out

  @spanishRequest
  Scenario: Request Spanish translation booklet
    Given the "Test" user has logged in using "Chrome"
    When the user gets the addresses for postcode "TF107BN"
    And selects case for address "1 BEAUMARIS ROAD"
    And the case state for "12" should be "ACTIONABLE"
    And navigates to the cases page for case "12"
    And the user requests a translation booklet for "Spanish"
    And the user logs out

  @turkishRequest
  Scenario: Request Turkish translation booklet
    Given the "Test" user has logged in using "Chrome"
    When the user gets the addresses for postcode "TF107BN"
    And selects case for address "2 BEAUMARIS ROAD"
    And the case state for "13" should be "ACTIONABLE"
    And navigates to the cases page for case "13"
    And the user requests a translation booklet for "Turkish"
    And the user logs out

  @urduRequest
  Scenario: Request Urdu translation booklet
    Given the "Test" user has logged in using "Chrome"
    When the user gets the addresses for postcode "TF107BN"
    And selects case for address "3 BEAUMARIS ROAD"
    And the case state for "14" should be "ACTIONABLE"
    And navigates to the cases page for case "14"
    And the user requests a translation booklet for "Urdu"
    And the user logs out


	# Translation Booklet Print File Creation -----

	# CTPA-579
	# CTPA-580
	@printerFile
	Scenario: Test action plan has created translation booklet file for fullfilment
		Given after a delay of 150 seconds
		Then get the contents of the file from "/var/actionexporter-sftp/" where the filename begins "TRANSLATION"
		And the exit status should be 0
		And and the contents should contain "QGSHA"
		And and the contents should contain "|1000000000000010|||||BEDSIT 10|133 HIGH STREET||NEWPORT|TF10 7BH"
		And and the contents should contain "QGPOL"
		And and the contents should contain "|1000000000000007|||||BEDSIT 7|133 HIGH STREET||NEWPORT|TF10 7BH"
		And and the contents should contain "QGBEN"
		And and the contents should contain "|1000000000000002|||||BEDSIT 2|133 HIGH STREET||NEWPORT|TF10 7BH"
		And and the contents should contain "QGURD"
		And and the contents should contain "|1000000000000014|||||VINADO|3 BEAUMARIS ROAD||NEWPORT|TF10 7BN"
		And and the contents should contain "QGPOR"
		And and the contents should contain "|1000000000000008|||||BEDSIT 8|133 HIGH STREET||NEWPORT|TF10 7BH"
		And and the contents should contain "QGCAN"
		And and the contents should contain "|1000000000000003|||||BEDSIT 3|133 HIGH STREET||NEWPORT|TF10 7BH"
		And and the contents should contain "QGARA"
		And and the contents should contain "|1000000000000001|||||BEDSIT 1|133 HIGH STREET||NEWPORT|TF10 7BH"
		And and the contents should contain "QGSOM"
		And and the contents should contain "|1000000000000011|||||THE FLAT|HONEYSUCKLE INN BEAUMARIS ROAD||NEWPORT|TF10 7BN"
		And and the contents should contain "QGTUR"
		And and the contents should contain "|1000000000000013||||||2 BEAUMARIS ROAD||NEWPORT|TF10 7BN"
		And and the contents should contain "QGMAN"
		And and the contents should contain "|1000000000000006|||||BEDSIT 6|133 HIGH STREET||NEWPORT|TF10 7BH"
		And and the contents should contain "QGLIT"
		And and the contents should contain "|1000000000000005|||||BEDSIT 5|133 HIGH STREET||NEWPORT|TF10 7BH"
		And and the contents should contain "QGSPA"
		And and the contents should contain "|1000000000000012||||||1 BEAUMARIS ROAD||NEWPORT|TF10 7BN"
		And and the contents should contain "QGGUR"
		And and the contents should contain "|1000000000000009|||||BEDSIT 9|133 HIGH STREET||NEWPORT|TF10 7BH"


	# Test UI For Translation Booklet Print File Creation -----

  @arabicRequest @request
  Scenario: Tests that the case event created for Arabic translation booklet
    Given the "Test" user has logged in using "Chrome"
    When the user gets the addresses for postcode "TF107BH"
    And selects case for address "BEDSIT 1"
    And the case state for "1" should be "ACTIONABLE"
    And navigates to the cases page for case "1"
    Then the case event category should contain "Arabic Translation"
    And the case event category should contain "Action Created"
    And the case action should be "Completed"
    And the user logs out

  @bengaliRequest
  Scenario: Tests that the case event created for Bengali translation booklet
    Given the "Test" user has logged in using "Chrome"
    When the user gets the addresses for postcode "TF107BH"
    And selects case for address "BEDSIT 2"
    And the case state for "2" should be "ACTIONABLE"
    And navigates to the cases page for case "2"
    Then the case event category should contain "Bengali Translation"
    And the case event category should contain "Action Created"
    And the case action should be "Completed"
    And the user logs out

  @cantoneseRequest
  Scenario: Tests that the case event created for Cantonese translation booklet
    Given the "Test" user has logged in using "Chrome"
    When the user gets the addresses for postcode "TF107BH"
    And selects case for address "BEDSIT 3"
    And the case state for "3" should be "ACTIONABLE"
    And navigates to the cases page for case "3"
    Then the case event category should contain "Cantonese Translation"
    And the case event category should contain "Action Created"
    And the case action should be "Completed"
    And the user logs out

  @gujaratiRequest
  Scenario: Tests that the case event created for Gujarati translation booklet
    Given the "Test" user has logged in using "Chrome"
    When the user gets the addresses for postcode "TF107BH"
    And selects case for address "BEDSIT 4"
    And the case state for "4" should be "ACTIONABLE"
    And navigates to the cases page for case "4"
    Then the case event category should contain "Gujarati Translation"
    And the case event category should contain "Action Created"
    And the case action should be "Completed"
    And the user logs out

  @lithuanianRequest
  Scenario: Tests that the case event created for Lithuanian translation booklet
    Given the "Test" user has logged in using "Chrome"
    When the user gets the addresses for postcode "TF107BH"
    And selects case for address "BEDSIT 5"
    And the case state for "5" should be "ACTIONABLE"
    And navigates to the cases page for case "5"
    Then the case event category should contain "Lithuanian Translation"
    And the case event category should contain "Action Created"
    And the case action should be "Completed"
    And the user logs out

  @mandarinRequest
  Scenario: Tests that the case event created for Mandarin translation booklet
    Given the "Test" user has logged in using "Chrome"
    When the user gets the addresses for postcode "TF107BH"
    And selects case for address "BEDSIT 6"
    And the case state for "6" should be "ACTIONABLE"
    And navigates to the cases page for case "6"
    Then the case event category should contain "Mandarin Translation"
    And the case event category should contain "Action Created"
    And the case action should be "Completed"
    And the user logs out

  @polishRequest
  Scenario: Tests that the case event created for Polish translation booklet
    Given the "Test" user has logged in using "Chrome"
    When the user gets the addresses for postcode "TF107BH"
    And selects case for address "BEDSIT 7"
    And the case state for "7" should be "ACTIONABLE"
    And navigates to the cases page for case "7"
    Then the case event category should contain "Polish Translation"
    And the case event category should contain "Action Created"
    And the case action should be "Completed"
    And the user logs out

  @portugueseRequest
  Scenario: Tests that the case event created for Portuguese translation booklet
    Given the "Test" user has logged in using "Chrome"
    When the user gets the addresses for postcode "TF107BH"
    And selects case for address "BEDSIT 8"
    And the case state for "8" should be "ACTIONABLE"
    And navigates to the cases page for case "8"
    Then the case event category should contain "Portuguese Translation"
    And the case event category should contain "Action Created"
    And the case action should be "Completed"
    And the user logs out

  @gurmukhiRequest
  Scenario: Tests that the case event created for Punjabi - Gurmukhi translation booklet
    Given the "Test" user has logged in using "Chrome"
    When the user gets the addresses for postcode "TF107BH"
    And selects case for address "BEDSIT 9"
    And the case state for "9" should be "ACTIONABLE"
    And navigates to the cases page for case "9"
    Then the case event category should contain "Punjabi (Gurmukhi) Translation"
    And the case event category should contain "Action Created"
    And the case action should be "Completed"
    And the user logs out

	@shalmukiRequest
  Scenario: Tests that the case event created for Punjabi - Shalmuki translation booklet
    Given the "Test" user has logged in using "Chrome"
    When the user gets the addresses for postcode "TF107BH"
    And selects case for address "BEDSIT 10"
    And the case state for "10" should be "ACTIONABLE"
    And navigates to the cases page for case "10"
    Then the case event category should contain "Punjabi (Shahmuki) Translation"
    And the case event category should contain "Action Created"
    And the case action should be "Completed"
    And the user logs out

  @somaliRequest
  Scenario: Tests that the case event created for Somali translation booklet
    Given the "Test" user has logged in using "Chrome"
    When the user gets the addresses for postcode "TF107BN"
    And selects case for address "THE FLAT"
    And the case state for "11" should be "ACTIONABLE"
    And navigates to the cases page for case "11"
    Then the case event category should contain "Somali Translation"
    And the case event category should contain "Action Created"
    And the case action should be "Completed"
    And the user logs out

  @spanishRequest
  Scenario: Tests that the case event created for Spanish translation booklet
    Given the "Test" user has logged in using "Chrome"
    When the user gets the addresses for postcode "TF107BN"
    And selects case for address "1 BEAUMARIS ROAD"
    And the case state for "12" should be "ACTIONABLE"
    And navigates to the cases page for case "12"
    Then the case event category should contain "Spanish Translation"
    And the case event category should contain "Action Created"
    And the case action should be "Completed"
    And the user logs out

  @turkishRequest
  Scenario: Tests that the case event created for Turkish translation booklet
    Given the "Test" user has logged in using "Chrome"
    When the user gets the addresses for postcode "TF107BN"
    And selects case for address "2 BEAUMARIS ROAD"
    And the case state for "13" should be "ACTIONABLE"
    And navigates to the cases page for case "13"
    Then the case event category should contain "Turkish Translation"
    And the case event category should contain "Action Created"
    And the case action should be "Completed"
    And the user logs out

  @urduRequest
  Scenario: Tests that the case event created for Urdu translation booklet
    Given the "Test" user has logged in using "Chrome"
    When the user gets the addresses for postcode "TF107BN"
    And selects case for address "3 BEAUMARIS ROAD"
    And the case state for "14" should be "ACTIONABLE"
    And navigates to the cases page for case "14"
    Then the case event category should contain "Urdu Translation"
    And the case event category should contain "Action Created"
    And the case action should be "Completed"
    And the user logs out
