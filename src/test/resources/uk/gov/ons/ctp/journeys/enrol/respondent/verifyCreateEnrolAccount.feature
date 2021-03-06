# Author: Stephen Goddard 28/06/2017
#
# Keywords Summary: This feature confirms that the RM enrolment process is working as expected. The journey is specified in:
#                   https://collaborate2.ons.gov.uk/confluence/pages/viewpage.action?pageId=5190519
#                   https://collaborate2.ons.gov.uk/confluence/display/SDC/Test+Scenario+5+-+Verify+Enrolment+Code
#                   https://collaborate2.ons.gov.uk/confluence/display/SDC/Test+Scenario+6+-+Create+Account
#                   https://collaborate2.ons.gov.uk/confluence/display/SDC/Test+Scenario+7+-+Enrol+Respondent
#
# Feature: List of publish collection exercise scenarios: Pre test DB clean of sample service
#                                                         Pre test load of business sample file into sample service
#                                                         Pre test DB clean of collection exercise
#                                                         Pre test DB clean of case exercise
#                                                         Pre test DB clean of action exercise
#                                                         Pre test DB clean of actionexporter
#                                                         Generate cases
#                                                         Test case generation
#                                                         Test action case created
#                                                         Verify code by get request to the iacsvc (Journey steps: 5.3, 5.5)
#                                                         Verify code invalid by get request to the iacsvc (Journey steps: 5.3.1)
#                                                         Verify event created for code access (Journey steps: 5.4)
#                                                         Verify event created for account created (Journey steps: 6.3)
#                                                         Verify access code had been disabled (Journey steps: 6.4)
#                                                         Verify event created for respondent enrolment (Journey steps: 7.3, 7.4)
#                                                         Verify a new case have been created with the correct properties (Journey steps: 7.5, 7.6, 7.8, 7.9)
#                                                         Test actionsvc case has the expected actionplan 2 (Journey steps: 7.7)
#                                                         Service report viewed (PO4.03, Journey steps: 6.5)
#                                                         Respondent Account Created (PO5.04, Journey steps: 6.5)
#                                                         Case event report respondent enrolled count (PO6.05-6, Journey steps: 7.10)
#
#
# Feature Tags: @enroleRespondent
#
@enrolRespondent
Feature: Verify and Create Account

  # Pre Test Set Up

  # Pre Test Sample Service Environment Set Up -----

  Scenario: Reset sample service database to pre test condition
    When for the "samplesvc" run the "samplereset.sql" postgres DB script
    Then the samplesvc database has been reset

  Scenario: Load Business example survey
    When I make the POST call to the sample "bres" service endpoint for the "BSD" survey "valid" file to trigger ingestion
    When the response status should be 201
    Then the response should contain the field "sampleSummaryPK" with an integer value of 1
    And after a delay of 60 seconds


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
  Scenario: Put repuest to sample service service links the sample summary to a collection exercise
    Given I retrieve From Sample DB the Sample Summary
    Given I make the PUT call to the collection exercise for id "14fb3e68-4dca-46db-bf49-04b84e07e77c" endpoint for sample summary id

  Scenario: Execute collection exercise by post request for specific business survey by exercise id
    Given I make the POST call to the collection exercise execution endpoint for exercise id "14fb3e68-4dca-46db-bf49-04b84e07e77c"
    When the response status should be 200
    Then the response should contain the field "sampleUnitsTotal" with an integer value of 500

  Scenario: Test casesvc case DB state
    Given after a delay of 370 seconds
    When check "casesvc.case" records in DB equal 500 for "statefk = 'ACTIONABLE'"
    Then check "casesvc.case" distinct records in DB equal 500 for "iac" where "statefk = 'ACTIONABLE'"

  Scenario: Test actionsvc case DB state for actionplan 1
    Given after a delay of 60 seconds
    Then check "action.case" records in DB equal 497 for "actionplanfk = 1"
    And check "action.case" records in DB equal 3 for "actionplanfk = 2"


  # Journey Tests

  # Verify Enrolment Code -----

  # RAS 5.1, 5.2

  Scenario: Verify code by get request to the iacsvc (Journey steps: 5.3, 5.5)
    Given I make the GET call to the IAC service endpoint
    When the response status should be 200
    Then the response should contain the field "caseId"
    And the response should contain the field "caseRef"
    And the response should contain the field "iac"
    And the response should contain the field "active" with boolean value "true"
    And the response should contain the field "questionSet" with a null value
    And the response should contain the field "lastUsedDateTime"

  Scenario: Verify code invalid by get request to the iacsvc (Journey steps: 5.3.1)
    Given I make the GET call to the iacsvc endpoint for IAC "101020023003"
    When the response status should be 404
    Then the response should contain the field "error.code" with value "RESOURCE_NOT_FOUND"
    And the response should contain the field "error.message" with value "IAC not found for iac 101020023003"
    And the response should contain the field "error.timestamp"

  Scenario: Verify event created for code access (Journey steps: 5.4)
    Given I make the GET call to the caseservice cases endpoint for events
    Then the response status should be 200
    # Array size not tested as it can vary on different runs
    And one element of the JSON array must be {"createdDateTime":
    And one element of the JSON array must be ,"category":"ACCESS_CODE_AUTHENTICATION_ATTEMPT","subCategory":null,"createdBy":"SYSTEM","description":"Access Code authentication attempted"}
    And one element of the JSON array must be ,"category":"CASE_CREATED","subCategory":null,"createdBy":"SYSTEM","description":"Case created when Initial creation of case"}
    
  # Create Account -----

  # RAS 6.1, 6.2


  Scenario: Verify event created for account created (Journey steps: 6.3, 6.4)
    Given I make the POST call to the caseservice cases events
      | Created by cucumber test | RESPONDENT_ACCOUNT_CREATED | test | Cucumber Test |  |
    When the response status should be 201
    Then the response should contain the field "createdDateTime"
    And the response should contain the field "caseId"
    And the response should contain the field "partyId"
    And the response should contain the field "category" with value "RESPONDENT_ACCOUNT_CREATED"
    And the response should contain the field "subCategory" with value "test"
    And the response should contain the field "createdBy" with value "Cucumber Test"
    And the response should contain the field "description" with value "Created by cucumber test"
    Then I make the GET call to the IAC service endpoint for caseid
    And the response status should be 200
    Then the response should contain the field "caseId"
    And the response should contain the field "caseRef"
    And the response should contain the field "iac"
    And the response should contain the field "active" with boolean value "false"
    And the response should contain the field "questionSet" with a null value
    And the response should contain the field "lastUsedDateTime"


  # Enrol Account -----

  # RAS 7.1, 7.2

  Scenario: Verify event created for respondent enrolment (Journey steps: 7.3, 7.4)
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

  Scenario: Verify a new case have been created with the correct properties (Journey steps: 7.5, 7.6, 7.8, 7.9)
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

  Scenario: Test actionsvc case has the expected actionplan 2 (Journey steps: 7.7)
    Given after a delay of 60 seconds
    Then check "action.case" records in DB equal 4 for "actionplanfk = 2"


  # Report to show enrolment event

  Scenario: Test ui report to confirm respondent enroled, new account created and event viewed (PO4.03, PO5.04, PO6.05-6, Journey steps: 6.5, 7.10)
    Given the "test" user has logged in using "chrome"
    And the user navigates to the reports page and selects "case" reports
    When the user goes to view the most recent report
#    Then checks values of column number 7 against value "1" and should appear 1 times 
#    And checks values of column number 8 against value "1" and should appear 1 times and returns sample ref
#    And  checks values of column number 2 against value "BI" and should appear 4 times
#    When the user searches for case ref from case report
#    Then the user looks at the events table to see the event "Respondent Enroled" appears in column 3 
    And the user logs out
