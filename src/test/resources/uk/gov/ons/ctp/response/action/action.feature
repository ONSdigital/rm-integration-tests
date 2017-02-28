# Author: Stephen Goddard 29/04/2016
# Keywords Summary : This feature file contains the scenario tests for the action service - action endpoints - details are in the swagger spec
#										 https://github.com/ONSdigital/response-management-service/blob/master/actionsvc-api/swagger.yml
#										 Note: Assuption DB has been preloaded with action plan data, samples have been created and actions run
# Feature: List of action scenarios: Post to run jobs for action plan 1
#																							Post to run jobs for action plan 2
#																							Post to run jobs for action plan 3
#																							Post to run jobs for action plan 3 with invalid json
#																							Post to run jobs for action plan 101 not found
#																							Get action plan jobs by action plan job id
#																							Get action plan jobs by action plan job id not found
#																							Get action plan jobs by action plan id
#																							Get action plan jobs by action plan id not found
# Feature Tags: @postIACHandlersTest
#							  @actionsvc
#							  @action

@actionsvc @action
Feature: Validating action requests

	# Clean Environment -----

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

	Scenario: Put request for sample to create online cases for the specified sample id
		When I make the PUT call to the caseservice sample endpoint for sample id "1" for area "REGION" code "E12000005"
		Then the response status should be 200
		And the response should contain the field "name" with value "C2EO332E"
		And the response should contain the field "survey" with value "2017 TEST"
		And check "casesvc.caseevent" records in DB equal 10


	Scenario: Get request to case for highest expected case id
		Given after a delay of 150 seconds
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


	# Action Endpoints -----

	# GET /actions
	# 200
	Scenario: Get request to actions filtered by actionType
		When I make the GET call to the actionservice actions endpoint
					| ICL1_2003 |  |
		Then the response status should be 200
		And the response should contain a JSON array of size 10
		# Not complete record checked due to dynamic values which change for each test
		And one element of the JSON array must be {"actionId":1,
		And one element of the JSON array must be {"actionId":2,
		And one element of the JSON array must be {"actionId":3,
		And one element of the JSON array must be {"actionId":4,
		And one element of the JSON array must be {"actionId":5,
		And one element of the JSON array must be {"actionId":6,
		And one element of the JSON array must be {"actionId":7,
		And one element of the JSON array must be {"actionId":8,
		And one element of the JSON array must be {"actionId":9,
		And one element of the JSON array must be {"actionId":10,
		And one element of the JSON array must be "caseId":5,"actionPlanId":11,"actionRuleId":45,"actionTypeName":"ICL1_2003","createdBy":"SYSTEM","manuallyCreated":false,"priority":3,"situation":null,"state":"COMPLETED","createdDateTime":
		And one element of the JSON array must be "caseId":1,"actionPlanId":11,"actionRuleId":45,"actionTypeName":"ICL1_2003","createdBy":"SYSTEM","manuallyCreated":false,"priority":3,"situation":null,"state":"COMPLETED","createdDateTime":
		And one element of the JSON array must be "caseId":4,"actionPlanId":11,"actionRuleId":45,"actionTypeName":"ICL1_2003","createdBy":"SYSTEM","manuallyCreated":false,"priority":3,"situation":null,"state":"COMPLETED","createdDateTime":
		And one element of the JSON array must be "caseId":8,"actionPlanId":11,"actionRuleId":45,"actionTypeName":"ICL1_2003","createdBy":"SYSTEM","manuallyCreated":false,"priority":3,"situation":null,"state":"COMPLETED","createdDateTime":
		And one element of the JSON array must be "caseId":2,"actionPlanId":11,"actionRuleId":45,"actionTypeName":"ICL1_2003","createdBy":"SYSTEM","manuallyCreated":false,"priority":3,"situation":null,"state":"COMPLETED","createdDateTime":
		And one element of the JSON array must be "caseId":6,"actionPlanId":11,"actionRuleId":45,"actionTypeName":"ICL1_2003","createdBy":"SYSTEM","manuallyCreated":false,"priority":3,"situation":null,"state":"COMPLETED","createdDateTime":
		And one element of the JSON array must be "caseId":7,"actionPlanId":11,"actionRuleId":45,"actionTypeName":"ICL1_2003","createdBy":"SYSTEM","manuallyCreated":false,"priority":3,"situation":null,"state":"COMPLETED","createdDateTime":
		And one element of the JSON array must be "caseId":9,"actionPlanId":11,"actionRuleId":45,"actionTypeName":"ICL1_2003","createdBy":"SYSTEM","manuallyCreated":false,"priority":3,"situation":null,"state":"COMPLETED","createdDateTime":
		And one element of the JSON array must be "caseId":10,"actionPlanId":11,"actionRuleId":45,"actionTypeName":"ICL1_2003","createdBy":"SYSTEM","manuallyCreated":false,"priority":3,"situation":null,"state":"COMPLETED","createdDateTime":
		And one element of the JSON array must be "caseId":3,"actionPlanId":11,"actionRuleId":45,"actionTypeName":"ICL1_2003","createdBy":"SYSTEM","manuallyCreated":false,"priority":3,"situation":null,"state":"COMPLETED","createdDateTime":
		And one element of the JSON array must be "updatedDateTime":

	# 200
	Scenario: Get request to actions filtered by state
		When I make the GET call to the actionservice actions endpoint
					|  | COMPLETED |
		Then the response status should be 200
		And the response should contain a JSON array of size 10
		# Not complete record checked due to dynamic values which change for each test
		And one element of the JSON array must be {"actionId":1,
		And one element of the JSON array must be {"actionId":2,
		And one element of the JSON array must be {"actionId":3,
		And one element of the JSON array must be {"actionId":4,
		And one element of the JSON array must be {"actionId":5,
		And one element of the JSON array must be {"actionId":6,
		And one element of the JSON array must be {"actionId":7,
		And one element of the JSON array must be {"actionId":8,
		And one element of the JSON array must be {"actionId":9,
		And one element of the JSON array must be {"actionId":10,
		And one element of the JSON array must be "caseId":5,"actionPlanId":11,"actionRuleId":45,"actionTypeName":"ICL1_2003","createdBy":"SYSTEM","manuallyCreated":false,"priority":3,"situation":null,"state":"COMPLETED","createdDateTime":
		And one element of the JSON array must be "caseId":1,"actionPlanId":11,"actionRuleId":45,"actionTypeName":"ICL1_2003","createdBy":"SYSTEM","manuallyCreated":false,"priority":3,"situation":null,"state":"COMPLETED","createdDateTime":
		And one element of the JSON array must be "caseId":4,"actionPlanId":11,"actionRuleId":45,"actionTypeName":"ICL1_2003","createdBy":"SYSTEM","manuallyCreated":false,"priority":3,"situation":null,"state":"COMPLETED","createdDateTime":
		And one element of the JSON array must be "caseId":8,"actionPlanId":11,"actionRuleId":45,"actionTypeName":"ICL1_2003","createdBy":"SYSTEM","manuallyCreated":false,"priority":3,"situation":null,"state":"COMPLETED","createdDateTime":
		And one element of the JSON array must be "caseId":2,"actionPlanId":11,"actionRuleId":45,"actionTypeName":"ICL1_2003","createdBy":"SYSTEM","manuallyCreated":false,"priority":3,"situation":null,"state":"COMPLETED","createdDateTime":
		And one element of the JSON array must be "caseId":6,"actionPlanId":11,"actionRuleId":45,"actionTypeName":"ICL1_2003","createdBy":"SYSTEM","manuallyCreated":false,"priority":3,"situation":null,"state":"COMPLETED","createdDateTime":
		And one element of the JSON array must be "caseId":7,"actionPlanId":11,"actionRuleId":45,"actionTypeName":"ICL1_2003","createdBy":"SYSTEM","manuallyCreated":false,"priority":3,"situation":null,"state":"COMPLETED","createdDateTime":
		And one element of the JSON array must be "caseId":9,"actionPlanId":11,"actionRuleId":45,"actionTypeName":"ICL1_2003","createdBy":"SYSTEM","manuallyCreated":false,"priority":3,"situation":null,"state":"COMPLETED","createdDateTime":
		And one element of the JSON array must be "caseId":10,"actionPlanId":11,"actionRuleId":45,"actionTypeName":"ICL1_2003","createdBy":"SYSTEM","manuallyCreated":false,"priority":3,"situation":null,"state":"COMPLETED","createdDateTime":
		And one element of the JSON array must be "caseId":3,"actionPlanId":11,"actionRuleId":45,"actionTypeName":"ICL1_2003","createdBy":"SYSTEM","manuallyCreated":false,"priority":3,"situation":null,"state":"COMPLETED","createdDateTime":
		And one element of the JSON array must be "updatedDateTime":

	# 200
	Scenario: Get request to actions filtered by actionType and state
		When I make the GET call to the actionservice actions endpoint
					| ICL1_2003 | COMPLETED |
		Then the response status should be 200
		And the response should contain a JSON array of size 10
		# Not complete record checked due to dynamic values which change for each test
		And one element of the JSON array must be {"actionId":1,
		And one element of the JSON array must be {"actionId":2,
		And one element of the JSON array must be {"actionId":3,
		And one element of the JSON array must be {"actionId":4,
		And one element of the JSON array must be {"actionId":5,
		And one element of the JSON array must be {"actionId":6,
		And one element of the JSON array must be {"actionId":7,
		And one element of the JSON array must be {"actionId":8,
		And one element of the JSON array must be {"actionId":9,
		And one element of the JSON array must be {"actionId":10,
		And one element of the JSON array must be "caseId":5,"actionPlanId":11,"actionRuleId":45,"actionTypeName":"ICL1_2003","createdBy":"SYSTEM","manuallyCreated":false,"priority":3,"situation":null,"state":"COMPLETED","createdDateTime":
		And one element of the JSON array must be "caseId":1,"actionPlanId":11,"actionRuleId":45,"actionTypeName":"ICL1_2003","createdBy":"SYSTEM","manuallyCreated":false,"priority":3,"situation":null,"state":"COMPLETED","createdDateTime":
		And one element of the JSON array must be "caseId":4,"actionPlanId":11,"actionRuleId":45,"actionTypeName":"ICL1_2003","createdBy":"SYSTEM","manuallyCreated":false,"priority":3,"situation":null,"state":"COMPLETED","createdDateTime":
		And one element of the JSON array must be "caseId":8,"actionPlanId":11,"actionRuleId":45,"actionTypeName":"ICL1_2003","createdBy":"SYSTEM","manuallyCreated":false,"priority":3,"situation":null,"state":"COMPLETED","createdDateTime":
		And one element of the JSON array must be "caseId":2,"actionPlanId":11,"actionRuleId":45,"actionTypeName":"ICL1_2003","createdBy":"SYSTEM","manuallyCreated":false,"priority":3,"situation":null,"state":"COMPLETED","createdDateTime":
		And one element of the JSON array must be "caseId":6,"actionPlanId":11,"actionRuleId":45,"actionTypeName":"ICL1_2003","createdBy":"SYSTEM","manuallyCreated":false,"priority":3,"situation":null,"state":"COMPLETED","createdDateTime":
		And one element of the JSON array must be "caseId":7,"actionPlanId":11,"actionRuleId":45,"actionTypeName":"ICL1_2003","createdBy":"SYSTEM","manuallyCreated":false,"priority":3,"situation":null,"state":"COMPLETED","createdDateTime":
		And one element of the JSON array must be "caseId":9,"actionPlanId":11,"actionRuleId":45,"actionTypeName":"ICL1_2003","createdBy":"SYSTEM","manuallyCreated":false,"priority":3,"situation":null,"state":"COMPLETED","createdDateTime":
		And one element of the JSON array must be "caseId":10,"actionPlanId":11,"actionRuleId":45,"actionTypeName":"ICL1_2003","createdBy":"SYSTEM","manuallyCreated":false,"priority":3,"situation":null,"state":"COMPLETED","createdDateTime":
		And one element of the JSON array must be "caseId":3,"actionPlanId":11,"actionRuleId":45,"actionTypeName":"ICL1_2003","createdBy":"SYSTEM","manuallyCreated":false,"priority":3,"situation":null,"state":"COMPLETED","createdDateTime":
		And one element of the JSON array must be "updatedDateTime":

	# 204
	Scenario: Get request to actions filtered by actionType
		When I make the GET call to the actionservice actions endpoint
					| 1RL1_0504 |  |
		Then the response status should be 204


	# POST /actions
	# 201
	Scenario: Post request to actions to create action from caseId, actionTypeName and createdBy properties
		When I make the POST call to the actionservice actions endpoint
					| 1 | QGPOL | 3 | cucumberTest |
		Then the response status should be 201
		And the response should contain the field "actionId" with an integer value of 11
		And the response should contain the field "caseId" with an integer value of 1
		And the response should contain the field "actionPlanId" with a null value
		And the response should contain the field "actionRuleId" with a null value
		And the response should contain the field "actionTypeName" with value "QGPOL"
		And the response should contain the field "createdBy" with value "cucumberTest"
		And the response should contain the field "manuallyCreated" with boolean value "true"
		And the response should contain the field "priority" with an integer value of 3
		And the response should contain the field "situation" with a null value
		And the response should contain the field "state" with value "SUBMITTED"
		And the response should contain the field "createdDateTime"
		And the response should contain the field "updatedDateTime" with a null value

	# 400
	Scenario: Post request to actions with invalid input
		When I make the POST call to the actionservice actions endpoint with invalid input
		Then the response status should be 400
		And the response should contain the field "error.code" with value "VALIDATION_FAILED"
		And the response should contain the field "error.message" with value "Provided json is incorrect."
		And the response should contain the field "error.timestamp"
	

	# PUT /actions/{actionId}/feedback
	# 200
	Scenario: Post request to actions with invalid input
		Given I make the POST call to the actionservice actions endpoint
					| 1 | QGPOL | 3 | cucumberTest |
		And the response status should be 201
		When I make the PUT call to the actionservice actions feedback endpoint for actionId "12"
		Then the response status should be 200
		And the response should contain the field "actionId" with an integer value of 12
		And the response should contain the field "caseId" with an integer value of 1
		And the response should contain the field "actionPlanId" with a null value
		And the response should contain the field "actionRuleId" with a null value
		And the response should contain the field "actionTypeName" with value "QGPOL"
		And the response should contain the field "createdBy" with value "cucumberTest"
		And the response should contain the field "manuallyCreated" with boolean value "true"
		And the response should contain the field "priority" with an integer value of 3
		And the response should contain the field "situation" with value "CI Test Run"
		And the response should contain the field "state" with value "COMPLETED"
		And the response should contain the field "createdDateTime"
		And the response should contain the field "updatedDateTime"


	# 400
	Scenario: Post request to actions with invalid input
		When I make the PUT call to the actionservice actions feedback endpoint with invalid input "1"
		Then the response status should be 400


	# GET /actions/{actionId}
	# 200
	Scenario: Get request to actions for specific action id
		When I make the GET call to the actionservice actions endpoint for actionId "10"
		Then the response status should be 200
		And the response should contain the field "actionId" with an integer value of 10
		And the response should contain the field "caseId"
		And the response should contain the field "actionPlanId" with an integer value of 11
		And the response should contain the field "actionRuleId" with an integer value of 45
		And the response should contain the field "actionTypeName" with value "ICL1_2003"
		And the response should contain the field "createdBy" with value "SYSTEM"
		And the response should contain the field "manuallyCreated" with boolean value "false"
		And the response should contain the field "priority" with an integer value of 3
		And the response should contain the field "situation" with a null value
		And the response should contain the field "state" with value "COMPLETED"
		And the response should contain the field "createdDateTime"
		And the response should contain the field "updatedDateTime"

	# 404
	Scenario: Get request to actions for action id not found
		When I make the GET call to the actionservice actions endpoint for actionId "101"
		Then the response status should be 404
		And the response should contain the field "error.code" with value "RESOURCE_NOT_FOUND"
		And the response should contain the field "error.message" with value "Action not found for id 101"
		And the response should contain the field "error.timestamp"

	
	# PUT /actions/{actionId}
	# 200
	Scenario: Put request to actions for specific action id
		When I make the PUT call to the actionservice actions endpoint for actionId
    					| 7 | 3 | Test Situation |
		Then the response status should be 200
		And the response should contain the field "actionId" with an integer value of 7
		And the response should contain the field "caseId"
		And the response should contain the field "actionPlanId" with an integer value of 11
		And the response should contain the field "actionRuleId" with an integer value of 45
		And the response should contain the field "actionTypeName" with value "ICL1_2003"
		And the response should contain the field "createdBy" with value "SYSTEM"
		And the response should contain the field "manuallyCreated" with boolean value "false"
		And the response should contain the field "priority" with an integer value of 3
		And the response should contain the field "situation" with value "Test Situation"
		And the response should contain the field "state" with value "COMPLETED"
		And the response should contain the field "createdDateTime"
		And the response should contain the field "updatedDateTime"

	# 404
	Scenario: Put request to actions for specific action id
		When I make the PUT call to the actionservice actions endpoint for actionId
    					| 101 | 3 | Test Situation |
		Then the response status should be 404
		And the response should contain the field "error.code" with value "RESOURCE_NOT_FOUND"
		And the response should contain the field "error.message" with value "Action not updated for id 101"
		And the response should contain the field "error.timestamp"

	# 400
	Scenario: Put request to actions with invalid input
		When I make the PUT call to the actionservice actions endpoint for actionId "1" with invalid input 
		Then the response status should be 400
		And the response should contain the field "error.code" with value "VALIDATION_FAILED"
		And the response should contain the field "error.message" with value "Provided json is incorrect."
		And the response should contain the field "error.timestamp"
	
	
	# GET /actions/case/{caseId}
	# 200
	Scenario: Get request to actions for specific case id
		When I make the GET call to the actionservice actions endpoint for caseId "10"
		Then the response status should be 200
		And the response should contain a JSON array of size 1
		And one element of the JSON array must be {"actionId":
		And one element of the JSON array must be "caseId":10,"actionPlanId":11,"actionRuleId":45,"actionTypeName":"ICL1_2003","createdBy":"SYSTEM","manuallyCreated":false,"priority":3,"situation":
		And one element of the JSON array must be ,"state":"COMPLETED","createdDateTime":
		And one element of the JSON array must be "updatedDateTime":

	# 204
	Scenario: Get request to actions for specific case id with no actions
		When I make the GET call to the actionservice actions endpoint for caseId "101"
		Then the response status should be 204
	
	
	# PUT /actions/case/{caseId}/cancel
	# 200
	Scenario: Put request to cancel actions for specific case id - Create sample and a field visit event to cancel
		Given I make the PUT call to the caseservice sample endpoint for sample id "7" for area "REGION" code "E12000005"
		And the response status should be 200
		And the response should contain the field "name" with value "C1SO331D4E"
		And the response should contain the field "survey" with value "2017 TEST"
		And after a delay of 60 seconds
		When the case start date is adjusted to trigger action plan
			| actionPlanId  | actiontypeid | total |
			| 1   					| 14   				 | 10		 |
		And after a delay of 100 seconds
		Then I make the PUT call to the actionservice cancel actions endpoint for caseId "11"
		And the response status should be 200
		And one element of the JSON array must be {"actionId":
		And one element of the JSON array must be "caseId":11,"actionPlanId":1,"actionRuleId":3,"actionTypeName":"HouseholdCreateVisit","createdBy":"SYSTEM","manuallyCreated":false,"priority":3,"situation":
		And one element of the JSON array must be ,"state":"CANCEL_SUBMITTED","createdDateTime":
		And one element of the JSON array must be "updatedDateTime":

	# 404
	Scenario: Put request to cancel actions for specific case id with no actions
		When I make the PUT call to the actionservice cancel actions endpoint for caseId "101"
		Then the response status should be 404
		And the response should contain the field "error.code" with value "RESOURCE_NOT_FOUND"
		And the response should contain the field "error.message" with value "Case not found for caseId 101"
		And the response should contain the field "error.timestamp"	
