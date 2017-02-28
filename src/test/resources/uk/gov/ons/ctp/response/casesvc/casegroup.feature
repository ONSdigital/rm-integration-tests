# Author: Stephen Goddard 29/09/2016
#
# Keywords Summary : This feature file contains the scenario tests for the casesvc - casegroup - details are in the swagger spec
#										 https://github.com/ONSdigital/response-management-service/blob/master/casesvc-api/swagger.yml
#										 Note: Assumption that the DB has been loaded with seed data.
#
# Feature: List of action plan mappings scenarios: Clean DB to pre test condition
#																									 Create Sample
#																									 Confirms system is ready for test
#																									 Get the casegroup identified by uprn
#																									 Get the casegroup identified by an invalid uprn
#																									 Get the casegroup linked to by casegroupid
#																									 Get the casegroup linked to by an invalid casegroupid
# Feature Tags: @casesvc
#								@case
#
# Scenario Tags: @casegroupCleanEnvironment
#								 @createCasegroupSample
#								 @createCaseGroupCases
#								 @casegroup

@casesvc @case
Feature: Validating Case Group requests

	# Clean Environment -----

  @casegroupCleanEnvironment
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

	@createCasegroupSample
	Scenario: Put request for sample to create online cases for the specified sample id
		When I make the PUT call to the caseservice sample endpoint for sample id "1" for area "REGION" code "E12000005"
		Then the response status should be 200
		And the response should contain the field "name" with value "C2EO332E"
		And the response should contain the field "survey" with value "2017 TEST"
		And check "casesvc.caseevent" records in DB equal 10

	@createCaseGroupCases
	Scenario: Get request to case for highest expected case id
		Given after a delay of 30 seconds
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


	# Endpoint Tests -----

	# GET /casegroup/uprn/{uprn}
	# 200
	@casegroup
	Scenario: Get request to casegroup for specific uprn
		When I make the GET call to the caseservice casegroup endpoint for uprn "10090446358"
		Then the response status should be 200
		And the response should contain a JSON array of size 1
		And one element of the JSON array must be {"caseGroupId":10,"sampleId":1,"uprn":10090446358}

	# 404
  @casegroup
	Scenario: Get request to casegroup for non existing uprn
		When I make the GET call to the caseservice casegroup endpoint for uprn "9999"
		Then the response status should be 404
		And the response should contain the field "error.code" with value "RESOURCE_NOT_FOUND"
		And the response should contain the field "error.message" with value "Address not found for UPRN 9999"
		And the response should contain the field "error.timestamp"

	# GET /casegroup/{caseGroupId}
	# 200
	@casegroup
	Scenario: Get request to casegroup for specific casegroupid
		When I make the GET call to the caseservice casegroup endpoint for casegroupid "1"
		Then the response status should be 200
		And the response should contain the field "caseGroupId" with an integer value of 1
		And the response should contain the field "sampleId" with an integer value of 1
		And the response should contain the field "uprn" with a long value of 10090446349

	# 404
  @casegroup
	Scenario: Get request to casegroup for non existing casegroupid
		When I make the GET call to the caseservice casegroup endpoint for casegroupid "101"
		Then the response status should be 404
		And the response should contain the field "error.code" with value "RESOURCE_NOT_FOUND"
		And the response should contain the field "error.message" with value "CaseGroup not found for casegroup id 101"
		And the response should contain the field "error.timestamp"
