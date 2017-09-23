# Author: Stephen Goddard 11/06/2017
#
# Keywords Summary: This feature confirms that the upload response is processed from a RM point of view. The journey is specified in:
#                   https://collaborate2.ons.gov.uk/confluence/pages/viewpage.action?pageId=5190519
#                   https://collaborate2.ons.gov.uk/confluence/display/SDC/Test+Scenario+10+-+Upload+Response
#
# Feature: List of upload collection instrument scenarios: pre test DB clean of sample service
#                                                          load business sample
#                                                          pre test DBclean of collection exercise service
#                                                          pre test DBclean of case service
#                                                          pre test DBclean of action service
#                                                          Generate cases
#                                                          Generate BI cases
#                                                          Return Open Cases for respondent (Journey steps: 10.3)
#                                                          Create case event for upload (Journey steps: 10.6)
#                                                          Create case event for failed upload (Journey steps: 10.6.1)
#                                                          Change case state (Journey steps: 10.7)
#                                                          Service report viewed (PO9.04, Journey steps: 10.8)
#
# Feature Tags: @uploadResponse
#
@uploadResponse
Feature: Tests the response has been uploaded (RM)

  # Pre Test Set Up

  # Pre Test Sample Service Environment Set Up -----

  Scenario: Reset sample service database to pre test condition
    When for the "samplesvc" run the "samplereset.sql" postgres DB script
    Then the samplesvc database has been reset

  Scenario: Load Business example survey
    Given clean sftp folders of all previous ingestions for "BSD" surveys
    And the sftp exit status should be "-1"
    When for the "BSD" survey move the "valid" file to trigger ingestion
    And the sftp exit status should be "-1"
    And after a delay of 50 seconds
    Then for the "BSD" survey confirm processed file "BSD-survey-full*.xml.processed" is found
    And the sftp exit status should be "-1"


  # Pre Test Collection Exercise Service Environment Set Up -----

  Scenario: Reset collection exercise service database to pre test condition
    Given for the "collectionexercisesvc" run the "collectionexercisereset.sql" postgres DB script
    When the collectionexercisesvc database has been reset


  # Pre Test Case Service Environment Set Up -----

  Scenario: Reset case service database to pre test condition
    When for the "casesvc" run the "casereset.sql" postgres DB script
    Then the casesvc database has been reset


  # Pre Test Action Service Environment Set Up -----

  Scenario: Reset action service database to pre test condition
    When for the "actionsvc" run the "actionreset.sql" postgres DB script
    Then the actionsvc database has been reset


  # Generate Cases -----

  Scenario: Test execute from collection exercise by put request for specific business survey by exercise id (Journey steps: 2.1, 2.2, 2.3)
    Given I make the PUT call to the collection exercise endpoint for exercise id "14fb3e68-4dca-46db-bf49-04b84e07e77c"
    When the response status should be 200
    Then the response should contain the field "sampleUnitsTotal" with an integer value of 500

  Scenario: Test casesvc case for business survey DB state (Journey steps: 2.4, 2.5, 2.8)
    Given after a delay of 280 seconds
    When check "casesvc.case" records in DB equal 500 for "statefk = 'ACTIONABLE'"
    Then check "casesvc.case" distinct records in DB equal 500 for "iac" where "statefk = 'ACTIONABLE'"
    
  Scenario: Test actionsvc case for business survey DB state for actionplan 1 (Journey steps: 2.6, 2.7)
    Given after a delay of 60 seconds
    When check "action.case" records in DB equal 498 for "actionplanfk = 1"
    And check "action.case" records in DB equal 2 for "actionplanfk = 2"
    Then check "casesvc.caseevent" records in DB equal 500 for "description = 'Case created when Initial creation of case'"


  # Generate Cases BI -----

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

  Scenario: Verify a new case have been created with the correct properties
    Given after a delay of 60 seconds
    When I make the GET call to the caseservice cases endpoint for new case
    And the response status should be 200
    Then the response should contain the field "id"
    And the response should contain the field "state" with value "ACTIONABLE"
    And the response should contain the field "iac"
    And the response should contain the field "caseRef"
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


  # Journey Test

  # Upload Response -----


  # RAS 10.1, 10.2


  # Return Open Cases for respondent 10.3
  
  Scenario: Get request to cases for specific case id to test case state for partyid
    Given I make the GET call to the caseservice cases endpoint for party with parameters ""
    When the response status should be 200
    Then the response should contain a JSON array of size 2
    And one element of the JSON array must be {"id":
    And one element of the JSON array must be ,"state":"INACTIONABLE","iac":null,"caseRef":
    And one element of the JSON array must be ,"actionPlanId":
    And one element of the JSON array must be ,"collectionInstrumentId":
    And one element of the JSON array must be ,"partyId":
    And one element of the JSON array must be ,"sampleUnitType":"B","createdBy":"SYSTEM","createdDateTime":
    And one element of the JSON array must be ,"responses":[],"caseGroup":{
    And one element of the JSON array must be },"caseEvents":null}
    # BI unit
    And one element of the JSON array must be ,"state":"ACTIONABLE","iac":null,"caseRef":"1000000000000501","actionPlanId":
    And one element of the JSON array must be ,"sampleUnitType":"BI","createdBy":"Cucumber Test","createdDateTime":


  # Return No Open Cases for respondent 10.3.1


  # RAS 10.4, 10.4.1, 10.5, 10.5.1


  # Create case event for failed upload 10.6.1 -----

  Scenario: Post request for cases events endpoint for case id to confirm unsuccessful upload event
    When I make the POST call to the caseservice cases events for "BI"
      | Unsuccessful Upload | UNSUCCESSFUL_RESPONSE_UPLOAD |  | Cucumber Test |  |
    Then the response status should be 201
    Then the response should contain the field "createdDateTime"
    And the response should contain the field "caseId"
    And the response should contain the field "partyId"
    And the response should contain the field "category" with value "UNSUCCESSFUL_RESPONSE_UPLOAD"
    And the response should contain the field "subCategory" with value ""
    And the response should contain the field "createdBy" with value "Cucumber Test"
    And the response should contain the field "description" with value "Unsuccessful Upload"
    And check "casesvc.caseevent" records in DB equal 1 for "description = 'Unsuccessful Upload'"


  # Create case event for upload 10.6 -----

  Scenario: Post request for cases events endpoint for case id to confirm successful upload event
    When I make the POST call to the caseservice cases events for "BI"
      | Collection Instrument Uploaded | SUCCESSFUL_RESPONSE_UPLOAD |  | Cucumber Test |  |
    Then the response status should be 201
    Then the response should contain the field "createdDateTime"
    And the response should contain the field "caseId"
    And the response should contain the field "partyId"
    And the response should contain the field "category" with value "SUCCESSFUL_RESPONSE_UPLOAD"
    And the response should contain the field "subCategory" with value ""
    And the response should contain the field "createdBy" with value "Cucumber Test"
    And the response should contain the field "description" with value "Collection Instrument Uploaded"
    And check "casesvc.caseevent" records in DB equal 1 for "description = 'Collection Instrument Uploaded'"


  # Change case state 10.7 -----

  # GET /cases/{partyId} including with ?caseevents=true and ?iac=true
  # 200
  Scenario: Get request to cases for specific case id to test case state for partyid
    Given I make the GET call to the caseservice cases endpoint for party with parameters "?caseevents=true"
    When the response status should be 200
    Then the response should contain a JSON array of size 2
    And one element of the JSON array must be {"id":
    And one element of the JSON array must be ,"state":"INACTIONABLE","iac":null,"caseRef":
    And one element of the JSON array must be ,"actionPlanId":
    And one element of the JSON array must be ,"collectionInstrumentId":
    And one element of the JSON array must be ,"partyId":
    And one element of the JSON array must be ,"sampleUnitType":"B","createdBy":"SYSTEM","createdDateTime":
    And one element of the JSON array must be ,"responses":[],"caseGroup":{
    # BI unit
    And one element of the JSON array must be ,"state":"INACTIONABLE","iac":null,"caseRef":"1000000000000501","actionPlanId":
    And one element of the JSON array must be ,"sampleUnitType":"BI","createdBy":"Cucumber Test","createdDateTime":
    And one element of the JSON array must be ,"category":"UNSUCCESSFUL_RESPONSE_UPLOAD","subCategory":"","createdBy":"Cucumber Test","description":"Unsuccessful Upload"}
    And one element of the JSON array must be ,"category":"SUCCESSFUL_RESPONSE_UPLOAD","subCategory":"","createdBy":"Cucumber Test","description":"Collection Instrument Uploaded"}


  # Report (Journey steps: 10.8)
  Scenario: Service report viewed (PO9.04/08  Journey steps: 10.8))
    Given after a delay of 80 seconds
    Given the "test" user has logged in using "chrome"
    When the user navigates to the reports page and selects "case" reports
    When the user goes to view the most recent report
    And  checks values of column number 11 against value "1" and should appear 1 times
    And  checks values of column number 12 against value "1" and should appear 1 times
    Then the user logs out
