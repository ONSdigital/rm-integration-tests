# Author: Stephen Goddard 25/05/2017
#
# Keywords Summary: This feature is a smoke test that confirms basic system checks
#
# Feature: List of smoke test scenarios: pre test clean of sample service
#                                        pre test clean of collection exercise service
#                                        pre test clean of case service
#                                        pre test clean of action service
#                                        pre test clean of action exporter
#                                        test business sample load
#                                        test business sample load validation failure
#                                        test census sample load
#                                        test census sample load validation failure
#                                        test social sample load
#                                        test social sample load validation failure
#                                        test business execution of collection exercise
#                                        test census execution of collection exercise
#                                        test social execution of collection exercise
#                                        test case service case generation
#                                        test action service case and action generation with case event
#                                        test action exporter print file generation
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

  Scenario: Reset actionexporter database to pre test condition
    When for the "actionexporter" run the "actionexporterreset.sql" postgres DB script
    Then the actionexporter database has been reset

  Scenario: Clean old print files from directory
    Given create test directory "previousTests" for "BSD"
    And the sftp exit status should be "-1"
    When move print files to "previousTests/" for "BSD"
    Then the sftp exit status should be "-1"


  # Sample Service Smoke Tests -----

  Scenario: Test business sample load
    Given clean sftp folders of all previous ingestions for "BSD" surveys 
    And the sftp exit status should be "-1" 
    When for the "BSD" survey move the "valid" file to trigger ingestion 
    And the sftp exit status should be "-1" 
    And after a delay of 70 seconds 
    Then for the "BSD" survey confirm processed file "BSD-survey-full*.xml.processed" is found 
    And the sftp exit status should be "-1" 
  
  Scenario: Test business sample load validation failure 
    Given clean sftp folders of all previous ingestions for "BSD" surveys 
    And the sftp exit status should be "-1" 
    When for the "BSD" survey move the "invalid" file to trigger ingestion 
    And after a delay of 25 seconds 
    Then for the "BSD" survey confirm processed file "BSD-survey-invalid*.error" is found 
    And the sftp exit status should be "-1" 
    Then for the "BSD" survey get the contents of the file "BSD-survey-invalid*error.txt" 
    And the sftp exit status should be "-1" 
    And the contents should contain "org.springframework.integration.xml.AggregatedXmlMessageValidationException: Multiple causes:" 
    And the contents should contain "cvc-complex-type.2.4.a: Invalid content was found starting with element 'sampleUnitType'. One of '{formType}' is expected." 
    And the contents should contain "cvc-enumeration-valid: Value 'Invalid' is not facet-valid with respect to enumeration '[H, HI, C, CI, B, BI]'. It must be a value from the enumeration." 
    And the contents should contain "cvc-type.3.1.3: The value 'Invalid' of element 'sampleUnitType' is not valid." 
  
  Scenario: Test census sample load
    Given clean sftp folders of all previous ingestions for "CTP" surveys 
    And the sftp exit status should be "-1" 
    When for the "CTP" survey move the "valid" file to trigger ingestion 
    And the sftp exit status should be "-1" 
    And after a delay of 50 seconds 
    Then for the "CTP" survey confirm processed file "CTP-survey-full*.xml.processed" is found 
    And the sftp exit status should be "-1" 
  
  Scenario: Test census sample load validation failure
    Given clean sftp folders of all previous ingestions for "CTP" surveys 
    And the sftp exit status should be "-1" 
    When for the "CTP" survey move the "invalid" file to trigger ingestion 
    And after a delay of 25 seconds 
    Then for the "CTP" survey confirm processed file "CTP-survey-invalid*.error" is found 
    And the sftp exit status should be "-1" 
    Then for the "CTP" survey get the contents of the file "CTP-survey-invalid*error.txt" 
    And the sftp exit status should be "-1" 
    And the contents should contain "org.springframework.integration.xml.AggregatedXmlMessageValidationException: Multiple causes:" 
    And the contents should contain "cvc-complex-type.2.4.a: Invalid content was found starting with element 'sampleUnitType'. One of '{formType}' is expected." 
    And the contents should contain "cvc-enumeration-valid: Value 'Invalid' is not facet-valid with respect to enumeration '[H, HI, C, CI, B, BI]'. It must be a value from the enumeration." 
    And the contents should contain "cvc-type.3.1.3: The value 'Invalid' of element 'sampleUnitType' is not valid." 

  Scenario: Test social sample load
    Given clean sftp folders of all previous ingestions for "SSD" surveys 
    And the sftp exit status should be "-1" 
    When for the "SSD" survey move the "valid" file to trigger ingestion 
    And the sftp exit status should be "-1" 
    And after a delay of 50 seconds 
    Then for the "SSD" survey confirm processed file "SSD-survey-full*.xml.processed" is found 
    And the sftp exit status should be "-1" 

  Scenario: Test social sample load validation failure
    Given clean sftp folders of all previous ingestions for "SSD" surveys 
    And the sftp exit status should be "-1" 
    When for the "SSD" survey move the "invalid" file to trigger ingestion 
    And after a delay of 25 seconds 
    Then for the "SSD" survey confirm processed file "SSD-survey-invalid*.error" is found 
    And the sftp exit status should be "-1" 
    Then for the "SSD" survey get the contents of the file "SSD-survey-invalid*error.txt" 
    And the sftp exit status should be "-1" 
    And the contents should contain "org.springframework.integration.xml.AggregatedXmlMessageValidationException: Multiple causes:" 
    And the contents should contain "cvc-complex-type.2.4.a: Invalid content was found starting with element 'sampleUnitType'. One of '{formType}' is expected." 
    And the contents should contain "cvc-enumeration-valid: Value 'Invalid' is not facet-valid with respect to enumeration '[H, HI, C, CI, B, BI]'. It must be a value from the enumeration." 
    And the contents should contain "cvc-type.3.1.3: The value 'Invalid' of element 'sampleUnitType' is not valid." 


  # Collection Exercise Smoke Tests -----

  Scenario: Put request to collection exercise service for specific business survey by exercise id
    Given I make the PUT call to the collection exercise endpoint for exercise id "14fb3e68-4dca-46db-bf49-04b84e07e77c"
    When the response status should be 200
    Then the response should contain the field "sampleUnitsTotal" with an integer value of 500

  Scenario: Put request to collection exercise service for specific census survey by exercise id
    Given I make the PUT call to the collection exercise endpoint for exercise id "14fb3e68-4dca-46db-bf49-04b84e07e87c"
    When the response status should be 200
    # 0 returned as seed data/party svc does not work for Census
    Then the response should contain the field "sampleUnitsTotal" with an integer value of 0

  Scenario: Put request to collection exercise service for specific social survey by exercise id
    Given I make the PUT call to the collection exercise endpoint for exercise id "14fb3e68-4dca-46db-bf49-04b84e07e97c"
    When the response status should be 200
    # 0 returned as seed data/party svc does not work for Social
    Then the response should contain the field "sampleUnitsTotal" with an integer value of 0


  # Case Service Smoke Tests -----

  Scenario: Test casesvc case DB state
    Given after a delay of 280 seconds
    When check "casesvc.case" records in DB equal 500 for "statefk = 'ACTIONABLE'"
    Then check "casesvc.case" distinct records in DB equal 500 for "iac" where "statefk = 'ACTIONABLE'"


  # Action Service Smoke Tests -----

  Scenario: Test actionsvc case DB state for actionplan 1
    Given after a delay of 60 seconds
    When check "action.case" records in DB equal 500 for "actionplanfk = 1"

  Scenario: Test action creation by post request to create jobs for specified action plan
    Given the case start date is adjusted to trigger action plan
      | actionplanfk  | actionrulepk | actiontypefk | total |
      | 1             | 1            | 1            | 500   |
    When after a delay of 90 seconds
    Then check "action.action" records in DB equal 500 for "statefk = 'COMPLETED'"
    When check "casesvc.caseevent" records in DB equal 500 for "description = 'Enrolment Invitation Letter'"


  # Action Exporter Service Smoke Tests -----

  Scenario: Test print file generation and confirm contents
    Given after a delay of 90 seconds
    When get the contents of the print files where the filename begins "BSNOT" for "BSD"
    And the sftp exit status should be "-1"
    Then each line should contain an iac
    And the contents should contain ":null:null"
    And the contents should contain 500 lines
