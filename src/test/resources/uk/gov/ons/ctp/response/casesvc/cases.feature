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
#
@casesvc @case
Feature: Validating cases requests

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
    Given clean sftp folders of all previous ingestions for "business" surveys 
    And the sftp exit status should be "-1" 
    When for the "business" survey move the "valid" file to trigger ingestion 
    And the sftp exit status should be "-1" 
    And after a delay of 30 seconds 
    Then for the "business" survey confirm processed file "business-survey-full*.xml.processed" is found 
    And the sftp exit status should be "-1"


  # Pre Test Collection Exercise Service Environment Set Up -----

  Scenario: Put request to collection exercise service for specific business survey by exercise id 2.1, 2.2
    Given I make the PUT call to the collection exercise endpoint for exercise id "14fb3e68-4dca-46db-bf49-04b84e07e77c"
    When the response status should be 200
    Then the response should contain the field "sampleUnitsTotal" with an integer value of 500


  # Pre Test Case Service Environment Set Up -----

  Scenario: Test casesvc case DB state (Journey steps: 2.3)
    Given after a delay of 180 seconds
    When check "casesvc.case" records in DB equal 500 for "state = 'ACTIONABLE'"
    Then check "casesvc.case" distinct records in DB equal 500 for "iac" where "state = 'ACTIONABLE'"


	# Endpoint Tests -----

	# GET /cases/{caseId} including with ?caseevents=true and ?iac=true
	# 200
	Scenario: Get request to cases for specific case id
		Given I make the GET call to the caseservice cases endpoint for case with parameters ""
		When the response status should be 200
		Then the response should contain the field "id"
		And the response should contain the field "state" with value "ACTIONABLE"
		And the response should contain the field "iac" with a null value
		And the response should contain the field "actionPlanId"
		And the response should contain the field "collectionInstrumentId"
		And the response should contain the field "partyId"
		And the response should contain the field "sampleUnitType" with value "B"
		And the response should contain the field "createdBy" with value "SYSTEM"
		And the response should contain the field "createdDateTime"
		And the response should contain the field "responses" with one element of the JSON array must be []
		And the response should contain the field "caseGroup"
		And the response should contain the field "caseEvents" with a null value

  Scenario: Get request to cases for specific case id
    Given I make the GET call to the caseservice cases endpoint for case with parameters "?caseevents=true"
    When the response status should be 200
    Then the response should contain the field "id"
    And the response should contain the field "state" with value "ACTIONABLE"
    And the response should contain the field "iac" with a null value
    And the response should contain the field "actionPlanId"
    And the response should contain the field "collectionInstrumentId"
    And the response should contain the field "partyId"
    And the response should contain the field "sampleUnitType" with value "B"
    And the response should contain the field "createdBy" with value "SYSTEM"
    And the response should contain the field "createdDateTime"
    And the response should contain the field "responses" with one element of the JSON array must be []
    And the response should contain the field "caseGroup"
    And the response should contain the field "caseEvents" with one element of the JSON array must be []

  Scenario: Get request to cases for specific case id
    Given I make the GET call to the caseservice cases endpoint for case with parameters "?iac=true"
    When the response status should be 200
    Then the response should contain the field "id"
    And the response should contain the field "state" with value "ACTIONABLE"
    And the response should contain the field "iac"
    And the response should contain the field "actionPlanId"
    And the response should contain the field "collectionInstrumentId"
    And the response should contain the field "partyId"
    And the response should contain the field "sampleUnitType" with value "B"
    And the response should contain the field "createdBy" with value "SYSTEM"
    And the response should contain the field "createdDateTime"
    And the response should contain the field "responses" with one element of the JSON array must be []
    And the response should contain the field "caseGroup"
    And the response should contain the field "caseEvents" with a null value

	# 404
	Scenario: Get request to the cases endpoint for a non existing case id
		Given I make the GET call to the caseservice cases endpoint for case "87c8b602-aabd-4fc3-8676-bb875f4ce101"
		When the response status should be 404
		Then the response should contain the field "error.code" with value "RESOURCE_NOT_FOUND"
		And the response should contain the field "error.message" with value "Case not found for case id 87c8b602-aabd-4fc3-8676-bb875f4ce101"
		And the response should contain the field "error.timestamp"


  # GET /cases/{partyId} including with ?caseevents=true and ?iac=true
  # 200
  Scenario: Get request to cases for specific case id
    Given I make the GET call to the caseservice cases endpoint for party with parameters ""
    When the response status should be 200
    Then the response should contain a JSON array of size 1
    And one element of the JSON array must be {"id":
    And one element of the JSON array must be ,"state":"ACTIONABLE","iac":null,"actionPlanId":
    And one element of the JSON array must be ,"collectionInstrumentId":
    And one element of the JSON array must be ,"partyId":
    And one element of the JSON array must be ,"sampleUnitType":"B","createdBy":"SYSTEM","createdDateTime":
    And one element of the JSON array must be ,"responses":[],"caseGroup":{
    And one element of the JSON array must be },"caseEvents":null}
 
  Scenario: Get request to cases for specific case id
    Given I make the GET call to the caseservice cases endpoint for party with parameters "?caseevents=true"
    When the response status should be 200
    Then the response should contain a JSON array of size 1
    And one element of the JSON array must be {"id":
    And one element of the JSON array must be ,"state":"ACTIONABLE","iac":null,"actionPlanId":
    And one element of the JSON array must be ,"collectionInstrumentId":
    And one element of the JSON array must be ,"partyId":
    And one element of the JSON array must be ,"sampleUnitType":"B","createdBy":"SYSTEM","createdDateTime":
    And one element of the JSON array must be ,"responses":[],"caseGroup":{
    And one element of the JSON array must be },"caseEvents":[]}

  Scenario: Get request to cases for specific case id
    Given I make the GET call to the caseservice cases endpoint for party with parameters "?iac=true"
    When the response status should be 200
    And one element of the JSON array must be {"id":
    And one element of the JSON array must be ,"state":"ACTIONABLE","iac":
    And one element of the JSON array must be ,"actionPlanId":
    And one element of the JSON array must be ,"collectionInstrumentId":
    And one element of the JSON array must be ,"partyId":
    And one element of the JSON array must be ,"sampleUnitType":"B","createdBy":"SYSTEM","createdDateTime":
    And one element of the JSON array must be ,"responses":[],"caseGroup":{
    And one element of the JSON array must be },"caseEvents":null}

  # 404
  Scenario: Get request to the cases endpoint for a non existing case id
    Given I make the GET call to the caseservice cases endpoint for party "87c8b602-aabd-4fc3-8676-bb875f4ce101"
    When the response status should be 204


  # GET /cases/{caseId}/events
  # 200
  @events
  Scenario: Get request for events of a specific case id
    Given I make the GET call to the caseservice cases endpoint for events
    Then the response status should be 200
    And the response should contain a JSON array of size 3
    And one element of the JSON array must be {"createdDateTime":
    And one element of the JSON array must be ,"category":"ENROLMENT_CODE_VERIFIED","subCategory":null,"createdBy":"SYSTEM","description":"Enrolement code verified"}

  # 204
  @events
  Scenario: Get request for events of a specific case id where no case events exist
    Given I make the GET call to the caseservice cases endpoint for events
    Then the response status should be 204

  # 404
  @events
  Scenario: Get request for cases events endpoint for a non existing case id
    When I make the GET call to the caseservice cases endpoint for events for case "87c8b602-aabd-4fc3-8676-bb875f4ce101"
    Then the response status should be 404
    And the response should contain the field "error.code" with value "RESOURCE_NOT_FOUND"
    And the response should contain the field "error.message" with value "Case not found for case id 87c8b602-aabd-4fc3-8676-bb875f4ce101"
    And the response should contain the field "error.timestamp"


  # GET /cases/iac/{iac} including with ?caseevents=true and ?iac=true
  # 200
  Scenario: Get request to cases for iac
    Given I make the GET call to the caseservice case endpoint for iac with parameters ""
    When the response status should be 200
    Then the response should contain the field "id"
    And the response should contain the field "state" with value "ACTIONABLE"
    And the response should contain the field "iac" with a null value
    And the response should contain the field "actionPlanId"
    And the response should contain the field "collectionInstrumentId"
    And the response should contain the field "partyId"
    And the response should contain the field "sampleUnitType" with value "B"
    And the response should contain the field "createdBy" with value "SYSTEM"
    And the response should contain the field "createdDateTime"
    And the response should contain the field "responses" with one element of the JSON array must be []
    And the response should contain the field "caseGroup" with value "collectionExerciseId"
    And the response should contain the field "caseEvents" with a null value
    
