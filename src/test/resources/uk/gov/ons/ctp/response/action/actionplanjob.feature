# Author: Stephen Goddard 03/05/2016
#
# Keywords Summary : This feature file contains the scenario tests for the action service - actionPlanJob endpoints - details are in the swagger spec
#										 https://github.com/ONSdigital/rm-action-service/blob/master/API.md
#
# Feature: List of action plan job scenarios: Pre test DB clean of sample service
#                                             Pre test load of business sample file into sample service
#                                             Pre test DB clean of collection exercise
#                                             Pre test DB clean of case exercise
#                                             Pre test DB clean of action exercise
#																					  Pre test seed of action service
#                                             Pre test DB clean of actionexporter
#                                             Pre test previous print file clean of actionexporter
#                                             Generate cases
#                                             Test case generation
#                                             Test action case created
#                                             Get action plan jobs by action plan job id
#                                             Get action plan jobs by action plan job id not found
#                                             Get action plan jobs by action plan id
#                                             Get action plan jobs by action plan id not found
#                                             Post to run jobs for action plan id
#                                             Post to run jobs for action plan id with invalid json
#                                             Post to run jobs for action plan id not found
#
# Feature Tags: @actionSvc
#							  @actionPlanJob
#
@actionSvc @actionPlanJob
Feature: Validating actionPlanJob requests

  # Pre Test DB Environment Set Up -----

  Scenario: Reset sample service database to pre test condition
    When for the "samplesvc" run the "samplereset.sql" postgres DB script
    Then the samplesvc database has been reset

  Scenario: Reset collection exercise service database to pre test condition
    Given for the "collectionexercisesvc" run the "collectionexercisereset.sql" postgres DB script
    When the collectionexercisesvc database has been reset

  Scenario: Reset case service database to pre test condition
    When for the "casesvc" run the "casereset.sql" postgres DB script
    Then the casesvc database has been reset

  Scenario: Reset action service database to pre test condition
    When for the "actionsvc" run the "actionreset.sql" postgres DB script
    Then the actionsvc database has been reset
    
  Scenario: Seed action service database to pre test condition
    When for the "actionsvc" run the "actionseed.sql" postgres DB script
    Then the actionsvc database has been seeded


  # Pre Test Sample Service Environment Set Up -----

  Scenario: Test business sample load
    When I make the POST call to the sample "bres" service endpoint for the "BSD" survey "valid" file to trigger ingestion
    When the response status should be 201
    Then the response should contain the field "sampleSummaryPK" with an integer value of 1
    And after a delay of 50 seconds


  # Pre Test Collection Exercise Service Environment Set Up -----
   Scenario: Test repuest to sample service service links the sample summary to a collection exercise
    Given I retrieve From Sample DB the Sample Summary
    Given I make the PUT call to the collection exercise for id "14fb3e68-4dca-46db-bf49-04b84e07e77c" endpoint for sample summary id
    And after a delay of 50 seconds

  Scenario: Post request to collection exercise execution service for specific business survey by exercise id 2.1, 2.2
    Given I make the POST call to the collection exercise execution endpoint for exercise id "14fb3e68-4dca-46db-bf49-04b84e07e77c"
    When the response status should be 200
    Then the response should contain the field "sampleUnitsTotal" with an integer value of 500


  # Pre Test Case Service Environment Set Up -----
  Scenario: Test casesvc case DB state
    Given after a delay of 420 seconds
    When check "casesvc.case" records in DB equal 500 for "statefk = 'ACTIONABLE'"
    Then check "casesvc.case" distinct records in DB equal 500 for "iac" where "statefk = 'ACTIONABLE'"


  # Pre Test Action Service Environment Set Up -----

  Scenario: Test actionsvc case DB state for actionplan 1
    Given after a delay of 60 seconds
    When check "action.case" records in DB equal 497 for "actionplanfk = 1"
    And check "action.case" records in DB equal 3 for "actionplanfk = 2"


  Scenario: Test action creation by post request to create jobs for specified action plan
    Given the case start date is adjusted to trigger action plan
      | actionplanfk  | actionrulepk | actiontypefk | total |
      | 1             | 1            | 1            | 497   |
    When after a delay of 90 seconds
    Then check "action.action" records in DB equal 997 for "statefk = 'COMPLETED'"
    When check "casesvc.caseevent" records in DB equal 497 for "description = 'Enrolment Invitation Letter'"


	# Endpoint Tests -----

	# GET /actionplans/jobs/{actionPlanJobId}
	# 200
	Scenario: Get request to actionplans for jobs
		When I make the GET call to the actionservice actionplans endpoint for specific plan job
		Then the response status should be 200
		And the response should contain the field "id"
		And the response should contain the field "actionPlanId"
		And the response should contain the field "createdBy" with value "SYSTEM"
		And the response should contain the field "state" with value "COMPLETED"
		And the response should contain the field "createdDateTime"
		And the response should contain the field "updatedDateTime"

	# 404
	Scenario: Get request to actionplans for jobs not found
		When I make the GET call to the actionservice actionplans endpoint for specific plan job "10100000-dd82-4a40-ab3c-4e0df626fb54"
		Then the response status should be 404
		And the response should contain the field "error.code" with value "RESOURCE_NOT_FOUND"
		And the response should contain the field "error.message" with value "ActionPlanJob not found for id 10100000-dd82-4a40-ab3c-4e0df626fb54"
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

  #204 - Not Tested as pre existing respondents BI trigger action plan jobs - Revisit when testing party service
