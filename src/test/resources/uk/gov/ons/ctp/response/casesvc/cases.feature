# Author: Stephen Goddard 04/03/2016
#
# Keywords Summary : This feature file contains the scenario tests for the casesvc - cases - details are in the swagger spec
#										 https://github.com/ONSdigital/response-management-service/blob/master/casesvc-api/swagger.yml
#										 Note: Assumption that the DB has been loaded with seed data.
#
# Feature: List of cases scenarios: Clean DB to pre test condition
#																		Create Sample
#																		Confirms system is ready for testPut cases response by external reference
#																		Put cases response by invalid external reference
#																		Get casegroup by valid casegroupid
#																		Get casegroup by invalid casegroupid
#																		Post casegroup by valid casegroupid
#																		Post casegroup by invalid json
#																		Get cases by valid case
#																		Get cases by invalid case
#																		Put cases deactivate by valid case
#																		Put cases deactivate by invalid case
#																		Get cases by valid action plan
#																		Get cases by invalid action plan
#																		Get cases by valid action plan with filter
#																		Get cases by invalid action plan with filter
#																		Post case events by valid case
#																		Post case events with invalid json
#																		Post case events by invalid case
#																		Get case events by valid case
#																		Get case events by invalid case
#
# Feature Tags: @casesvc
#								@case
#
# Scenario Tags: @casesCleanEnvironment
#								 @cases
#								 @createcasesSample

@casesvc @case
Feature: Validating cases requests

	# Clean Environment -----

  @casesCleanEnvironment @cases
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


	# Cases Sample Creation -----

	# CTPA-624
	# PUT /samples/{sampleId}
	# 200
	@createCasesSample @cases
	Scenario: Put request for sample to create online cases for the specified sample id
		When I make the PUT call to the caseservice sample endpoint for sample id "1" for area "REGION" code "E12000005"
		Then the response status should be 200
		And the response should contain the field "name" with value "C2EO332E"
		And the response should contain the field "survey" with value "2017 TEST"
		And check "casesvc.caseevent" records in DB equal 10
		And after a delay of 150 seconds


	# Endpoint Tests -----

	# GET /cases/casegroup/{casegroupid}
	# 200
	@cases
	Scenario: Get request to cases for specific casegroupid
		When I make the GET call to the caseservice case endpoint for casegroupid "1"
		Then the response status should be 200
		And the response should contain a JSON array of size 1
		And one element of the JSON array must be {"caseId":1,"caseGroupId":1,"caseRef":"1000000000000001","state":"ACTIONABLE","caseTypeId":17,"actionPlanMappingId":17,"createdDateTime":
		And one element of the JSON array must be "createdBy":"SYSTEM","iac":
		And one element of the JSON array must be ,"responses":[],"contact":null}

	# 404
  @cases
	Scenario: Get request to cases for a non existing casegroupid
		When I make the GET call to the caseservice case endpoint for casegroupid "101"
		Then the response status should be 404
		And the response should contain the field "error.code" with value "RESOURCE_NOT_FOUND"
		And the response should contain the field "error.message" with value "CaseGroup not found for casegroup id 101"
		And the response should contain the field "error.timestamp"


	# GET /cases/iac/{iac}
	# 200
	@cases
	Scenario: Get request to cases for iac
		Given I make the GET call to the caseservice cases endpoint for case "10"
  	And the response status should be 200
  	And the response should contain the field "iac"
  	When I make the GET call to the caseservice case endpoint for iac
  	And the response status should be 200
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

	# 404
  @cases
	Scenario: Get request to cases for a non existing iac
		When I make the GET call to the caseservice case endpoint for invalid iac "ABCDEFGHIJK"
		Then the response status should be 404
		And the response should contain the field "error.code" with value "RESOURCE_NOT_FOUND"
		And the response should contain the field "error.message" with value "Case not found for iac id ABCDEFGHIJK"
		And the response should contain the field "error.timestamp"


	# GET /cases/{caseId}
	# 200
	@cases
	Scenario: Get request to cases for specific case id
		When I make the GET call to the caseservice cases endpoint for case "2"
		Then the response status should be 200
		And the response should contain the field "caseId" with an integer value of 2
		And the response should contain the field "caseGroupId" with an integer value of 2
		And the response should contain the field "caseRef" with value "1000000000000002"
		And the response should contain the field "state" with value "ACTIONABLE"
		And the response should contain the field "caseTypeId" with an integer value of 17
		And the response should contain the field "actionPlanMappingId" with an integer value of 17
		And the response should contain the field "createdDateTime"
		And the response should contain the field "createdBy" with value "SYSTEM"
		And the response should contain the field "iac"
		And the response should contain the field "responses" with one element of the JSON array must be []
		And the response should contain the field "contact" with a null value

	# 404
  @cases
	Scenario: Get request to the cases endpoint for a non existing case id
		When I make the GET call to the caseservice cases endpoint for case "101"
		Then the response status should be 404
		And the response should contain the field "error.code" with value "RESOURCE_NOT_FOUND"
		And the response should contain the field "error.message" with value "Case not found for case id 101"
		And the response should contain the field "error.timestamp"


	# GET /cases/{caseId}/events
	# 200
	@cases
	Scenario: Get request for events of a specific case id
