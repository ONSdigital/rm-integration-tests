# Author: Stephen Goddard 29/09/2016
#
# Keywords Summary : This feature file contains the scenario tests for the sdxgateway - receipt - details are in the swagger spec
#										 https://github.com/ONSdigital/rm-sdx-gateway/blob/master/swagger.yml
#
# Feature: List of survey data exchange scenarios: Clean DB to pre test condition
#																									 Create Samples
#																									 Post a valid response
#																									 Post a response with missing caseref
#																									 Post an invalid response
#																									 Post a valid csv file
#																									 Post a invalid csv file
#																									 Post with invalid entries
#																									 Post with an invalid entry
#																									 Confirm UI shows online receipt
#																									 Confirm UI shows paper receipt (9 cases checked)
#																									 Confirms unlinked receipt is correctly stored in DB
#
# Feature Tags: @sdxGateway
#
# Scenario Tags: @sdxCleanEnvironment
#								 @createSdxSamples
#								 @generateOnlineIAC
#								 @questionnaireReceipts
#								 @paperQuestionnaireReceipts
#								 @onlineRespondedUI
#								 @paperRespondedUI
#								 @unlinkedCheck

@sdxGateway
Feature: Validating SDX Gateway requests

	# Clean Environment -----

  @sdxCleanEnvironment
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

	@createSdxSamples
	Scenario: Put request for sample to create online cases for the specified sample id
		When I make the PUT call to the caseservice sample endpoint for sample id "1" for area "REGION" code "E12000005"
		Then the response status should be 200
		And the response should contain the field "name" with value "C2EO332E"
		And the response should contain the field "survey" with value "2017 TEST"
		Then I make the PUT call to the caseservice sample endpoint for sample id "15" for area "REGION" code "E12000005"
		And the response status should be 200
		And the response should contain the field "name" with value "C2SP331E"
		And the response should contain the field "survey" with value "2017 TEST"
		And check "casesvc.caseevent" records in DB equal 20

	@generateOnlineIAC
	Scenario: Each case has a unique IAC assigned to it - confirms system is ready for test
			and in Actionable state
			and action service has been notified case has been created
		Given after a delay of 20 seconds
		When check "casesvc.case" distinct records in DB equal 20 for "iac" where "state = 'ACTIONABLE'"
		And check "casesvc.case" records in DB equal 10 for "state = 'ACTIONABLE' AND casetypeid = 17"
		And check "casesvc.case" records in DB equal 10 for "state = 'ACTIONABLE' AND casetypeid = 9"
		And check "action.case" records in DB equal 1 for "caseid = 20"


	# Endpoint Tests -----

	# POST /questionnairereceipts
	# 201
	@questionnaireReceipts
	Scenario: Post request for SDX Gateway endpoint for responses specific caseref
		When I make the POST call to the SDX Gateway online receipt for caseref "1000000000000001"
		Then the response status should be 201
		And the response should contain the field "caseRef" with value "1000000000000001"

	# 400
	@questionnaireReceipts
	Scenario: Post request for SDX Gateway endpoint for missing caseref
		When I make the POST call to the SDX Gateway online receipt for missing caseref
		Then the response status should be 400
		And the response should contain the field "error.code" with value "VALIDATION_FAILED"
		And the response should contain the field "error.message" with value "Provided json fails validation."
		And the response should contain the field "error.timestamp"

	# 400
	@questionnaireReceipts
	Scenario: Post request for SDX Gateway endpoint for invalid input
		When I make the POST call to the SDX Gateway online receipt for invalid input
		Then the response status should be 400
		And the response should contain the field "error.code" with value "VALIDATION_FAILED"
		And the response should contain the field "error.message" with value "Provided json is incorrect."
		And the response should contain the field "error.timestamp"


	# POST /paperquestionnairereceipts
	# 201
	@paperQuestionnaireReceipts
	Scenario: Post request for SDX Gateway paper endpoint for csv file - Valid dates
		When I make the POST call to the SDX Gateway paper receipt for
			| 25/12/2016,1000000000000011 |
			| 25/12/2016,1000000000000012 |
			| 25/12/2016,1000000000000013 |
		Then the response status should be 201

	#400
	#@paperQuestionnaireReceipts
	#Scenario: Post request for SDX Gateway paper endpoint for csv file with invalid content
	#	When I make the POST call to the SDX Gateway paper receipt for
	#		|  |
	#	Then the response status should be 400
	#	And the response should contain the field "error.code" with value "VALIDATION_FAILED"
	#	And the response should contain the field "error.message" with value "No record found."
	#	And the response should contain the field "error.timestamp"

	#400
	@paperQuestionnaireReceipt
	Scenario: Post request for SDX Gateway paper endpoint for csv file with invalid content
		When I make the POST call to the SDX Gateway paper receipt for empty file
		Then the response status should be 400
		And the response should contain the field "error.code" with value "VALIDATION_FAILED"
		And the response should contain the field "error.message" with value "No record found."
		And the response should contain the field "error.timestamp"

	#201
	@paperQuestionnaireReceipts
	Scenario: Post request for SDX Gateway paper endpoint for csv file with invalid dates
		When I make the POST call to the SDX Gateway paper receipt for 
			| a,1000000000000015 |
			| b,1000000000000016 |
			| c,1000000000000017 |
		Then the response status should be 201

	#201
	@paperQuestionnaireReceipts
	Scenario: Post request for SDX Gateway paper endpoint for csv file with some invalid dates and some incorrect date format
		When I make the POST call to the SDX Gateway paper receipt for
			| 2016-08-04T21:37:01.537Z,1000000000000018 |
			| ,1000000000000019 |
			| 2016-08-04T21:37:01.537Z,1000000000000020 |
			| 2016-08-04T21:37:01.537Z,1000000000000021 |
		Then the response status should be 201


	Scenario: Add to delay to allow the system to complete updates
		Given after a delay of 90 seconds		


	# UI Response Tests -----

	@onlineRespondedUI
	Scenario: Confirmed the UI reflects the online response receipt
		Given the "Test" user has logged in using "Chrome"
    Then the user gets the addresses for postcode "TF107BH"
    And selects case for address "BEDSIT 1"
    And the case state for "1" should be "INACTIONABLE"
    And navigates to the cases page for case "1"
    Then the case event should be "Online Questionnaire Response"
		And the user logs out

	@paperRespondedUI
	Scenario: Confirmed the UI reflects the paper response receipt
		Given the "Test" user has logged in using "Chrome"
    Then the user gets the addresses for postcode "TF13LG"
    And selects case for address "11 EMRAL RISE"
    And the case state for "11" should be "INACTIONABLE"
    And navigates to the cases page for case "11"
    Then the case event should be "Paper Questionnaire Response"
		And the user logs out

	@paperRespondedUI
	Scenario: Confirmed the UI reflects the paper response receipt
		Given the "Test" user has logged in using "Chrome"
    Then the user gets the addresses for postcode "TF13LG"
    And selects case for address "12 EMRAL RISE"
    And the case state for "12" should be "INACTIONABLE"
    And navigates to the cases page for case "12"
    Then the case event should be "Paper Questionnaire Response"
		And the user logs out
		
	@paperRespondedUI
	Scenario: Confirmed the UI reflects the paper response receipt
		Given the "Test" user has logged in using "Chrome"
    Then the user gets the addresses for postcode "TF13LG"
    And selects case for address "13 EMRAL RISE"
    And the case state for "13" should be "INACTIONABLE"
    And navigates to the cases page for case "13"
    Then the case event should be "Paper Questionnaire Response"
		And the user logs out

	@paperRespondedUI
	Scenario: Confirmed the UI reflects no paper response received
		Given the "Test" user has logged in using "Chrome"
    Then the user gets the addresses for postcode "TF13LG"
    And selects case for address "14 EMRAL RISE"
    And the case state for "14" should be "ACTIONABLE"
    And navigates to the cases page for case "14"
    Then the case event should be "Action Created"
		And the user logs out

	@paperRespondedUI
	Scenario: Confirmed the UI reflects the paper response receipt
		Given the "Test" user has logged in using "Chrome"
    Then the user gets the addresses for postcode "TF13LG"
    And selects case for address "15 EMRAL RISE"
    And the case state for "15" should be "INACTIONABLE"
    And navigates to the cases page for case "15"
    Then the case event should be "Paper Questionnaire Response"
		And the user logs out

	@paperRespondedUI
	Scenario: Confirmed the UI reflects the paper response receipt
		Given the "Test" user has logged in using "Chrome"
    Then the user gets the addresses for postcode "TF13LG"
    And selects case for address "16 EMRAL RISE"
    And the case state for "16" should be "INACTIONABLE"
    And navigates to the cases page for case "16"
    Then the case event should be "Paper Questionnaire Response"
		And the user logs out

	@paperRespondedUI
	Scenario: Confirmed the UI reflects the paper response receipt
		Given the "Test" user has logged in using "Chrome"
    Then the user gets the addresses for postcode "TF13LG"
    And selects case for address "17 EMRAL RISE"
    And the case state for "17" should be "INACTIONABLE"
    And navigates to the cases page for case "17"
    Then the case event should be "Paper Questionnaire Response"
		And the user logs out

	@paperRespondedUI
	Scenario: Confirmed the UI reflects the paper response receipt
		Given the "Test" user has logged in using "Chrome"
    Then the user gets the addresses for postcode "TF13LG"
    And selects case for address "18 EMRAL RISE"
    And the case state for "18" should be "INACTIONABLE"
    And navigates to the cases page for case "18"
    Then the case event should be "Paper Questionnaire Response"
		And the user logs out

	@paperRespondedUI
	Scenario: Confirmed the UI reflects the paper response receipt
		Given the "Test" user has logged in using "Chrome"
    Then the user gets the addresses for postcode "TF13LG"
    And selects case for address "19 EMRAL RISE"
    And the case state for "19" should be "INACTIONABLE"
    And navigates to the cases page for case "19"
    Then the case event should be "Paper Questionnaire Response"
		And the user logs out

	@paperRespondedUI
	Scenario: Confirmed the UI reflects the paper response receipt
		Given the "Test" user has logged in using "Chrome"
    Then the user gets the addresses for postcode "TF13LG"
    And selects case for address "20 EMRAL RISE"
    And the case state for "20" should be "INACTIONABLE"
    And navigates to the cases page for case "20"
    Then the case event should be "Paper Questionnaire Response"
		And the user logs out
		
	@unlinkedCheck
	Scenario: Confirmed the invalid case ref has been sent to the unlinked table
		Then check "casesvc.unlinkedcasereceipt" records in DB equal 1 for "caseref = '1000000000000021'"


	# CTPA-1048 Paper Receipting - date/time being updated on case record

	Scenario: Get request to cases for case responded with valid date as responeded above
		When I make the GET call to the caseservice cases endpoint for case "11"
		Then the response status should be 200
		And the response should contain the field "caseId" with an integer value of 11
		And the response should contain the field "caseGroupId" with an integer value of 11
		And the response should contain the field "caseRef" with value "1000000000000011"
		And the response should contain the field "state" with value "INACTIONABLE"
		And the response should contain the field "caseTypeId" with an integer value of 9
		And the response should contain the field "actionPlanMappingId" with an integer value of 9
		And the response should contain the field "createdDateTime"
		And the response should contain the field "createdBy" with value "SYSTEM"
		And the response should contain the field "iac"
		And the response should contain the field "responses" with one element of the JSON array must be [{"inboundChannel":"PAPER","dateTime":"2016-12-25T00:00:00.000+0000"}]
		And the response should contain the field "contact" with a null value

	Scenario: Get request to cases for case responded with invalid date as responeded above
		When I make the GET call to the caseservice cases endpoint for case "15"
		Then the response status should be 200
		And the response should contain the field "caseId" with an integer value of 15
		And the response should contain the field "caseGroupId" with an integer value of 15
		And the response should contain the field "caseRef" with value "1000000000000015"
		And the response should contain the field "state" with value "INACTIONABLE"
		And the response should contain the field "caseTypeId" with an integer value of 9
		And the response should contain the field "actionPlanMappingId" with an integer value of 9
		And the response should contain the field "createdDateTime"
		And the response should contain the field "createdBy" with value "SYSTEM"
		And the response should contain the field "iac"
		And the response should contain the field "responses" with one element of the JSON array must be [{"inboundChannel":"PAPER","dateTime":"2017-
		And the response should contain the field "contact" with a null value
		
	Scenario: Get request to cases for case responded with invalid date format as responeded above
		When I make the GET call to the caseservice cases endpoint for case "18"
		Then the response status should be 200
		And the response should contain the field "caseId" with an integer value of 18
		And the response should contain the field "caseGroupId" with an integer value of 18
		And the response should contain the field "caseRef" with value "1000000000000018"
		And the response should contain the field "state" with value "INACTIONABLE"
		And the response should contain the field "caseTypeId" with an integer value of 9
		And the response should contain the field "actionPlanMappingId" with an integer value of 9
		And the response should contain the field "createdDateTime"
		And the response should contain the field "createdBy" with value "SYSTEM"
		And the response should contain the field "iac"
		And the response should contain the field "responses" with one element of the JSON array must be [{"inboundChannel":"PAPER","dateTime":"2017-
		And the response should contain the field "contact" with a null value
