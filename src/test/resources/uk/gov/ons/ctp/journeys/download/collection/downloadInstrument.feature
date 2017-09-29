# Author: Stephen Goddard 11/06/2017
#
# Keywords Summary: This feature confirms that the download of the collection instrument from a RM point of view. The journey is specified in:
#                   https://collaborate2.ons.gov.uk/confluence/pages/viewpage.action?pageId=5190519
#                   https://collaborate2.ons.gov.uk/confluence/display/SDC/Test+Scenario+9+-+Download+Collection+Instrument
#
# Feature: List of download collection instrument scenarios: pre test DB clean of sample service
#                                                            load business sample
#                                                            pre test DBclean of collection exercise service
#                                                            pre test DBclean of case service
#                                                            pre test DBclean of action service
#                                                            Generate cases
#                                                            Generate BI cases
#                                                            Return Open Cases for respondent (Journey steps: 9.3)
#                                                            Create case event for download (Journey steps: 9.6)
#
# Feature Tags: @downloadCollection
#
@downloadCollection
Feature: Tests the collection instrument is downloaded (RM)

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
    Given after a delay of 360 seconds
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

  # Download Collection Instrument -----


  # RAS 9.1, 9.2


  # Return Open Cases for respondent 9.3 ----- partyid

  Scenario: Get request to cases for specific case id to test case state for partyid
    Given I make the GET call to the caseservice cases endpoint for case by party
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


  # Return No Open Cases for respondent 9.3.1 ----- partyid


  # RAS 9.4, 9.5


  # Create case event for download 9.6 -----

  Scenario: Post request for cases events endpoint for case id to confirm download event
    Given I make the POST call to the caseservice cases events for "BI"
      | Collection Instrument Downloaded | COLLECTION_INSTRUMENT_DOWNLOADED |  | Cucumber Test |  |
    When the response status should be 201
    Then the response should contain the field "createdDateTime"
    And the response should contain the field "caseId"
    And the response should contain the field "partyId"
    And the response should contain the field "category" with value "COLLECTION_INSTRUMENT_DOWNLOADED"
    And the response should contain the field "subCategory" with value ""
    And the response should contain the field "createdBy" with value "Cucumber Test"
    And the response should contain the field "description" with value "Collection Instrument Downloaded"
    And check "casesvc.caseevent" records in DB equal 1 for "description = 'Collection Instrument Downloaded'"


  Scenario: Test ui report to confirm the download count and the BI case count is correct (PO8.03)
    Given after a delay of 65 seconds
    When the "test" user has logged in using "chrome"
    And the user navigates to the reports page and selects "case" reports
    Then the user goes to view the most recent report
    And checks values of column number 10 against value "1" and should appear 1 times
    And checks values of column number 2 against value "BI" and should appear 3 times
    Then the user logs out
