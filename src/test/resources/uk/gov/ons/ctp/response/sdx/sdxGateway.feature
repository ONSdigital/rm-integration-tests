# Author: Stephen Goddard 29/09/2016
#
# Keywords Summary : This feature file contains the scenario tests for the sdxgateway - receipt - details are in the swagger spec
#                    https://github.com/ONSdigital/rm-sdx-gateway/blob/master/API.md
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
#                                    Get info endpoint
#
# Feature Tags: @sdxGateway
#
@sdxGateway
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


  # Generate Cases BI -----
@test1
  Scenario: Verify event created for respondent enrolment
    Given I make the POST call to the caseservice cases events
      | Created by cucumber test | RESPONDENT_ENROLED | test | Cucumber Test |  |
    When the response status should be 201
    And the response should contain the field "createdDateTime"
    And the response should contain the field "caseId"
    And the response should contain the field "partyId"
    And the response should contain the field "category" with value "RESPONDENT_ENROLED"
    And the response should contain the field "subCategory" with value "test"
    And the response should contain the field "createdBy" with value "Cucumber Test"
    And the response should contain the field "description" with value "Created by cucumber test"
    Then Check the case state has changed
    And the response status should be 200
    And the response should contain the field "state" with value "INACTIONABLE"
@test1
  Scenario: Verify a new case have been created with the correct properties
    Given after a delay of 60 seconds
    When I make the GET call to the caseservice cases endpoint for new case
    And the response status should be 200
    Then the response should contain the field "id"
    And the response should contain the field "state" with value "ACTIONABLE"
    And the response should contain the field "iac"
    And the response should contain the field "actionPlanId" with value "0009e978-0932-463b-a2a1-b45cb3ffcb2a"
    And the response should contain the field "collectionInstrumentId"
    And the response should contain the field "partyId"
    And the response should contain the field "sampleUnitType" with value "BI"
    And the response should contain the field "createdBy" with value "Cucumber Test"
    And the response should contain the field "createdDateTime"
    And the response should contain the field "responses" with one element of the JSON array must be []
    And the response should contain the field "caseGroup"
    And the response should contain the field "caseEvents" with one element of the JSON array must be [{"createdDateTime":
    And the response should contain the field "caseEvents" with one element of the JSON array must be ,"category":"CASE_CREATED","subCategory":null,"createdBy":"SYSTEM","description":"Case created when Respondent Enroled"}

  Scenario: test new case has been added to the action service cases
    Given check "action.case" records in DB equal 1 for "actionplanfk = 2"


  # Endpoint Tests -----

  # GET /info
  # 200
  Scenario: Info request to SDX gateway for current verison number
    Given I make the call to the SDX gateway endpoint for info
    When the response status should be 200
    Then the response should contain the field "name" with value "sdxgatewaysvc"
    And the response should contain the field "version"
    And the response should contain the field "origin" with value "git@github.com:ONSdigital/rm-sdx-gateway.git"
    And the response should contain the field "commit"
    And the response should contain the field "branch" with value "master"
    And the response should contain the field "built"


  # POST /receipts
  # 201
#  Scenario: Post request for SDX Gateway endpoint for B case not receiptable
#    Given I make the POST call to the SDX Gateway online receipt for "B" case with caseref
#    When the response status should be 201
#    And the response should contain the field "caseId"
#    And the response should contain the field "caseRef"
#    And after a delay of 5 seconds
#    Then check "casesvc.response" records in DB equal 0
#    And check "action.case" records in DB equal 1 for "actionplanfk = 2"

  # 201
  @test1
  Scenario: Post request for SDX Gateway endpoint for BI case receiptable
    Given I make the POST call to the SDX Gateway online receipt for "BI" case with caseref
    When the response status should be 201
    And the response should contain the field "caseId"
    And the response should contain the field "caseRef"
    And after a delay of 5 seconds
    Then check "casesvc.response" records in DB equal 1
    And check "action.case" records in DB equal 0 for "actionplanfk = 2"

  # 201
  @test1
  Scenario: Post request for SDX Gateway endpoint for BI case receiptable
    Given I make the POST call to the SDX Gateway online receipt for "BI" case without caseref
    When the response status should be 201
    And the response should contain the field "caseId"
    And the response should contain the field "caseRef"
    And after a delay of 5 seconds
    Then check "casesvc.response" records in DB equal 2
    And check "action.case" records in DB equal 0 for "actionplanfk = 2"

  # 400
  Scenario: Post request for SDX Gateway endpoint for missing caseid
    When I make the POST call to the SDX Gateway online receipt for missing caseid
    And the response should contain the field "error.code" with value "VALIDATION_FAILED"
    And the response should contain the field "error.message" with value "Provided json fails validation."
    And the response should contain the field "error.timestamp"