#   And the response should contain the field "caseGroupId" with an integer value of 10
#   And the response should contain the field "caseRef" with value "1000000000000010"
    
#   And the response should contain the field "caseTypeId" with an integer value of 17
#   And the response should contain the field "actionPlanMappingId" with an integer value of 17
#   And the response should contain the field "createdDateTime"
#   And the response should contain the field "createdBy" with value "SYSTEM"
#   And the response should contain the field "iac"
#   And the response should contain the field "responses" with one element of the JSON array must be []
#   And the response should contain the field "contact" with a null value

#{,"caseGroup":{"collectionExerciseId":"14fb3e68-4dca-46db-bf49-04b84e07e77c","id":"fc9b35f7-f212-410c-8ae7-6686dbc7a009","partyId":"06c8ac67-62d0-4af2-a765-1619708ad169","sampleUnitRef":"50000066526","sampleUnitType":"B"},"caseEvents":null}

  Scenario: Get request to cases for iac
    Given I make the GET call to the caseservice case endpoint for iac with parameters "?caseevents=true"
    When the response status should be 200
    Then the response should contain the field "id"
    And the response should contain the field "state" with value "ACTIONABLE"
    And the response should contain the field "iac" with a null value
    And the response should contain the field "actionPlanId"
    And the response should contain the field "collectionInstrumentId"
    And the response should contain the field "partyId"
    And the response should contain the field "sampleUnitType" with value "B"
    And the response should contain the field "createdBy" with value "SYSTEM"
    And the response should contain the field "createdDateTime"
    And the response should contain the field "responses" with one element of the JSON array must be []
    And the response should contain the field "caseGroup" with value "collectionExerciseId"
    And the response should contain the field "caseEvents" with one element of the JSON array must be []

  Scenario: Get request to cases for iac
    Given I make the GET call to the caseservice case endpoint for iac with parameters "?iac=true"
    When the response status should be 200
    Then the response should contain the field "id"
    And the response should contain the field "state" with value "ACTIONABLE"
    And the response should contain the field "iac"
    And the response should contain the field "actionPlanId"
    And the response should contain the field "collectionInstrumentId"
    And the response should contain the field "partyId"
    And the response should contain the field "sampleUnitType" with value "B"
    And the response should contain the field "createdBy" with value "SYSTEM"
    And the response should contain the field "createdDateTime"
    And the response should contain the field "responses" with one element of the JSON array must be []
    And the response should contain the field "caseGroup" with value "collectionExerciseId"
    And the response should contain the field "caseEvents" with a null value

  # 404
  Scenario: Get request to cases for a non existing iac
    Given I make the GET call to the caseservice case endpoint for invalid iac "ABCDEFGHIJK"
    When the response status should be 404
    Then the response should contain the field "error.code" with value "RESOURCE_NOT_FOUND"
    And the response should contain the field "error.message" with value "Case not found for iac ABCDEFGHIJK"
    And the response should contain the field "error.timestamp"


  # POST /cases/{caseId}/events
  # 201
  @post
  Scenario: Post request for cases events endpoint for case id
    Given I make the POST call to the caseservice cases events
      | Created by cucumber test | ACTION_CREATED | test | Cucumber Test |  |
    When the response status should be 201
    
    Then the response should contain the field "createdDateTime"
    And the response should contain the field "caseId"
    And the response should contain the field "partyId"
    And the response should contain the field "category" with value "ACTION_CREATED"
    And the response should contain the field "subCategory" with value "test"
    And the response should contain the field "createdBy" with value "Cucumber Test"
    And the response should contain the field "description" with value "Created by cucumber test"

  # 404
  @post
  Scenario: Post request for cases events endpoint for case id
    When I make the POST call to the caseservice cases events
      | Created by cucumber test | ACTION_CREATED | test | Cucumber Test | 87c8b602-aabd-4fc3-8676-bb875f4ce101 |
    Then the response status should be 404
    And the response should contain the field "error.code" with value "RESOURCE_NOT_FOUND"
    And the response should contain the field "error.message" with value "Case not found for case id 87c8b602-aabd-4fc3-8676-bb875f4ce101"
    And the response should contain the field "error.timestamp"

  # 400
  @post
  Scenario: Post request for cases events endpoint for case id
    When I make the POST call to the caseservice cases events
      |  |  | test | Cucumber Test |  |
    Then the response status should be 400
    And the response should contain the field "error.code" with value "VALIDATION_FAILED"
    And the response should contain the field "error.message" with value "Provided json is incorrect."
    And the response should contain the field "error.timestamp"

	# GET /cases/{caseId}/events
	# 200
#	@events
#	Scenario: Get request for events of a specific case id
#		Given I make the GET call to the caseservice cases endpoint for events
#		Then the response status should be 200
#		And the response should contain a JSON array of size 4
#		And one element of the JSON array must be {"createdDateTime":
#		And one element of the JSON array must be ,"category":"ACTION_CREATED","subCategory":"test","createdBy":"Cucumber Test","description":"Created by cucumber test"}
#		And one element of the JSON array must be {"createdDateTime":
#    And one element of the JSON array must be ,"category":"ENROLMENT_CODE_VERIFIED","subCategory":null,"createdBy":"SYSTEM","description":"Enrolement code verified"}