#  Scenario: Get request to actionplans for list of all jobs for specified action plan
#    When I make the GET call to the actionservice actionplans endpoint for jobs with specific plan "0009e978-0932-463b-a2a1-b45cb3ffcb2a"
#    Then the response status should be 204

	# 404
	Scenario: Get request to actionplans for list of all jobs for specified action plan not found
		When I make the GET call to the actionservice actionplans endpoint for jobs with specific plan "10100000-dd82-4a40-ab3c-4e0df626fb54"
		Then the response status should be 404
		And the response should contain the field "error.code" with value "RESOURCE_NOT_FOUND"
    And the response should contain the field "error.message" with value "ActionPlan not found for id 10100000-dd82-4a40-ab3c-4e0df626fb54"
    And the response should contain the field "error.timestamp"


	# POST /actionplans/{actionPlanId}/jobs
	# 201
	Scenario: Post request to actionplans to create jobs for specified action plan
		When I make the POST call to the actionservice actionplans endpoint for jobs with specific plan
		  | e71002ac-3575-47eb-b87f-cd9db92bf9a7 | CucumberTest |
		Then the response status should be 201
		And the response should contain the field "id"
		And the response should contain the field "actionPlanId" with value "e71002ac-3575-47eb-b87f-cd9db92bf9a7"
		And the response should contain the field "createdBy" with value "CucumberTest"
		And the response should contain the field "state" with value "SUBMITTED"
		And the response should contain the field "createdDateTime"
		And the response should contain the field "updatedDateTime"

	# 400
	Scenario: Post request to actionplans to create jobs for specified action plan with invalid input
		When I make the POST call to the actionservice actionplans endpoint for jobs with specific plan "e71002ac-3575-47eb-b87f-cd9db92bf9a7" with invalid input
		Then the response status should be 400
		And the response should contain the field "error.code" with value "VALIDATION_FAILED"
#		And the response should contain the field "error.message" with value "Provided json is incorrect."
		And the response should contain the field "error.timestamp"
		
	# 404
	Scenario: Post request to actionplans to create jobs for specified action plan not found
		When I make the POST call to the actionservice actionplans endpoint for jobs with specific plan
		  | e71002ac-3575-47eb-b87f-cd9db92bf101 |  CucumberTest |
		Then the response status should be 404
		And the response should contain the field "error.code" with value "RESOURCE_NOT_FOUND"
		And the response should contain the field "error.message" with value "ActionPlan not found for id e71002ac-3575-47eb-b87f-cd9db92bf101"
		And the response should contain the field "error.timestamp"
	