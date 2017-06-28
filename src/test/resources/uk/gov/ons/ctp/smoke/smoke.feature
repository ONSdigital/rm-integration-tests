# Author: Stephen Goddard 25/05/2017
#
# Keywords Summary: This feature is a smoke test that confirms basic system checks
#
# Feature: List of smoke test scenarios: pre test clean of sample service
#                                        test business sample load
#                                        test business sample load validation failure
#                                        test census sample load
#                                        test census sample load validation failure
#                                        test social sample load
#                                        test social sample load validation failure
#                                        test business survey publish
#                                        test census survey publish
#                                        test social survey publish
#                                        test case service case generation
#                                        test action service case and action generation with case event
#
# Feature Tags: @smoke
#
# Scenario Tags: ---
#
@smoke
Feature: Smoke Test

  # Pre Test Environment Set Up -----

  Scenario: Reset sample service database to pre test condition
    When for the "samplesvc" run the "samplereset.sql" postgres DB script
    Then the samplesvc database has been reset

  Scenario: Reset collection exercise service database to pre test condition
    Given for the "collectionexercisesvc" run the "collectionexercisereset.sql" postgres DB script
    When the collectionexercisesvc database has been reset

  Scenario: Reset collection exercise service database to pre test condition
    When for the "casesvc" run the "casereset.sql" postgres DB script
    Then the casesvc database has been reset

  Scenario: Reset action service database to pre test condition
    When for the "actionsvc" run the "actionreset.sql" postgres DB script
    Then the actionsvc database has been reset


  # Sample Service Smoke Tests -----

  Scenario: Test business sample load
    Given clean sftp folders of all previous ingestions for "business" surveys 
    And the sftp exit status should be "-1" 
    When for the "business" survey move the "valid" file to trigger ingestion 
    And the sftp exit status should be "-1" 
    And after a delay of 50 seconds 
    Then for the "business" survey confirm processed file "business-survey-full*.xml.processed" is found 
    And the sftp exit status should be "-1" 
  
  Scenario: Test business sample load validation failure 
    Given clean sftp folders of all previous ingestions for "business" surveys 
    And the sftp exit status should be "-1" 
    When for the "business" survey move the "invalid" file to trigger ingestion 
    And after a delay of 15 seconds 
    Then for the "business" survey confirm processed file "business-survey-invalid*.error" is found 
    And the sftp exit status should be "-1" 
    Then for the "business" survey get the contents of the file "business-survey-invalid*error.txt" 
    And the sftp exit status should be "-1" 
    And the contents should contain "org.springframework.integration.xml.AggregatedXmlMessageValidationException: Multiple causes:" 
    And the contents should contain "cvc-complex-type.2.4.a: Invalid content was found starting with element 'sampleUnitType'. One of '{formType, line1}' is expected." 
    And the contents should contain "cvc-enumeration-valid: Value 'Invalid' is not facet-valid with respect to enumeration '[H, HI, C, CI, B, BI]'. It must be a value from the enumeration." 
    And the contents should contain "cvc-type.3.1.3: The value 'Invalid' of element 'sampleUnitType' is not valid." 
  
  Scenario: Test census sample load
    Given clean sftp folders of all previous ingestions for "census" surveys 
    And the sftp exit status should be "-1" 
    When for the "census" survey move the "valid" file to trigger ingestion 
    And the sftp exit status should be "-1" 
    And after a delay of 50 seconds 
    Then for the "census" survey confirm processed file "census-survey-full*.xml.processed" is found 
    And the sftp exit status should be "-1" 
  
  Scenario: Test census sample load validation failure
    Given clean sftp folders of all previous ingestions for "census" surveys 
    And the sftp exit status should be "-1" 
    When for the "census" survey move the "invalid" file to trigger ingestion 
    And after a delay of 15 seconds 
    Then for the "census" survey confirm processed file "census-survey-invalid*.error" is found 
    And the sftp exit status should be "-1" 
    Then for the "census" survey get the contents of the file "census-survey-invalid*error.txt" 
    And the sftp exit status should be "-1" 
    And the contents should contain "org.springframework.integration.xml.AggregatedXmlMessageValidationException: Multiple causes:" 
    And the contents should contain "cvc-complex-type.2.4.a: Invalid content was found starting with element 'sampleUnitType'. One of '{formType, line1}' is expected." 
    And the contents should contain "cvc-enumeration-valid: Value 'Invalid' is not facet-valid with respect to enumeration '[H, HI, C, CI, B, BI]'. It must be a value from the enumeration." 
    And the contents should contain "cvc-type.3.1.3: The value 'Invalid' of element 'sampleUnitType' is not valid." 

  Scenario: Test social sample load
    Given clean sftp folders of all previous ingestions for "social" surveys 
    And the sftp exit status should be "-1" 
    When for the "social" survey move the "valid" file to trigger ingestion 
    And the sftp exit status should be "-1" 
    And after a delay of 50 seconds 
    Then for the "social" survey confirm processed file "social-survey-full*.xml.processed" is found 
    And the sftp exit status should be "-1" 

  Scenario: Test social sample load validation failure
    Given clean sftp folders of all previous ingestions for "social" surveys 
    And the sftp exit status should be "-1" 
    When for the "social" survey move the "invalid" file to trigger ingestion 
    And after a delay of 15 seconds 
    Then for the "social" survey confirm processed file "social-survey-invalid*.error" is found 
    And the sftp exit status should be "-1" 
    Then for the "social" survey get the contents of the file "social-survey-invalid*error.txt" 
    And the sftp exit status should be "-1" 
    And the contents should contain "org.springframework.integration.xml.AggregatedXmlMessageValidationException: Multiple causes:" 
    And the contents should contain "cvc-complex-type.2.4.a: Invalid content was found starting with element 'sampleUnitType'. One of '{formType, line1}' is expected." 
    And the contents should contain "cvc-enumeration-valid: Value 'Invalid' is not facet-valid with respect to enumeration '[H, HI, C, CI, B, BI]'. It must be a value from the enumeration." 
    And the contents should contain "cvc-type.3.1.3: The value 'Invalid' of element 'sampleUnitType' is not valid." 


  # Collection Exercise Smoke Tests -----

  Scenario: Put request to collection exercise service for specific business survey by exercise id 2.1, 2.2
    Given I make the PUT call to the collection exercise endpoint for exercise id "14fb3e68-4dca-46db-bf49-04b84e07e77c"
    When the response status should be 200
    Then the response should contain the field "sampleUnitsTotal" with an integer value of 500

  Scenario: Put request to collection exercise service for specific census survey by exercise id 2.1, 2.2
    Given I make the PUT call to the collection exercise endpoint for exercise id "14fb3e68-4dca-46db-bf49-04b84e07e87c"
    When the response status should be 200
    Then the response should contain the field "sampleUnitsTotal" with an integer value of 1

  Scenario: Put request to collection exercise service for specific social survey by exercise id 2.1, 2.2
    Given I make the PUT call to the collection exercise endpoint for exercise id "14fb3e68-4dca-46db-bf49-04b84e07e97c"
    When the response status should be 200
    Then the response should contain the field "sampleUnitsTotal" with an integer value of 1


  # Case Service Smoke Tests -----

  Scenario: Test casesvc case DB state (Journey steps: 2.3)
    Given after a delay of 210 seconds
    When check "casesvc.case" records in DB equal 500 for "state = 'ACTIONABLE'"
    Then check "casesvc.case" distinct records in DB equal 500 for "iac" where "state = 'ACTIONABLE'"


  # Action Service Smoke Tests -----

  Scenario: Test actionsvc case DB state for actionplan 1 (Journey steps: 2.4)
    Given after a delay of 60 seconds
    When check "action.case" records in DB equal 500 for "actionplanfk = 1"

  Scenario: Test action creation by post request to create jobs for specified action plan (Journey steps: 2.5)
    Given the case start date is adjusted to trigger action plan
      | actionplanfk  | actionrulepk | actiontypefk | total |
      | 1             | 1            | 1            | 500   |
    When after a delay of 90 seconds
    Then check "action.action" records in DB equal 500 for "statefk = 'COMPLETED'"
    When check "casesvc.caseevent" records in DB equal 500 for "description = 'Enrolment Invitation Letter'"
