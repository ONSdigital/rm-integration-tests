# Author: Stephen Goddard 29/09/2016
#
# Keywords Summary : This feature file contains the scenario tests for the casesvc - casegroup - details are in the swagger spec
#										 https://github.com/ONSdigital/rm-case-service/blob/master/API.md
#                    http://localhost:8171/swagger-ui.html#/
#
# Feature: List of action plan mappings scenarios: Clean DB to pre test condition
#																									 Create Sample
#																									 Confirms system is ready for test
#																									 Get the casegroup linked to by casegroupid
#																									 Get the casegroup linked to by casegroupid not found
# Feature Tags: @casesvc
#								@casegroup
#
@caseSvc @casegroup
Feature: Validating Case Group requests

	# Pre Test DB Environment Set Up -----

  Scenario: Reset sample service database to pre test condition
    When for the "samplesvc" run the "samplereset.sql" postgres DB script
    Then the samplesvc database has been reset

  Scenario: Reset collection exercise service database to pre test condition
    Given for the "collectionexercisesvc" run the "collectionexercisereset.sql" postgres DB script
    When the collectionexercisesvc database has been reset

  Scenario: Reset collection exercise service database to pre test condition
    When for the "casesvc" run the "casereset.sql" postgres DB script
    Then the casesvc database has been reset


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
    
  Scenario: Post request to collection exercise execution service for specific business survey by exercise id
    Given I make the POST call to the collection exercise execution endpoint for exercise id "14fb3e68-4dca-46db-bf49-04b84e07e77c"
    When the response status should be 200
    Then the response should contain the field "sampleUnitsTotal" with an integer value of 500

  # Pre Test Case Service Environment Set Up -----

  Scenario: Test casesvc case DB state (Journey steps: 2.3)
    Given after a delay of 420 seconds
    When check "casesvc.case" records in DB equal 500 for "statefk = 'ACTIONABLE'"
    Then check "casesvc.case" distinct records in DB equal 500 for "iac" where "statefk = 'ACTIONABLE'"


	# Endpoint Tests -----

	# GET /casegroups/{caseGroupId}
	# 200
	Scenario: Get request to casegroup for specific casegroupid
		Given I make the GET call to the caseservice casegroups endpoint for casegroupid
		When the response status should be 200
		Then the response should contain the field "collectionExerciseId"
		And the response should contain the field "id"
		And the response should contain the field "partyId"
		And the response should contain the field "sampleUnitRef"
		And the response should contain the field "sampleUnitType" with value "B"

	# 404
	Scenario: Get request to casegroup for non existing casegroupid
		Given I make the GET call to the caseservice casegroup endpoint for casegroupid "03e1016e-b639-440d-8cc2-c386b31ab1bc"
		When the response status should be 404
		Then the response should contain the field "error.code" with value "RESOURCE_NOT_FOUND"
		And the response should contain the field "error.message" with value "CaseGroup not found for casegroup id 03e1016e-b639-440d-8cc2-c386b31ab1bc"
		And the response should contain the field "error.timestamp"
