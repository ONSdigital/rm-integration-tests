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
		And one element of the JSON array must be "surveyId":null,"name":"BRES","description":"BRES","createdBy":"SYSTEM","lastRunDateTime":
		And one element of the JSON array must be {"id":
    And one element of the JSON array must be "surveyId":null,"name":"Enrolment","description":"BRES Enrolment","createdBy":"SYSTEM","lastRunDateTime":

	# 204
	# Not tested as action plans already preloaded


	# GET /actionplans/{actionPlanId}
	# 200
	Scenario: Get request to actionplans for actionPlanId
		When I make the GET call to the actionservice actionplans endpoint for specified actionPlanId "0009e978-0932-463b-a2a1-b45cb3ffcb2a"
		Then the response status should be 200
		And the response should contain the field "id" with value "0009e978-0932-463b-a2a1-b45cb3ffcb2a"
		And the response should contain the field "surveyId"
		And the response should contain the field "name" with value "Enrolment"
		And the response should contain the field "description" with value "BRES Enrolment"
		And the response should contain the field "createdBy" with value "SYSTEM"
		And the response should contain the field "lastRunDateTime"

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
					| 51 | Hotel Action Plan - Cucumber Test One |  |
		Then the response status should be 200
		And the response should contain the field "actionPlanId" with an integer value of 51
		And the response should contain the field "surveyId" with an integer value of 1
		And the response should contain the field "name" with value "HOTEL"
		And the response should contain the field "description" with value "Hotel Action Plan - Cucumber Test One"
		And the response should contain the field "createdBy" with value "SYSTEM"
		#And the response should contain the field "createdDateTime"
		And the response should contain the field "lastRunDateTime"

	# 200
  Scenario: Put request to actionplans for actionPlanId
		When I make the PUT call to the actionservice actionplans endpoint for specified actionPlanId
					| 51 |  | lastRunDateTime |
		Then the response status should be 200
		And the response should contain the field "actionPlanId" with an integer value of 51
		And the response should contain the field "surveyId" with an integer value of 1
		And the response should contain the field "name" with value "HOTEL"
		And the response should contain the field "description" with value "Hotel Action Plan - Cucumber Test One"
		And the response should contain the field "createdBy" with value "SYSTEM"
		#And the response should contain the field "createdDateTime"
		And the response should contain the field "lastRunDateTime"

	# 200
  Scenario: Put request to actionplans for actionPlanId
		When I make the PUT call to the actionservice actionplans endpoint for specified actionPlanId
					| 51 | Hotel Action Plan - Cucumber Test Two | lastRunDateTime |
		Then the response status should be 200
		And the response should contain the field "actionPlanId" with an integer value of 51
		And the response should contain the field "surveyId" with an integer value of 1
		And the response should contain the field "name" with value "HOTEL"
		And the response should contain the field "description" with value "Hotel Action Plan - Cucumber Test Two"
		And the response should contain the field "createdBy" with value "SYSTEM"
		#And the response should contain the field "createdDateTime"
		And the response should contain the field "lastRunDateTime"

	# 200 - Reset description to avoid subsequent test failures
  Scenario: Put request to actionplans for actionPlanId
		When I make the PUT call to the actionservice actionplans endpoint for specified actionPlanId
					| 51 | Hotel - England/online/no field |  |
		Then the response status should be 200
		And the response should contain the field "actionPlanId" with an integer value of 51
		And the response should contain the field "surveyId" with an integer value of 1
		And the response should contain the field "name" with value "HOTEL"
		And the response should contain the field "description" with value "Hotel - England/online/no field"
		And the response should contain the field "createdBy" with value "SYSTEM"
		#And the response should contain the field "createdDateTime"
		And the response should contain the field "lastRunDateTime"

	# 404
  Scenario: Put request to actionplans for actionPlanId
		When I make the PUT call to the actionservice actionplans endpoint for specified actionPlanId
					| 101 | Cucumber Test |  |
		Then the response status should be 404
		And the response should contain the field "error.code" with value "RESOURCE_NOT_FOUND"
		And the response should contain the field "error.message" with value "ActionPlan not found for id 101"
		And the response should contain the field "error.timestamp"

	# 400
	Scenario: Put request to actionplans for actionPlanId with invalid input
		When I make the PUT call to the actionservice actionplans endpoint for specified actionPlanId "3" with invalid input
		Then the response status should be 400
		And the response should contain the field "error.code" with value "VALIDATION_FAILED"
		And the response should contain the field "error.message" with value "Provided json is incorrect."
		And the response should contain the field "error.timestamp"

	# GET /actionplans/{actionPlanId}/rules
	# 200
	Scenario: Get request to actionplans rules for actionPlanId
		When I make the GET call to the actionservice actionplans rules endpoint for actionPlanId "0009e978-0932-463b-a2a1-b45cb3ffcb2a"
		Then the response status should be 200
		And the response should contain a JSON array of size 2
		And one element of the JSON array must be {"actionPlanId":
    And one element of the JSON array must be ,"priority":3,"daysOffset":0,"actionTypeName":"BRESEL","name":"BRESEL+0","description":"Enrolment Letter(+0 days)"}
    And one element of the JSON array must be {"actionPlanId":
    And one element of the JSON array must be ,"priority":3,"daysOffset":82,"actionTypeName":"BRESERL","name":"BRESERL+82","description":"Enrolment Reminder Letter(+82 days)"}


	# 204
	# Not tested as rules already preloaded

	# 404
	Scenario: Get request to actionplans rules for actionPlanId with plan not found
		When I make the GET call to the actionservice actionplans rules endpoint for actionPlanId "101"
		Then the response status should be 404
		And the response should contain the field "error.code" with value "RESOURCE_NOT_FOUND"
		And the response should contain the field "error.message" with value "ActionPlan not found for id 101"
		And the response should contain the field "error.timestamp"
