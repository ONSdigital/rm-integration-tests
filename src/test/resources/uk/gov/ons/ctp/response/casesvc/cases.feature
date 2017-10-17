# Author: Stephen Goddard 04/03/2016
#
# Keywords Summary : This feature file contains the scenario tests for the casesvc - cases - details are in the swagger spec
#                    https://github.com/ONSdigital/rm-case-service/blob/master/API.md
#                    http://localhost:8171/swagger-ui.html#/
#
# Feature: List of cases scenarios: Clean DB to pre test condition
#																		Create Sample
#																		Confirms system is ready for test
#																		Get casegroup by valid casegroupid
#																		Get casegroup by invalid casegroupid
#																		Get cases by valid case
#                                   Get cases by valid case with casevents param filter
#                                   Get cases by valid case with iac param filter
#																		Get cases by invalid case
#                                   Get cases by valid party
#                                   Get cases by valid party with casevents param filter
#                                   Get cases by valid party with iac param filter
#                                   Get cases by invalid party
#                                   Get cases by valid access code
#                                   Get cases by valid access code with casevents param filter
#                                   Get cases by valid access code with iac param filter
#                                   Get cases by invalid access code
#                                   Get case events by valid case
#                                   Get case events by invalid case
#                                   Post case events by valid case without optional field
#                                   Post case events by valid case with optional field
#                                   Post case events by invalid case
#                                   Post case events with invalid json
#
# Feature Tags: @casesvc
#								@case
#
@caseSvc @case
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
    Given after a delay of 400 seconds
    When check "casesvc.case" records in DB equal 500 for "statefk = 'ACTIONABLE'"
    Then check "casesvc.case" distinct records in DB equal 500 for "iac" where "statefk = 'ACTIONABLE'"


	# Endpoint Tests -----

  # GET /cases/casegroupid/{casegroupid}
  #200
  Scenario: Get request to cases for specific casegroupid
    Given I make the GET call to the caseservice cases endpoint for casegroupid
    When the response status should be 200
    Then the response should contain a JSON array of size 1
    And one element of the JSON array must be "id":
    And one element of the JSON array must be ,"state":"ACTIONABLE","actionPlanId":
    And one element of the JSON array must be ,"collectionInstrumentId":
    And one element of the JSON array must be ,"partyId":
    And one element of the JSON array must be ,"caseRef":
    And one element of the JSON array must be ,"createdBy":"SYSTEM","sampleUnitType":"B","createdDateTime":
    And one element of the JSON array must be ,"responses":[]}

  # 404
  Scenario: Get request to cases for non existing casegroupid
    Given I make the GET call to the caseservice cases endpoint for casegroupid "03e1016e-b639-440d-8cc2-c386b31ab1bc"
    When the response status should be 404
    Then the response should contain the field "error.code" with value "RESOURCE_NOT_FOUND"
    And the response should contain the field "error.message" with value "CaseGroup not found for casegroup id 03e1016e-b639-440d-8cc2-c386b31ab1bc"
    And the response should contain the field "error.timestamp"


	# GET /cases/{caseId} including with ?caseevents=true and ?iac=true
	# 200
	Scenario: Get request to cases for specific case id
		Given I make the GET call to the caseservice cases endpoint for case with parameters ""
		When the response status should be 200
		Then the response should contain the field "id"
		And the response should contain the field "state" with value "ACTIONABLE"
		And the response should contain the field "iac" with a null value
		And the response should contain the field "caseRef"
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
    And the response should contain the field "caseRef"
    And the response should contain the field "actionPlanId"
    And the response should contain the field "collectionInstrumentId"
    And the response should contain the field "partyId"
    And the response should contain the field "sampleUnitType" with value "B"
    And the response should contain the field "createdBy" with value "SYSTEM"
    And the response should contain the field "createdDateTime"
    And the response should contain the field "responses" with one element of the JSON array must be []
    And the response should contain the field "caseGroup"
    And the response should contain the field "caseEvents" with one element of the JSON array must be [{"createdDateTime":
    And the response should contain the field "caseEvents" with one element of the JSON array must be ,"category":"CASE_CREATED","subCategory":null,"createdBy":"SYSTEM","description":"Case created when Initial creation of case"}

  Scenario: Get request to cases for specific case id
    Given I make the GET call to the caseservice cases endpoint for case with parameters "?iac=true"
    When the response status should be 200
    Then the response should contain the field "id"
    And the response should contain the field "state" with value "ACTIONABLE"
    And the response should contain the field "iac"
    And the response should contain the field "caseRef"
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
    And one element of the JSON array must be "id":
    And one element of the JSON array must be ,"state":"ACTIONABLE","iac":null,"caseRef":
    And one element of the JSON array must be ,"actionPlanId":
    And one element of the JSON array must be ,"collectionInstrumentId":
    And one element of the JSON array must be ,"partyId":
    And one element of the JSON array must be ,"sampleUnitType":"B","createdBy":"SYSTEM","createdDateTime":
    And one element of the JSON array must be ,"responses":[],"caseGroup":{
    And one element of the JSON array must be },"caseEvents":null}

  Scenario: Get request to cases for specific case id
    Given I make the GET call to the caseservice cases endpoint for party with parameters "?caseevents=true"
    When the response status should be 200
    Then the response should contain a JSON array of size 1
    And one element of the JSON array must be "id":
    And one element of the JSON array must be ,"state":"ACTIONABLE","iac":null,"caseRef":
    And one element of the JSON array must be ,"actionPlanId":
    And one element of the JSON array must be ,"collectionInstrumentId":
    And one element of the JSON array must be ,"partyId":
    And one element of the JSON array must be ,"sampleUnitType":"B","createdBy":"SYSTEM","createdDateTime":
    And one element of the JSON array must be ,"responses":[],"caseGroup":{
    And one element of the JSON array must be "caseEvents":[{"createdDateTime"
    And one element of the JSON array must be ,"category":"CASE_CREATED","subCategory":null,"createdBy":"SYSTEM","description":"Case created when Initial creation of case"}

  Scenario: Get request to cases for specific case id
    Given I make the GET call to the caseservice cases endpoint for party with parameters "?iac=true"
    When the response status should be 200
    Then the response should contain a JSON array of size 1
    And one element of the JSON array must be "id":
    And one element of the JSON array must be ,"state":"ACTIONABLE","iac":
    And one element of the JSON array must be ,"actionPlanId":
    And one element of the JSON array must be ,"caseRef":
    And one element of the JSON array must be ,"collectionInstrumentId":
    And one element of the JSON array must be ,"partyId":
    And one element of the JSON array must be ,"sampleUnitType":"B","createdBy":"SYSTEM","createdDateTime":
    And one element of the JSON array must be ,"responses":[],"caseGroup":{
    And one element of the JSON array must be },"caseEvents":null}

  # 204
  Scenario: Get request to the cases endpoint for a non existing party id
    Given I make the GET call to the caseservice cases endpoint for party "87c8b602-aabd-4fc3-8676-bb875f4ce101"
    When the response status should be 204


  # GET /cases/iac/{iac} including with ?caseevents=true and ?iac=true
  # 200
  Scenario: Get request to cases for iac
    Given I make the GET call to the caseservice case endpoint for iac with parameters ""
    When the response status should be 200
    Then the response should contain the field "id"
    And the response should contain the field "state" with value "ACTIONABLE"
    And the response should contain the field "iac" with a null value
    And the response should contain the field "caseRef"
    And the response should contain the field "actionPlanId"
    And the response should contain the field "collectionInstrumentId"
    And the response should contain the field "partyId"
    And the response should contain the field "sampleUnitType" with value "B"
    And the response should contain the field "createdBy" with value "SYSTEM"
    And the response should contain the field "createdDateTime"
    And the response should contain the field "responses" with one element of the JSON array must be []
    And the response should contain the field "caseGroup"
    And the response should contain the field "caseEvents" with a null value

  Scenario: Get request to cases for iac
    Given I make the GET call to the caseservice case endpoint for iac with parameters "?caseevents=true"
    When the response status should be 200
    Then the response should contain the field "id"
    And the response should contain the field "state" with value "ACTIONABLE"
    And the response should contain the field "iac" with a null value
    And the response should contain the field "caseRef"
    And the response should contain the field "actionPlanId"
    And the response should contain the field "collectionInstrumentId"
    And the response should contain the field "partyId"
    And the response should contain the field "sampleUnitType" with value "B"
    And the response should contain the field "createdBy" with value "SYSTEM"
    And the response should contain the field "createdDateTime"
    And the response should contain the field "responses" with one element of the JSON array must be []
    And the response should contain the field "caseGroup"
    And the response should contain the field "caseEvents" with one element of the JSON array must be [{"createdDateTime":
    And the response should contain the field "caseEvents" with one element of the JSON array must be ,"category":"ACCESS_CODE_AUTHENTICATION_ATTEMPT","subCategory":null,"createdBy":"SYSTEM","description":"Access Code authentication attempted"}
    And the response should contain the field "caseEvents" with one element of the JSON array must be ,"category":"CASE_CREATED","subCategory":null,"createdBy":"SYSTEM","description":"Case created when Initial creation of case"}

  Scenario: Get request to cases for iac
    Given I make the GET call to the caseservice case endpoint for iac with parameters "?iac=true"
    When the response status should be 200
    Then the response should contain the field "id"
    And the response should contain the field "state" with value "ACTIONABLE"
    And the response should contain the field "iac"
    And the response should contain the field "caseRef"
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
  Scenario: Get request to cases for a non existing iac
    Given I make the GET call to the caseservice case endpoint for invalid iac "ABCDEFGHIJK"
    When the response status should be 404
    Then the response should contain the field "error.code" with value "RESOURCE_NOT_FOUND"
    And the response should contain the field "error.message" with value "Case not found for iac ABCDEFGHIJK"
    And the response should contain the field "error.timestamp"


  # GET /cases/{caseId}/events
  # 200
  Scenario: Get request for events of a specific case id
    Given I make the GET call to the caseservice cases endpoint for events
    Then the response status should be 200
    # Array size not tested as it can vary on different runs
    And one element of the JSON array must be {"createdDateTime":
    And one element of the JSON array must be ,"category":"ACCESS_CODE_AUTHENTICATION_ATTEMPT","subCategory":null,"createdBy":"SYSTEM","description":"Access Code authentication attempted"}
    And one element of the JSON array must be ,"category":"CASE_CREATED","subCategory":null,"createdBy":"SYSTEM","description":"Case created when Initial creation of case"}

  # 404
  Scenario: Get request for cases events endpoint for a non existing case id
    When I make the GET call to the caseservice cases endpoint for events for case "87c8b602-aabd-4fc3-8676-bb875f4ce101"
    Then the response status should be 404
    And the response should contain the field "error.code" with value "RESOURCE_NOT_FOUND"
    And the response should contain the field "error.message" with value "Case not found for case id 87c8b602-aabd-4fc3-8676-bb875f4ce101"
    And the response should contain the field "error.timestamp"


  # POST /cases/{caseId}/events
  # 201
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

  Scenario: Post request for cases events endpoint for case id
    When I make the POST call to the caseservice cases events
      | Created by cucumber test | ACTION_CREATED |  | Cucumber Test |  |
    Then the response status should be 201
    Then the response should contain the field "createdDateTime"
    And the response should contain the field "caseId"
    And the response should contain the field "partyId"
    And the response should contain the field "category" with value "ACTION_CREATED"
    And the response should contain the field "subCategory" with value ""
    And the response should contain the field "createdBy" with value "Cucumber Test"
    And the response should contain the field "description" with value "Created by cucumber test"

  # 404
  Scenario: Post request for cases events endpoint for case id
    When I make the POST call to the caseservice cases events
      | Created by cucumber test | ACTION_CREATED | test | Cucumber Test | 87c8b602-aabd-4fc3-8676-bb875f4ce101 |
    Then the response status should be 404
    And the response should contain the field "error.code" with value "RESOURCE_NOT_FOUND"
    And the response should contain the field "error.message" with value "Case not found for case id 87c8b602-aabd-4fc3-8676-bb875f4ce101"
    And the response should contain the field "error.timestamp"

  # 400
  Scenario: Post request for cases events endpoint for case id
    When I make the POST call to the caseservice cases events
      |  |  | test | Cucumber Test |  |
    Then the response status should be 400
    And the response should contain the field "error.code" with value "VALIDATION_FAILED"
    And the response should contain the field "error.message" with value "Provided json is incorrect."
    And the response should contain the field "error.timestamp"   


  # INFO /info
  # 200
  Scenario: Info request to case service for current verison number
    Given I make the call to the caseservice endpoint for info
    When the response status should be 200
    Then the response should contain the field "name" with value "casesvc"
    And the response should contain the field "version"
    And the response should contain the field "origin"
    And the response should contain the field "commit"
    And the response should contain the field "branch"
