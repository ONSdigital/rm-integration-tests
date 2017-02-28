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

@actionsvc @actionPlan
Feature: Validating actionPlan requests

	# Endpoint Tests -----

	# GET /actionplans
	# 200
	Scenario: Get request to actionplans
		When I make the GET call to the actionservice actionplans endpoint
		Then the response status should be 200
		And the response should contain a JSON array of size 54
		And one element of the JSON array must be {"actionPlanId":17,"surveyId":1,"name":"I1S-P","description":"Individual - England\/paper\/sexual ID","createdBy":"SYSTEM","lastRunDateTime":
		And one element of the JSON array must be {"actionPlanId":18,"surveyId":1,"name":"I1-P","description":"Individual - England\/paper\/without sexual ID","createdBy":"SYSTEM","lastRunDateTime":
		And one element of the JSON array must be {"actionPlanId":20,"surveyId":1,"name":"H1SD4-P","description":"Replacement - England\/paper\/sexual ID\/field day four","createdBy":"SYSTEM","lastRunDateTime":
		And one element of the JSON array must be {"actionPlanId":21,"surveyId":1,"name":"H1SD10-P","description":"Replacement - England\/paper\/sexual ID\/field day ten","createdBy":"SYSTEM","lastRunDateTime":
		And one element of the JSON array must be {"actionPlanId":22,"surveyId":1,"name":"H1S-P","description":"Replacement - England\/paper\/sexual ID\/no field","createdBy":"SYSTEM","lastRunDateTime":
		And one element of the JSON array must be {"actionPlanId":23,"surveyId":1,"name":"H1D4-P","description":"Replacement - England\/paper\/without sexual ID\/field day four","createdBy":"SYSTEM","lastRunDateTime":
		And one element of the JSON array must be {"actionPlanId":24,"surveyId":1,"name":"H1D10-P","description":"Replacement - England\/paper\/without sexual ID\/field day ten","createdBy":"SYSTEM","lastRunDateTime":
		And one element of the JSON array must be {"actionPlanId":25,"surveyId":1,"name":"H1-P","description":"Replacement - England\/paper\/without sexual ID\/no field","createdBy":"SYSTEM","lastRunDateTime":
		And one element of the JSON array must be {"actionPlanId":26,"surveyId":1,"name":"R-SMS4","description":"Replacement - England\/SMS\/field day four","createdBy":"SYSTEM","lastRunDateTime":
		And one element of the JSON array must be {"actionPlanId":27,"surveyId":1,"name":"R-SMS10","description":"Replacement - England\/SMS\/field day ten","createdBy":"SYSTEM","lastRunDateTime":
		And one element of the JSON array must be {"actionPlanId":28,"surveyId":1,"name":"R-SMS","description":"Replacement - England\/SMS\/No field","createdBy":"SYSTEM","lastRunDateTime":
		And one element of the JSON array must be {"actionPlanId":29,"surveyId":1,"name":"I2S-P","description":"Individual - Wales\/in English\/paper\/sexual ID","createdBy":"SYSTEM","lastRunDateTime":
		And one element of the JSON array must be {"actionPlanId":30,"surveyId":1,"name":"I2WS-P","description":"Individual - Wales\/in Welsh\/paper\/sexual ID","createdBy":"SYSTEM","lastRunDateTime":
		And one element of the JSON array must be {"actionPlanId":31,"surveyId":1,"name":"I2-P","description":"Individual - Wales\/in English\/paper\/without sexual ID","createdBy":"SYSTEM","lastRunDateTime":
		And one element of the JSON array must be {"actionPlanId":32,"surveyId":1,"name":"I2W-P","description":"Individual - Wales\/in Welsh\/paper\/without sexual ID","createdBy":"SYSTEM","lastRunDateTime":
		And one element of the JSON array must be {"actionPlanId":34,"surveyId":1,"name":"I-SMSB","description":"Individual - Bilingual\/SMS","createdBy":"SYSTEM","lastRunDateTime":
		And one element of the JSON array must be {"actionPlanId":35,"surveyId":1,"name":"H2SD4-PWW","description":"Replacement - Wales\/Welsh\/paper\/sexual ID\/field day four","createdBy":"SYSTEM","lastRunDateTime":
		And one element of the JSON array must be {"actionPlanId":36,"surveyId":1,"name":"H2SD10-PWW","description":"Replacement - Wales\/Welsh\/paper\/sexual ID\/field day ten","createdBy":"SYSTEM","lastRunDateTime":
		And one element of the JSON array must be {"actionPlanId":37,"surveyId":1,"name":"H2S-PWW","description":"Replacement - Wales\/Welsh\/paper\/sexual ID\/no field","createdBy":"SYSTEM","lastRunDateTime":
		And one element of the JSON array must be {"actionPlanId":38,"surveyId":1,"name":"H2D4-PWW","description":"Replacement - Wales\/Welsh\/paper\/without sexual ID\/field day four","createdBy":"SYSTEM","lastRunDateTime":
		And one element of the JSON array must be {"actionPlanId":39,"surveyId":1,"name":"H2D10-PWW","description":"Replacement - Wales\/Welsh\/paper\/without sexual ID\/field day ten","createdBy":"SYSTEM","lastRunDateTime":
		And one element of the JSON array must be {"actionPlanId":40,"surveyId":1,"name":"H2-PWW","description":"Replacement - Wales\/Welsh\/paper\/without sexual ID\/no field","createdBy":"SYSTEM","lastRunDateTime":
		And one element of the JSON array must be {"actionPlanId":41,"surveyId":1,"name":"H2SD4-PWE","description":"Replacement - Wales\/English\/paper\/sexual ID\/field day four","createdBy":"SYSTEM","lastRunDateTime":
		And one element of the JSON array must be {"actionPlanId":42,"surveyId":1,"name":"H2SD10-PWE","description":"Replacement - Wales\/English\/paper\/sexual ID\/field day ten","createdBy":"SYSTEM","lastRunDateTime":
		And one element of the JSON array must be {"actionPlanId":43,"surveyId":1,"name":"H2S-PWE","description":"Replacement - Wales\/English\/paper\/sexual ID\/no field","createdBy":"SYSTEM","lastRunDateTime":
		And one element of the JSON array must be {"actionPlanId":44,"surveyId":1,"name":"H2D4-PWE","description":"Replacement - Wales\/English\/paper\/without sexual ID\/field day four","createdBy":"SYSTEM","lastRunDateTime":
		And one element of the JSON array must be {"actionPlanId":45,"surveyId":1,"name":"H2D10-PWE","description":"Replacement - Wales\/English\/paper\/without sexual ID\/field day ten","createdBy":"SYSTEM","lastRunDateTime":
		And one element of the JSON array must be {"actionPlanId":46,"surveyId":1,"name":"H2-PWE","description":"Replacement - Wales\/English\/paper\/without sexual ID\/no field","createdBy":"SYSTEM","lastRunDateTime":
		And one element of the JSON array must be {"actionPlanId":47,"surveyId":1,"name":"R-SMS4W","description":"Replacement - Wales\/SMS\/field day four","createdBy":"SYSTEM","lastRunDateTime":
		And one element of the JSON array must be {"actionPlanId":48,"surveyId":1,"name":"R-SMS10W","description":"Replacement - Wales\/SMS\/field day ten","createdBy":"SYSTEM","lastRunDateTime":
		And one element of the JSON array must be {"actionPlanId":49,"surveyId":1,"name":"R-SMSW","description":"Replacement - Wales\/SMS\/No field","createdBy":"SYSTEM","lastRunDateTime":
		And one element of the JSON array must be {"actionPlanId":54,"surveyId":1,"name":"UNIVERSITY-SMS","description":"Replacement University - England\/SMS\/no field","createdBy":"SYSTEM","lastRunDateTime":
		And one element of the JSON array must be {"actionPlanId":53,"surveyId":1,"name":"SHOUSING-SMS","description":"Replacement Sheltered Housing - England\/SMS\/field day 10","createdBy":"SYSTEM","lastRunDateTime":
		And one element of the JSON array must be {"actionPlanId":19,"surveyId":1,"name":"I-SMSE","description":"Individual - England\/SMS","createdBy":"SYSTEM","lastRunDateTime":
		And one element of the JSON array must be {"actionPlanId":55,"surveyId":1,"name":"C2EO331BIE","description":"Component 2 - England\/online\/no field\/three reminders (behavioural insight)","createdBy":"SYSTEM","lastRunDateTime":
		And one element of the JSON array must be {"actionPlanId":56,"surveyId":1,"name":"C2EO332BIE","description":"Component 2 - England\/online\/no field\/two reminders\/paper q  (behavioural insight)","createdBy":"SYSTEM","lastRunDateTime":
		And one element of the JSON array must be {"actionPlanId":14,"surveyId":1,"name":"C2EO300E","description":"Component 2 - England\/online\/no field\/no reminders","createdBy":"SYSTEM","lastRunDateTime":
		And one element of the JSON array must be {"actionPlanId":15,"surveyId":1,"name":"C2EO200E","description":"Component 2 - England\/online\/no field\/no reminders (later initial contact)","createdBy":"SYSTEM","lastRunDateTime":
		And one element of the JSON array must be {"actionPlanId":10,"surveyId":1,"name":"C2O331W","description":"Component 2 - Wales\/online\/no field\/three reminders","createdBy":"SYSTEM","lastRunDateTime":
		And one element of the JSON array must be {"actionPlanId":3,"surveyId":1,"name":"C1O331D10E","description":"Component 1 - England\/online\/field day ten\/three reminders","createdBy":"SYSTEM","lastRunDateTime":
		And one element of the JSON array must be {"actionPlanId":2,"surveyId":1,"name":"C1O331D4W","description":"Component 1 - Wales\/online\/field day four\/three reminders","createdBy":"SYSTEM","lastRunDateTime":
		And one element of the JSON array must be {"actionPlanId":5,"surveyId":1,"name":"C2SP331E","description":"Component 2 - England\/paper\/sexual ID\/no field\/three reminders","createdBy":"SYSTEM","lastRunDateTime":
		And one element of the JSON array must be {"actionPlanId":9,"surveyId":1,"name":"C2O331E","description":"Component 2 - England\/online\/no field\/three reminders","createdBy":"SYSTEM","lastRunDateTime":
		And one element of the JSON array must be {"actionPlanId":8,"surveyId":1,"name":"C2EP331W","description":"Component 2 - Wales\/paper\/without sexual ID\/no field\/three reminders","createdBy":"SYSTEM","lastRunDateTime":
		And one element of the JSON array must be {"actionPlanId":51,"surveyId":1,"name":"HOTEL","description":"Hotel - England\/online\/no field","createdBy":"SYSTEM","lastRunDateTime":
		And one element of the JSON array must be {"actionPlanId":16,"surveyId":1,"name":"C2EO331ADE","description":"Component 2 - England\/online\/no field\/three reminders (Assisted Digital)","createdBy":"SYSTEM","lastRunDateTime":
		And one element of the JSON array must be {"actionPlanId":52,"surveyId":1,"name":"UNIVERSITY","description":"University - England\/online\/no field","createdBy":"SYSTEM","lastRunDateTime":
		And one element of the JSON array must be {"actionPlanId":7,"surveyId":1,"name":"C2EP331E","description":"Component 2 - England\/paper\/without sexual ID\/no field\/three reminders","createdBy":"SYSTEM","lastRunDateTime":
		And one element of the JSON array must be {"actionPlanId":4,"surveyId":1,"name":"C1O331D10W","description":"Component 1 - Wales\/online\/field day ten\/three reminders","createdBy":"SYSTEM","lastRunDateTime":
		And one element of the JSON array must be {"actionPlanId":50,"surveyId":1,"name":"SHOUSING","description":"Sheltered Housing - England\/online\/field day 10","createdBy":"SYSTEM","lastRunDateTime":
		And one element of the JSON array must be {"actionPlanId":11,"surveyId":1,"name":"C2EO332E","description":"Component 2 - England\/online\/no field\/three reminders (final reminder HH questionnaire)","createdBy":"SYSTEM","lastRunDateTime":
		And one element of the JSON array must be {"actionPlanId":6,"surveyId":1,"name":"C2SP331W","description":"Component 2 - Wales\/paper\/sexual ID\/no field\/three reminders","createdBy":"SYSTEM","lastRunDateTime":
		And one element of the JSON array must be {"actionPlanId":1,"surveyId":1,"name":"C1O331D4E","description":"Component 1 - England\/online\/field day four\/three reminders","createdBy":"SYSTEM","lastRunDateTime":
		And one element of the JSON array must be {"actionPlanId":0,"surveyId":2,"name":"DTM TEST","description":"DTM Test Action plan - no associated rules","createdBy":"SYSTEM","lastRunDateTime":


	# 204
	# Not tested as action plans already preloaded


	# GET /actionplans/{actionPlanId}
	# 200
	Scenario: Get request to actionplans for actionPlanId
		When I make the GET call to the actionservice actionplans endpoint for specified actionPlanId "1"
		Then the response status should be 200
		And the response should contain the field "actionPlanId" with an integer value of 1
		And the response should contain the field "surveyId" with an integer value of 1
		And the response should contain the field "name" with value "C1O331D4E"
		And the response should contain the field "description" with value "Component 1 - England/online/field day four/three reminders"
		And the response should contain the field "createdBy" with value "SYSTEM"

	# 404
	Scenario: Get request to actionplans for actionPlanId not found
		When I make the GET call to the actionservice actionplans endpoint for specified actionPlanId "101"
		Then the response status should be 404
		And the response should contain the field "error.code" with value "RESOURCE_NOT_FOUND"
		And the response should contain the field "error.message" with value "ActionPlan not found for id 101"
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
		When I make the GET call to the actionservice actionplans rules endpoint for actionPlanId "1"
		Then the response status should be 200
		And one element of the JSON array must be {"actionRuleId":1,"actionPlanId":1,"priority":3,"surveyDateDaysOffset":-100,"actionTypeName":"ICL1_2003","name":"HH_ICL1-100","description":"Print initial contact letter (English)(SD-100)"}
		And one element of the JSON array must be {"actionRuleId":2,"actionPlanId":1,"priority":3,"surveyDateDaysOffset":-3,"actionTypeName":"1RL1_0504","name":"HH_1RL1-3","description":"Print reminder letter 1 (English)(SD-3)"}
		And one element of the JSON array must be {"actionRuleId":3,"actionPlanId":1,"priority":3,"surveyDateDaysOffset":2,"actionTypeName":"HouseholdCreateVisit","name":"HH_CV+2","description":"Create Household Visit(SD+2)"}
		And one element of the JSON array must be {"actionRuleId":4,"actionPlanId":1,"priority":3,"surveyDateDaysOffset":9,"actionTypeName":"2RL1_1804","name":"HH_2RL1+9","description":"Print reminder letter 2 (English)(SD+9)"}
		And one element of the JSON array must be {"actionRuleId":5,"actionPlanId":1,"priority":3,"surveyDateDaysOffset":17,"actionTypeName":"3RL1_2604","name":"HH_3RL1+17","description":"Print reminder letter 3 (English)(SD+17)"}


	# 204
	# Not tested as rules already preloaded

	# 404
	Scenario: Get request to actionplans rules for actionPlanId with plan not found
		When I make the GET call to the actionservice actionplans rules endpoint for actionPlanId "101"
		Then the response status should be 404
		And the response should contain the field "error.code" with value "RESOURCE_NOT_FOUND"
		And the response should contain the field "error.message" with value "ActionPlan not found for id 101"
		And the response should contain the field "error.timestamp"
