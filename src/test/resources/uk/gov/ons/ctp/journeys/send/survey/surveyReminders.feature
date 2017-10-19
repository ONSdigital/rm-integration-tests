# Author: Stephen Goddard 11/07/2017
#
# Keywords Summary: This feature confirms that the survey reminders are generated as expected. The journey is specified in:
#                   https://collaborate2.ons.gov.uk/confluence/pages/viewpage.action?pageId=5190519
#                   https://collaborate2.ons.gov.uk/confluence/display/SDC/Test+Scenario+8+-+Send+Survey+Reminders
#
# Feature: List of survey reminders scenarios: Pre test DB clean of sample service
#                                              Pre test load of business sample file into sample service
#                                              Pre test DB clean of collection exercise
#                                              Pre test DB clean of case exercise
#                                              Pre test DB clean of action exercise
#                                              Generate cases
#                                              Test case generation
#                                              Test action case created
#                                              Test survey reminder (first) action creation by change date offset and case event creation (Journey steps: 8.1, 8.2, 8.3, 8.4, 8.5, 8.6, 8.7)
#                                              Test survey reminder (second) action creation by change date offset and case event creation (Journey steps: 8.1, 8.2, 8.3, 8.4, 8.5, 8.6, 8.7)
#                                              Service report viewed (P10.02-3,Journey steps: 8.8)
#
# Feature Tags: @sendSurveyReminders
#
@sendSurveyReminders
Feature: Tests the survey reminders are sent

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
    When for the "collectionexercisesvc" run the "collectionexercisereset.sql" postgres DB script
    Then the collectionexercisesvc database has been reset


  # Pre Test Case Service Environment Set Up -----

  Scenario: Reset case service database to pre test condition
    When for the "casesvc" run the "casereset.sql" postgres DB script
    Then the casesvc database has been reset


  # Pre Test Action Service Environment Set Up -----

  Scenario: Reset action service database to pre test condition
    When for the "actionsvc" run the "actionreset.sql" postgres DB script
    Then the actionsvc database has been reset


  # Generate Cases -----

  Scenario: Execute collection exercise by put request for specific business survey by exercise id
    Given I make the PUT call to the collection exercise endpoint for exercise id "14fb3e68-4dca-46db-bf49-04b84e07e77c"
    When the response status should be 200
    Then the response should contain the field "sampleUnitsTotal" with an integer value of 500

  Scenario: Test casesvc case DB state
    Given after a delay of 400 seconds
    When check "casesvc.case" records in DB equal 500 for "statefk = 'ACTIONABLE'"
    Then check "casesvc.case" distinct records in DB equal 500 for "iac" where "statefk = 'ACTIONABLE'"

  Scenario: Test actionsvc case DB state for actionplan 1
    Given after a delay of 60 seconds
    Then check "action.case" records in DB equal 497 for "actionplanfk = 1"
    And check "action.case" records in DB equal 3 for "actionplanfk = 2"


  # Create respondent case to send survey reminders to

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


  # Journey Tests

  # Send Survey Reminder Email (First) -----

  Scenario: Test action creation by post request to create actions for specified action plan (Journey steps: 8.1, 8.2, 8.3, 8.4, 8.5, 8.6, 8.7)
    Given the case start date is adjusted to trigger action plan
      | actionplanfk  | actionrulepk | actiontypefk | total |
      | 2             | 4            | 3            | 4     |
    When after a delay of 90 seconds
    Then check "action.action" records in DB
      | actionplanfk  | actionrulepk | actiontypefk | statefk   | total |
      | 2             | 4            | 3            | COMPLETED | 4     |
    And check "casesvc.caseevent" records in DB equal 4 for "description = 'Survey Reminder Notification'"

  # Report not developed so not tested (Journey steps: 8.8)


  # Send Enrolment Reminder Letters (Second) -----

  Scenario: Test action creation by post request to create actions for specified action plan (Journey steps: 8.1, 8.2, 8.3, 8.4, 8.5, 8.6, 8.7)
    Given the case start date is adjusted to trigger action plan
      | actionplanfk  | actionrulepk | actiontypefk | total |
      | 2             | 5            | 3            | 4     |
    When after a delay of 90 seconds
    Then check "action.action" records in DB
      | actionplanfk  | actionrulepk | actiontypefk | statefk   | total |
      | 2             | 5            | 3            | COMPLETED | 4     |
    And check "casesvc.caseevent" records in DB equal 8 for "description = 'Survey Reminder Notification'"


  # Report (Journey steps: 8.8)

  Scenario: Test ui report to confirm the actions count and the case events are viewed (P10.02-3,Journey steps: 8.8)
    Given the "test" user has logged in using "chrome"
    When the user navigates to the reports page and selects "action" reports
    When the user goes to view the most recent report
    And checks value for column 6 and row 6 with value "4"
    When the user navigates to the reports page and selects "case" reports
    When the user goes to view the most recent report
    And  checks values of column number 5 against value "2" and should appear 4 times
    Then the user logs out