#		Given after a delay of 30 seconds
		When I make the GET call to the caseservice cases endpoint for events for case "3"
		Then the response status should be 200
		And the response should contain a JSON array of size 2
		# Not complete record checked due to dynamic values which change for each test
		And one element of the JSON array must be {"createdDateTime":
		And one element of the JSON array must be "caseEventId":3,"caseId":3,"category":"CASE_CREATED","subCategory":null,"createdBy":"SYSTEM","description":"Initial creation of case"}

	# 204
	@cases
	Scenario: Get request for events of a specific case id where no case events exist
		Given Case events have been removed for case "5"
		When I make the GET call to the caseservice cases endpoint for events for case "5"
		Then the response status should be 204

	# 404
	@cases
	Scenario: Get request for cases events endpoint for a non existing case id
		When I make the GET call to the caseservice cases endpoint for events for case "101"
		Then the response status should be 404
		And the response should contain the field "error.code" with value "RESOURCE_NOT_FOUND"
		And the response should contain the field "error.message" with value "Case not found for case id 101"
		And the response should contain the field "error.timestamp"


	# POST /cases/{caseId}/events
	# 201
	@cases
	Scenario: Post request for cases events endpoint for case id
		When I make the POST call to the caseservice cases events
			| caseid							| 10 											 |
			| description 				| Created by cucumber test |
			| category 						| GENERAL_COMPLAINT				 |
			| subCategory 				| test										 |
			| createdBy 					| Cucumber Test						 |
			| caseCreationRequest |													 |
			| caseTypeId 					| 17											 |
			| actionPlanMappingId | 17											 |
			| title 							| Mr											 |
			| forename 						| Cucumber								 |
			| surname 						| Cucumber Test						 |
			| phoneNumber 				| 01234567890              |
			| emailAddress 				| test@ons.gov.uk					 |
		Then the response status should be 201
		And the response should contain the field "caseEventId" with an integer value of 22
		And the response should contain the field "caseId" with an integer value of 10
		And the response should contain the field "description" with value "Created by cucumber test"
		And the response should contain the field "category" with value "GENERAL_COMPLAINT"
		And the response should contain the field "subCategory" with value "test"
		And the response should contain the field "createdDateTime"
		And the response should contain the field "createdBy" with value "Cucumber Test"

	# 400
	@cases
	Scenario: Post request for cases events endpoint for invalid input
		When I make the POST call to the caseservice cases events with invalid input for case id "10"
		Then the response status should be 400
		
	# 404
	@cases
	Scenario: Post request for cases events endpoint for non existent case id
		When I make the POST call to the caseservice cases events
			| caseid							| 101 										 |
			| description 				| Created by cucumber test |
			| category 						| GENERAL_COMPLAINT				 |
			| subCategory 				| test										 |
			| createdBy 					| Cucumber Test						 |
			| caseCreationRequest |													 |
			| caseTypeId 					| 17											 |
			| actionPlanMappingId | 17											 |
			| title 							| Mr											 |
			| forename 						| Cucumber								 |
			| surname 						| Cucumber Test						 |
			| phoneNumber 				| 01234567890              |
			| emailAddress 				| test@ons.gov.uk					 |
		Then the response status should be 404
		And the response should contain the field "error.code" with value "RESOURCE_NOT_FOUND"
		And the response should contain the field "error.message" with value "Case not found for case id 101"
		And the response should contain the field "error.timestamp"
