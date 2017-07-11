# Author: Stephen Goddard 29/04/2016
#
# Keywords Summary : This feature file contains the scenario tests for the action service - actionPlan endpoints - details are in the swagger spec
# 									 https://github.com/ONSdigital/response-management-service/blob/master/actionsvc-api/swagger.yml
#										 Note: Assuption DB has been preloaded with action plan data
#
# Feature: List of action plan scenarios: Get action plans
#																					Post action plans - not implemented
#																					Get action plans by valid action plan id
#																					Get action plans by invalid action plan id
#																					Put action plans by valid action plan id with updated description
#																					Put action plans by valid action plan id with updated lastRunDateTime
#																					Put action plans by valid action plan id with updated description and lastRunDateTime
#																					Put action plans by valid action plan id to rest to originial values to prevent subsequent testing failing
#																					Put action plans by invalid action plan id
#																					Put action plans by valid action plan id but invalid json
#																					Get action plan rules by valid action plan id
#																					Get action plan rules by invalid action plan id
#
# Feature Tags: @actionsvc
#							  @actionplan
#
@actionsvc @actionPlan
Feature: Validating actionPlan requests

	# Endpoint Tests -----

	# GET /actionplans
	# 200
	Scenario: Get request to actionplans
		When I make the GET call to the actionservice actionplans endpoint
		Then the response status should be 200
		And the response should contain a JSON array of size 2
		And one element of the JSON array must be {"id":
		And one element of the JSON array must be "name":"BRES"	
		And one element of the JSON array must be "description":"BRES Enrolment"
		And one element of the JSON array must be "createdBy":"SYSTEM"
		And one element of the JSON array must be "lastGoodRunDateTime":
		And one element of the JSON array must be {"id":
        And one element of the JSON array must be "name":"Enrolment"
        And one element of the JSON array must be "description":
        And one element of the JSON array must be "createdBy":"SYSTEM"
        And one element of the JSON array must be "lastGoodRunDateTime":

	# 204
	# Not tested as action plans already preloaded


	# GET /actionplans/{actionPlanId}
	# 200
	Scenario: Get request to actionplans for actionPlanId

		When I make the GET call to the actionservice actionplans endpoint for specified actionPlanId "0009e978-0932-463b-a2a1-b45cb3ffcb2a"
		Then the response status should be 200
		And the response should contain the field "id" with value "0009e978-0932-463b-a2a1-b45cb3ffcb2a"
		And the response should contain the field "name" with value "BRES"
		And the response should contain the field "description" with value "Hotel - England/online/no field"
		And the response should contain the field "createdBy" with value "SYSTEM"
		
	# 404
	Scenario: Get request to actionplans for actionPlanId not found
		When I make the GET call to the actionservice actionplans endpoint for specified actionPlanId "1019e978-0932-463b-a2a1-b45cb3ffcb2a"
		Then the response status should be 404
		And the response should contain the field "error.code" with value "RESOURCE_NOT_FOUND"
		And the response should contain the field "error.message" with value "ActionPlan not found for id 1019e978-0932-463b-a2a1-b45cb3ffcb2a"
		And the response should contain the field "error.timestamp"


	# PUT /actionplans/{actionPlanId}
	# 200
	
    Scenario: Put request to actionplans for actionPlanId
		When I make the PUT call to the actionservice actionplans endpoint for specified actionPlanId
					| 0009e978-0932-463b-a2a1-b45cb3ffcb2a | Hotel Action Plan - Cucumber Test One |  |
		Then the response status should be 200
		And the response should contain the field "id" with value "0009e978-0932-463b-a2a1-b45cb3ffcb2a"
		And the response should contain the field "name" with value "BRES"
		And the response should contain the field "description" with value "Hotel Action Plan - Cucumber Test One"
		And the response should contain the field "createdBy" with value "SYSTEM"
		And the response should contain the field "lastGoodRunDateTime" with a null value



	# 200

    Scenario: Put request to actionplans for actionPlanId
		When I make the PUT call to the actionservice actionplans endpoint for specified actionPlanId
					| 0009e978-0932-463b-a2a1-b45cb3ffcb2a  |  |  |
		Then the response status should be 200
		And the response should contain the field "id" with value "0009e978-0932-463b-a2a1-b45cb3ffcb2a" 
		And the response should contain the field "name" with value "BRES"
		And the response should contain the field "description" with value "Hotel Action Plan - Cucumber Test One"
		And the response should contain the field "createdBy" with value "SYSTEM"
		And the response should contain the field "lastGoodRunDateTime" with a null value
		
	# 200
  Scenario: Put request to actionplans for actionPlanId
		When I make the PUT call to the actionservice actionplans endpoint for specified actionPlanId
					| 0009e978-0932-463b-a2a1-b45cb3ffcb2a | Hotel Action Plan - Cucumber Test Two | |
		Then the response status should be 200
		And the response should contain the field "id" with value "0009e978-0932-463b-a2a1-b45cb3ffcb2a"
		And the response should contain the field "name" with value "BRES"
		And the response should contain the field "description" with value "Hotel Action Plan - Cucumber Test Two"
		And the response should contain the field "createdBy" with value "SYSTEM"
		And the response should contain the field "lastGoodRunDateTime" with a null value

	# 200 - Reset description to avoid subsequent test failures
  Scenario: Put request to actionplans for actionPlanId
		When I make the PUT call to the actionservice actionplans endpoint for specified actionPlanId
					| 0009e978-0932-463b-a2a1-b45cb3ffcb2a | Hotel - England/online/no field |  |
		Then the response status should be 200
		And the response should contain the field "id" with value "0009e978-0932-463b-a2a1-b45cb3ffcb2a"
		And the response should contain the field "name" with value "BRES"
		And the response should contain the field "description" with value "Hotel - England/online/no field"
		And the response should contain the field "createdBy" with value "SYSTEM"
		And the response should contain the field "lastGoodRunDateTime" with a null value

	# 404
	
  Scenario: Put request to actionplans for actionPlanId
		When I make the PUT call to the actionservice actionplans endpoint for specified actionPlanId
					| 00000000-0932-463b-a2a1-b45cb3ffcb2a | Cucumber Test |  |
		Then the response status should be 404
		And the response should contain the field "error.code" with value "RESOURCE_NOT_FOUND"
		And the response should contain the field "error.timestamp"

	# 400

	Scenario: Put request to actionplans for actionPlanId with invalid input
		When I make the PUT call to the actionservice actionplans endpoint for specified actionPlanId "00000000-0932-463b-a2a1-b45cb3ffcb2a" with invalid input
		Then the response status should be 400
		And the response should contain the field "error.code" with value "VALIDATION_FAILED"
		And the response should contain the field "error.message" with value "Provided json is incorrect."
		And the response should contain the field "error.timestamp"

