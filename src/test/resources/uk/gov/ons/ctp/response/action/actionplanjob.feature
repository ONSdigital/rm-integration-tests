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
#
@actionsvc @actionPlanJob
Feature: Validating actionPlanJob requests

	# Clean Environment -----

 # @indCleanEnvironment
 # Scenario: Clean DB to pre test condition
 #   When reset the postgres DB
 #   Then check "casesvc.case" records in DB equal 0
 #   And check "casesvc.caseevent" records in DB equal 0
#		And check "casesvc.casegroup" records in DB equal 0#
#		And check "casesvc.contact" records in DB equal 0
#		And check "casesvc.response" records in DB equal 0
#    And check "casesvc.messagelog" records in DB equal 0
#    And check "casesvc.unlinkedcasereceipt" records in DB equal 0
 #   And check "action.action" records in DB equal 0
  #  And check "action.actionplanjob" records in DB equal 0
  #  And check "action.case" records in DB equal 0
  #  And check "action.messagelog" records in DB equal 0
  #  And check "casesvc.caseeventidseq" sequence in DB equal 1
  #  And check "casesvc.caseidseq" sequence in DB equal 1
  #  And check "casesvc.casegroupidseq" sequence in DB equal 1
  #  And check "casesvc.caserefseq" sequence in DB equal 1000000000000001
   # And check "casesvc.responseidseq" sequence in DB equal 1
   # And check "casesvc.messageseq" sequence in DB equal 1
   # And check "action.actionidseq" sequence in DB equal 1
   # And check "action.actionplanjobseq" sequence in DB equal 1
   # And check "action.messageseq" sequence in DB equal 1



	# Endpoint Tests -----

	# GET /actionplans/jobs/{actionPlanJobId}
	# 200
	Scenario: Get request to actionplans for jobs
		When I make the GET call to the actionservice actionplans endpoint for specific plan job "3ca2ae0a-dd82-4a40-ab3c-4e0df626fb54"
		Then the response status should be 200
		And the response should contain the field "id"
		And the response should contain the field "actionPlanId" with value "e71002ac-3575-47eb-b87f-cd9db92bf9a7"
		And the response should contain the field "createdBy" with value "SYSTEM"
		And the response should contain the field "state" with value "COMPLETED"
		And the response should contain the field "createdDateTime"
		And the response should contain the field "updatedDateTime"

	# 404
	Scenario: Get request to actionplans for jobs not found
		When I make the GET call to the actionservice actionplans endpoint for specific plan job "00000000-dd82-4a40-ab3c-4e0df626fb54"
		Then the response status should be 404
		And the response should contain the field "error.code" with value "RESOURCE_NOT_FOUND"
		And the response should contain the field "error.message" with value "ActionPlanJob not found for id 00000000-dd82-4a40-ab3c-4e0df626fb54"
		And the response should contain the field "error.timestamp"


	# GET /actionplans/{actionPlanId}/jobs  
	# 200
	Scenario: Get request to actionplans for list of all jobs for specified action plan
		When I make the GET call to the actionservice actionplans endpoint for jobs with specific plan "e71002ac-3575-47eb-b87f-cd9db92bf9a7"
		Then the response status should be 200
		And one element of the JSON array must be {"id":
		And one element of the JSON array must be ,"actionPlanId":"e71002ac-3575-47eb-b87f-cd9db92bf9a7"
		And one element of the JSON array must be ,"createdBy":"SYSTEM"
		And one element of the JSON array must be ,"state":"COMPLETED"
        And one element of the JSON array must be ,"createdDateTime":
		And one element of the JSON array must be ,"updatedDateTime":
			
	# 404

	Scenario: Get request to actionplans for list of all jobs for specified action plan not found
		When I make the GET call to the actionservice actionplans endpoint for jobs with specific plan "e71002ac-3575-47eb-b87f-cd9db92bf000"
		Then the response status should be 404


	# POST /actionplans/{actionPlanId}/jobs
	# 201
	Scenario: Post request to actionplans to create jobs for specified action plan
		When I make the POST call to the actionservice actionplans endpoint for jobs with specific plan "e71002ac-3575-47eb-b87f-cd9db92bf9a7"
				| e71002ac-3575-47eb-b87f-cd9db92bf9a7 | CucumberTest | SUBMITTED |
		Then the response status should be 201
		And the response should contain the field "id"
		And the response should contain the field "actionPlanId" with value "e71002ac-3575-47eb-b87f-cd9db92bf9a7"
		And the response should contain the field "createdBy" with value "CucumberTest"
		And the response should contain the field "state" with value "SUBMITTED"
		And the response should contain the field "createdDateTime"
		And the response should contain the field "updatedDateTime"

	# 400
	Scenario: Post request to actionplans to create jobs for specified action plan with invalid input
		When I make the POST call to the actionservice actionplans endpoint for jobs with specific plan "e71002ac-3575-47eb-b87f-cd9db92bf000" with invalid input
		Then the response status should be 400
		And the response should contain the field "error.code" with value "VALIDATION_FAILED"
		And the response should contain the field "error.message" with value "Provided json is incorrect."
		And the response should contain the field "error.timestamp"
		
	# 404
	@actionPlanJob1
	Scenario: Post request to actionplans to create jobs for specified action plan not found
		When I make the POST call to the actionservice actionplans endpoint for jobs with specific plan "e71002ac-3575-47eb-b87f-cd9db92bf000"
		| e71002ac-3575-47eb-b87f-cd9db92bf9b9 |  CucumberTest | SUBMITTED |
		Then the response status should be 404
		And the response should contain the field "error.code" with value "RESOURCE_NOT_FOUND"
		And the response should contain the field "error.message" with value "ActionPlan not found for id e71002ac-3575-47eb-b87f-cd9db92bf000"
		And the response should contain the field "error.timestamp"
	