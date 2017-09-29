# Author: Stephen Goddard 11/06/2017
#
# Keywords Summary: This feature confirms that the offline response is processed from a RM point of view. The journey is specified in:
#                   https://collaborate2.ons.gov.uk/confluence/pages/viewpage.action?pageId=5190519
#                   https://collaborate2.ons.gov.uk/confluence/display/SDC/Test+Scenario+11+-+Process+Offline+Response
#
# Feature: List of offline response scenarios: pre test DB clean of sample service
#                                              load business sample
#                                              pre test DBclean of collection exercise service
#                                              pre test DBclean of case service
#                                              pre test DBclean of action service
#                                              Generate cases
#                                              Generate BI cases
#                                              Create case event for offline response (Journey steps: 11.4)
#
# NOTE: Report not developed so not tested (Journey steps: 11.5)
#
# Feature Tags: @uploadResponse
#
@offlineResponse
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
    Given check "action.case" records in DB equal 3 for "actionplanfk = 2"


  # Journey Test

  # Offline Response -----

  # RAS 11.1, 11.2, 11.3

  # Offline response processed 11.3? -----
  
  # Create case event for offline response 11.4 -----

  Scenario: Post request for cases events endpoint for case id (Journey steps: 11.4)
    Given I make the POST call to the caseservice cases events for "BI"
      | Offline Response | OFFLINE_RESPONSE_PROCESSED |  | Cucumber Test |  |
    When the response status should be 201
    Then the response should contain the field "createdDateTime"
    And the response should contain the field "caseId"
    And the response should contain the field "partyId"
    And the response should contain the field "category" with value "OFFLINE_RESPONSE_PROCESSED"
    And the response should contain the field "subCategory" with value ""
    And the response should contain the field "createdBy" with value "Cucumber Test"
    And the response should contain the field "description" with value "Offline Response"
    And check "casesvc.caseevent" records in DB equal 1 for "description = 'Offline Response'"
    And check "casesvc.response" records in DB equal 1
    And check "action.case" records in DB equal 2 for "actionplanfk = 2"


  # Report 

  Scenario: Test ui report to confirm offline response count (P11.03, Journey steps: 11.4)
    Given after a delay of 65 seconds
    Given the "test" user has logged in using "chrome"
    When the user navigates to the reports page and selects "case" reports
    When the user goes to view the most recent report
    And  checks values of column number 13 against value "1" and should appear 1 times
    Then the user logs out
