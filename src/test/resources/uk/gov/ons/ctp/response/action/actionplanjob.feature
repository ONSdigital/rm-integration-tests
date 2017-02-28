# Author: Stephen Goddard 03/05/2016
#
# Keywords Summary : This feature file contains the scenario tests for the action service - actionPlanJob endpoints - details are in the swagger spec
#										 https://github.com/ONSdigital/response-management-service/blob/master/actionsvc-api/swagger.yml
#										 Note: Assuption DB has been preloaded with action plan data and samples have been created
#
# Feature: List of action plan job scenarios: Post to run jobs for action plan 1
#																							Post to run jobs for action plan 2
#																							Post to run jobs for action plan 3
#																							Post to run jobs for action plan 3 with invalid json
#																							Post to run jobs for action plan 101 not found
#																							Get action plan jobs by action plan job id
#																							Get action plan jobs by action plan job id not found
#																							Get action plan jobs by action plan id
#																							Get action plan jobs by action plan id not found
#
# Feature Tags: @runIACHandlersTest
#							  @actionsvc
#							  @actionPlanJob

@actionsvc @actionPlanJob
Feature: Validating actionPlanJob requests

	# Clean Environment -----

  @indCleanEnvironment
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

	# CTPA-624
	@createIndPaperSample
	Scenario: Put request for sample to create online cases for the specified sample id
		When I make the PUT call to the caseservice sample endpoint for sample id "15" for area "REGION" code "E12000005"
		Then the response status should be 200
		And the response should contain the field "name" with value "C2SP331E"
		And the response should contain the field "survey" with value "2017 TEST"
		And check "casesvc.caseevent" records in DB equal 10
		And after a delay of 100 seconds


	# Endpoint Tests -----

	# GET /actionplans/jobs/{actionPlanJobId}
	# 200
	Scenario: Get request to actionplans for jobs
		When I make the GET call to the actionservice actionplans endpoint for specific plan job "1"
		Then the response status should be 200
		And the response should contain the field "actionPlanJobId" with an integer value of 1
		And the response should contain the field "actionPlanId" with an integer value of 5
		And the response should contain the field "createdBy" with value "SYSTEM"
		And the response should contain the field "state" with value "COMPLETED"
		And the response should contain the field "createdDateTime"
		And the response should contain the field "updatedDateTime"

	# 404
	Scenario: Get request to actionplans for jobs not found
		When I make the GET call to the actionservice actionplans endpoint for specific plan job "101"
		Then the response status should be 404
		And the response should contain the field "error.code" with value "RESOURCE_NOT_FOUND"
		And the response should contain the field "error.message" with value "ActionPlanJob not found for id 101"
		And the response should contain the field "error.timestamp"


	# GET /actionplans/{actionPlanId}/jobs  
	# 200
	Scenario: Get request to actionplans for list of all jobs for specified action plan
		When I make the GET call to the actionservice actionplans endpoint for jobs with specific plan "5"
		Then the response status should be 200
		And one element of the JSON array must be {"actionPlanJobId":1,"actionPlanId":5,"createdBy":"SYSTEM","state":"COMPLETED","createdDateTime":
		And one element of the JSON array must be "updatedDateTime":
		
	# 204
	Scenario: Get request to actionplans for list of all jobs for specified action plan with no plan jobs
		When I make the GET call to the actionservice actionplans endpoint for jobs with specific plan "20"
		Then the response status should be 204
		
	# 404
	Scenario: Get request to actionplans for list of all jobs for specified action plan not found
		When I make the GET call to the actionservice actionplans endpoint for jobs with specific plan "101"
		Then the response status should be 204


	# POST /actionplans/{actionPlanId}/jobs
	# 201
	Scenario: Post request to actionplans to create jobs for specified action plan
		When I make the POST call to the actionservice actionplans endpoint for jobs with specific plan
					| 5 | CucumberTest |
		Then the response status should be 201
		And the response should contain the field "actionPlanJobId"
		And the response should contain the field "actionPlanId" with an integer value of 5
		And the response should contain the field "createdBy" with value "CucumberTest"
		And the response should contain the field "state" with value "SUBMITTED"
		And the response should contain the field "createdDateTime"
		And the response should contain the field "updatedDateTime"

	# 400
	Scenario: Post request to actionplans to create jobs for specified action plan with invalid input
		When I make the POST call to the actionservice actionplans endpoint for jobs with specific plan "101" with invalid input
		Then the response status should be 400
		And the response should contain the field "error.code" with value "VALIDATION_FAILED"
		And the response should contain the field "error.message" with value "Provided json is incorrect."
		And the response should contain the field "error.timestamp"
		
	# 404
	Scenario: Post request to actionplans to create jobs for specified action plan not found
		When I make the POST call to the actionservice actionplans endpoint for jobs with specific plan
					| 101 | cucumberTest |
		Then the response status should be 404
		And the response should contain the field "error.code" with value "RESOURCE_NOT_FOUND"
		And the response should contain the field "error.message" with value "ActionPlan not found for id 101"
		And the response should contain the field "error.timestamp"
	