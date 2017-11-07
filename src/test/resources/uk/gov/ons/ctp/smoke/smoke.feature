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
 
  Scenario: Test business csv sample load
    When I make the POST call to the sample "bres" service endpoint for the "BSD" survey "valid" file to trigger ingestion
    When the response status should be 201
    Then the response should contain the field "sampleSummaryPK" with an integer value of 1
    And after a delay of 320 seconds
    

  Scenario: Test business sample load validation failure 
    When I make the POST call to the sample "bres" service endpoint for the "BSD" survey "invalid" file to trigger ingestion
    When the response status should be 400
    Then the response should contain the field "error"
    And after a delay of 30 seconds

  # Test fails until defect CTPA-1691 is resolved
#  Scenario: Test census sample load
#    When I make the POST call to the sample "census" service endpoint for the "CTP" survey "valid" file to trigger ingestion
  #  When the response status should be 201
  #  Then the response should contain the field "sampleSummaryPK" with an integer value of 2
  #  Then the response should contain the field "state" with value "INIT"
  #  And after a delay of 55 seconds
    
  # Test fails until defect CTPA-1691 is resolved
#  Scenario: Test census sample load validation failure
#    When I make the POST call to the sample "census" service endpoint for the "CTP" survey "invalid" file to trigger ingestion
  #  When the response status should be 400
  #  Then the response should contain the field "error"
  #  And after a delay of 30 seconds
    
  # Test fails until defect CTPA-1691 is resolved
  #Scenario: Test social sample load
  #  When I make the POST call to the sample "social" service endpoint for the "SSD" survey "valid" file to trigger ingestion
  #  When the response status should be 201
  #  Then the response should contain the field "sampleSummaryPK" with an integer value of 3
  #  Then the response should contain the field "state" with value "INIT"
  #  And after a delay of 55 seconds
    
  # Test fails until defect CTPA-1691 is resolved
  #Scenario: Test social sample load validation failure
    #When I make the POST call to the sample "social" service endpoint for the "SSD" survey "invalid" file to trigger ingestion
    #When the response status should be 400
    #Then the response should contain the field "error"
    #And after a delay of 30 seconds

  # Collection Exercise Smoke Tests -----
  
  # to be replaced by UI 

  Scenario: Put repuest to sample service service links the sample summary to a collection exercise
    And after a delay of 30 seconds
    Given I retrieve From Sample DB the Sample Summary
    Given I make the PUT call to the collection exercise for id "14fb3e68-4dca-46db-bf49-04b84e07e77c" endpoint for sample summary id
    And after a delay of 30 seconds

  Scenario: Put request to collection exercise service for specific business survey by exercise id
    Given I make the PUT call to the collection exercise endpoint for exercise id "14fb3e68-4dca-46db-bf49-04b84e07e77c"
    When the response status should be 200
    Then the response should contain the field "sampleUnitsTotal" with an integer value of 500

# Test fails until defect CTPA-1691 is resolved
  #Scenario: Put request to collection exercise service for specific census survey by exercise id
  #  Given I make the PUT call to the collection exercise endpoint for exercise id "14fb3e68-4dca-46db-bf49-04b84e07e87c"
  #  When the response status should be 200
    # 0 returned as seed data/party svc does not work for Census
  #  Then the response should contain the field "sampleUnitsTotal" with an integer value of 0

# Test fails until defect CTPA-1691 is resolved
  #Scenario: Put request to collection exercise service for specific social survey by exercise id
  #  Given I make the PUT call to the collection exercise endpoint for exercise id "14fb3e68-4dca-46db-bf49-04b84e07e97c"
  #  When the response status should be 200
    # 0 returned as seed data/party svc does not work for Social
  #  Then the response should contain the field "sampleUnitsTotal" with an integer value of 0


  # Case Service Smoke Tests -----

  Scenario: Test casesvc case DB state
    Given after a delay of 400 seconds
    When check "casesvc.case" records in DB equal 500 for "statefk = 'ACTIONABLE'"
    Then check "casesvc.case" distinct records in DB equal 500 for "iac" where "statefk = 'ACTIONABLE'"

  Scenario: Test action creation by post request to create jobs for specified action plan
    Given the case start date is adjusted to trigger action plan
      | actionplanfk  | actionrulepk | actiontypefk | total |
      | 1             | 1            | 1            | 497   |
    Given after a delay of 60 seconds
    Then check "action.action" records in DB equal 497 for "statefk = 'COMPLETED'"
    When check "casesvc.caseevent" records in DB equal 497 for "description = 'Enrolment Invitation Letter'"

  # Action Service Smoke Tests -----

  Scenario: Test actionsvc case DB state for actionplan 1
    When after a delay of 90 seconds
    When check "action.case" records in DB equal 497 for "actionplanfk = 1"
    When check "action.case" records in DB equal 3 for "actionplanfk = 2"

  # Action Exporter Service Smoke Tests -----

  Scenario: Test print file generation and confirm contents
    Given after a delay of 90 seconds
    When get the contents of the print files where the filename begins "BSNOT" for "BSD"
    And the sftp exit status should be "-1"
    Then each line should contain an iac
    And the contents should contain ":null:null"
    And the contents should contain 497 lines
