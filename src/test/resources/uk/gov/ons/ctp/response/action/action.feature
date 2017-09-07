# Author: Stephen Goddard 29/04/2016
# Keywords Summary : This feature file contains the scenario tests for the action service - action endpoints - details are in the swagger spec
#										 https://github.com/ONSdigital/rm-action-service/blob/master/API.md
#
# Feature: List of action scenarios: Pre test DB clean of sample service
#                                    Pre test load of business sample file into sample service
#                                    Pre test DB clean of collection exercise
#                                    Pre test DB clean of case exercise
#                                    Pre test DB clean of action exercise
#                                    Pre test DB clean of actionexporter
#                                    Pre test previous print file clean of actionexporter
#                                    Generate cases
#                                    Test case generation
#                                    Test action case created
#                                    Get actions with no filters
#                                    Get actions with action type filter
#                                    Get actions with status filter
#                                    Get actions with action type and status filter
#                                    Get actions with action type and status filter when no actions exist
#                                    Get actions for case by case id
#                                    Get actions for case by case id which does not exist
#                                    Get actions by action id
#                                    Get actions by action id which does not exist
#																		 Put action feedback by action id (Commented out as currently unable to generate the conditions to run)
#																     Put action feedback by action id with invalid input
#
# Feature Tags: @actionSvc
#							  @action
#
@actionSvc @action
Feature: Validating action requests

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


  # Pre Test Sample Service Environment Set Up -----

  Scenario: Test business sample load
    Given clean sftp folders of all previous ingestions for "BSD" surveys 
    And the sftp exit status should be "-1" 
    When for the "BSD" survey move the "valid" file to trigger ingestion 
    And the sftp exit status should be "-1" 
    And after a delay of 80 seconds 
    Then for the "BSD" survey confirm processed file "BSD-survey-full*.xml.processed" is found 
    And the sftp exit status should be "-1"


  # Pre Test Collection Exercise Service Environment Set Up -----
  Scenario: Put request to collection exercise service for specific business survey by exercise id 2.1, 2.2
    Given I make the PUT call to the collection exercise endpoint for exercise id "14fb3e68-4dca-46db-bf49-04b84e07e77c"
    When the response status should be 200
    Then the response should contain the field "sampleUnitsTotal" with an integer value of 500


  # Pre Test Case Service Environment Set Up -----
  Scenario: Test casesvc case DB state
    Given after a delay of 280 seconds
    When check "casesvc.case" records in DB equal 500 for "statefk = 'ACTIONABLE'"
    Then check "casesvc.case" distinct records in DB equal 500 for "iac" where "statefk = 'ACTIONABLE'"


  # Pre Test Action Service Environment Set Up -----

  Scenario: Test actionsvc case DB state for actionplan 1
    Given after a delay of 60 seconds
    When check "action.case" records in DB equal 500 for "actionplanfk = 1"

  Scenario: Test action creation by post request to create jobs for specified action plan
    Given the case start date is adjusted to trigger action plan
      | actionplanfk  | actionrulepk | actiontypefk | total |
      | 1             | 1            | 1            | 500   |
    When after a delay of 90 seconds
    Then check "action.action" records in DB equal 500 for "statefk = 'COMPLETED'"
    When check "casesvc.caseevent" records in DB equal 500 for "description = 'Enrolment Invitation Letter'"


  # Endpoint Tests -----

  # GET /actions
  # 200
  Scenario: Get request to actionswith no filters
    Given I make the GET call to the actionservice actions endpoint
        |  |  |
    When the response status should be 200
    Then the response should contain a JSON array of size 500
    # Not complete record checked due to dynamic values which change for each test
    And one element of the JSON array must be {"id":
    And one element of the JSON array must be ,"caseId":
    And one element of the JSON array must be ,"actionPlanId":
    And one element of the JSON array must be ,"actionRuleId":
    And one element of the JSON array must be ,"actionTypeName":"BSNOT"
    And one element of the JSON array must be ,"createdBy":"SYSTEM"
    And one element of the JSON array must be ,"manuallyCreated":false
    And one element of the JSON array must be ,"situation":
    And one element of the JSON array must be ,"priority":3
    And one element of the JSON array must be ,"createdDateTime":
    And one element of the JSON array must be ,"state":"COMPLETED"
    And one element of the JSON array must be ,"updatedDateTime":

  # 200
  Scenario: Get request to actions filtered by actionType
    Given I make the GET call to the actionservice actions endpoint
        | BSNOT |  |
    When the response status should be 200
    Then the response should contain a JSON array of size 500
    # Not complete record checked due to dynamic values which change for each test
    And one element of the JSON array must be {"id":
    And one element of the JSON array must be ,"caseId":
    And one element of the JSON array must be ,"actionPlanId":
    And one element of the JSON array must be ,"actionRuleId":
    And one element of the JSON array must be ,"actionTypeName":"BSNOT"
    And one element of the JSON array must be ,"createdBy":"SYSTEM"
    And one element of the JSON array must be ,"manuallyCreated":false
    And one element of the JSON array must be ,"situation":
    And one element of the JSON array must be ,"priority":3
    And one element of the JSON array must be ,"createdDateTime":
    And one element of the JSON array must be ,"state":"COMPLETED"
    And one element of the JSON array must be ,"updatedDateTime":

  # 200
  Scenario: Get request to actions filtered by status
    Given I make the GET call to the actionservice actions endpoint
        |  | COMPLETED |
    When the response status should be 200
    Then the response should contain a JSON array of size 500
    # Not complete record checked due to dynamic values which change for each test
    And one element of the JSON array must be {"id":
    And one element of the JSON array must be ,"caseId":
    And one element of the JSON array must be ,"actionPlanId":
    And one element of the JSON array must be ,"actionRuleId":
    And one element of the JSON array must be ,"actionTypeName":"BSNOT"
    And one element of the JSON array must be ,"createdBy":"SYSTEM"
    And one element of the JSON array must be ,"manuallyCreated":false
    And one element of the JSON array must be ,"situation":
    And one element of the JSON array must be ,"priority":3
    And one element of the JSON array must be ,"createdDateTime":
    And one element of the JSON array must be ,"state":"COMPLETED"
    And one element of the JSON array must be ,"updatedDateTime":

  # 200
  Scenario: Get request to actions filtered by actionType and status
    Given I make the GET call to the actionservice actions endpoint
        | BSNOT | COMPLETED |
    When the response status should be 200
    Then the response should contain a JSON array of size 500
    # Not complete record checked due to dynamic values which change for each test
    And one element of the JSON array must be {"id":
    And one element of the JSON array must be ,"caseId":
    And one element of the JSON array must be ,"actionPlanId":
    And one element of the JSON array must be ,"actionRuleId":
    And one element of the JSON array must be ,"actionTypeName":"BSNOT"
    And one element of the JSON array must be ,"createdBy":"SYSTEM"
    And one element of the JSON array must be ,"manuallyCreated":false
    And one element of the JSON array must be ,"situation":
    And one element of the JSON array must be ,"priority":3
    And one element of the JSON array must be ,"createdDateTime":
    And one element of the JSON array must be ,"state":"COMPLETED"
    And one element of the JSON array must be ,"updatedDateTime":

  # 204
  Scenario: Get request to actions filtered by actionType and status when no actions exist
    Given I make the GET call to the actionservice actions endpoint
        | BRESSNE | SUBMITTED |
    When the response status should be 204
    And the response should contain the field "error.code" with value "RESOURCE_NOT_FOUND"
    And the response should contain the field "error.message" with value "ActionPlan not found for id 10100000-dd82-4a40-ab3c-4e0df626fb54"
    And the response should contain the field "error.timestamp"


  # GET /actions/caseid/{caseId}
  # 200 
  Scenario: Get request to actions for case id reteaved from DB
    Given I make the GET call to the actionservice actions endpoint for caseId
    When the response status should be 200
    Then one element of the JSON array must be {"id":
    And one element of the JSON array must be ,"caseId":
    And one element of the JSON array must be ,"actionPlanId":
    And one element of the JSON array must be ,"actionRuleId":
    And one element of the JSON array must be ,"actionTypeName":"BSNOT"
    And one element of the JSON array must be ,"createdBy":"SYSTEM"
    And one element of the JSON array must be ,"manuallyCreated":false
    And one element of the JSON array must be ,"situation":
    And one element of the JSON array must be ,"priority":3
    And one element of the JSON array must be ,"createdDateTime":
    And one element of the JSON array must be ,"state":"COMPLETED"
    And one element of the JSON array must be ,"updatedDateTime":

  # 204
  Scenario: Get request to actions for invalid case id
    Given I make the GET call to the actionservice actions endpoint for caseId "87c8b602-aabd-4fc3-8676-bb875f4ce101"
    When the response status should be 204
    And the response should contain the field "error.code" with value "RESOURCE_NOT_FOUND"
    And the response should contain the field "error.message" with value "ActionPlan not found for id 10100000-dd82-4a40-ab3c-4e0df626fb54"
    And the response should contain the field "error.timestamp"


  # GET /actions/{actionId}
  # 200
  Scenario: Get request to actions for specific action id
    Given I make the GET call to the actionservice actions endpoint for actionId
    When the response status should be 200
    Then the response should contain the field "id"
    And the response should contain the field "caseId"
    And the response should contain the field "actionPlanId"
    And the response should contain the field "actionRuleId" with a null value
    And the response should contain the field "actionTypeName" with value "BSNOT"
    And the response should contain the field "createdBy" with value "SYSTEM"
    And the response should contain the field "manuallyCreated" with boolean value "false"
    And the response should contain the field "priority" with an integer value of 3
    And the response should contain the field "situation" with a null value
    And the response should contain the field "state" with value "COMPLETED"
    And the response should contain the field "createdDateTime"
    And the response should contain the field "updatedDateTime"
  
  # 404
  Scenario: Get request to actions for action id not found
    Given I make the GET call to the actionservice actions endpoint for actionId "88c8b602-aabd-4fc3-8676-bb875f4ce101"
    When the response status should be 404
    Then the response should contain the field "error.code" with value "RESOURCE_NOT_FOUND"
    And the response should contain the field "error.message" with value "Action not found for id 88c8b602-aabd-4fc3-8676-bb875f4ce101"
    And the response should contain the field "error.timestamp"


  # PUT /actions/{actionId}/feedback
  # 200
  # TODO: do this when feed back is required for an event that doesn't go straight to completed
#  Scenario: Put request to actions with invalid input
#    Given I make the PUT call to the actionservice feedback endpoint
#      | e71002ac-3575-47eb-b87f-cd9db92bf9a7  | QGPOL | cucumberTest |
#    And the response status should be 201
#    When I make the PUT call to the actionservice actions feedback endpoint for actionId "12"
#    Then the response status should be 200
#    And the response should contain the field "actionId" with an integer value of 12
#    And the response should contain the field "caseId" with an integer value of 1
#    And the response should contain the field "actionPlanId" with a null value
#    And the response should contain the field "actionRuleId" with a null value
#    And the response should contain the field "actionTypeName" with value "QGPOL"
#    And the response should contain the field "createdBy" with value "cucumberTest"
#    And the response should contain the field "manuallyCreated" with boolean value "true"
#    And the response should contain the field "priority" with an integer value of 3
#    And the response should contain the field "situation" with value "CI Test Run"
#    And the response should contain the field "state" with value "COMPLETED"
#    And the response should contain the field "createdDateTime"
#    And the response should contain the field "updatedDateTime"

  # 400
  Scenario: Put request to actions with invalid input
    When I make the PUT call to the actionservice actions feedback endpoint with invalid input
    Then the response status should be 400
    Then the response should contain the field "error.code" with value "RESOURCE_NOT_FOUND"
    And the response should contain the field "error.message" with value "Action not found for id 88c8b602-aabd-4fc3-8676-bb875f4ce101"
    And the response should contain the field "error.timestamp"

  # 404 TODO write 404 test


  # INFO /info
  # 200
  Scenario: Info request to action service for current verison number
    Given I make the call to the actionservice endpoint for info
    When the response status should be 200
    Then the response should contain the field "name" with value "actionsvc"
    And the response should contain the field "version"
    And the response should contain the field "origin"
    And the response should contain the field "commit"
    And the response should contain the field "branch"
        
