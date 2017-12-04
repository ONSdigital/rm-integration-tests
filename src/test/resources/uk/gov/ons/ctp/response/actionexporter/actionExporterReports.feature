# Author: Stephen Goddard 11/09/2017
#
# Keywords Summary : This feature file contains the scenario tests for the action exporter template endpoints - details are in the swagger spec
#                    https://github.com/ONSdigital/rm-actionexporter-service/blob/master/API.md
#
# Feature: List of action scenarios:  Clean DB to pre test condition
#                                     Get all templates
#                                     Get the template information for the specified template name
#                                     Post request to actionexporter to store a specific template
#
# Feature Tag:  @actionExporter
#               @@actionExporterReport
#
@actionExporter @actionExporterReport
Feature: action exporter report end points

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
    
  Scenario: Seed action service database to pre test condition
    When for the "actionsvc" run the "actionseed.sql" postgres DB script
    Then the actionsvc database has been seeded

  Scenario: Reset actionexporter database to pre test condition
    When for the "actionexporter" run the "actionexporterreset.sql" postgres DB script
    Then the actionexporter database has been reset

  Scenario: Clean old print files from directory
    Given create test directory "previousTests" for "BSD"
    And the sftp exit status should be "-1"
    When move print files to "previousTests/" for "BSD"
    Then the sftp exit status should be "-1"


  # Sample Service Set Up -----

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
    
  Scenario: Put request to collection exercise service for specific business survey by exercise id
    Given I make the PUT call to the collection exercise endpoint for exercise id "14fb3e68-4dca-46db-bf49-04b84e07e77c"
    When the response status should be 200
    Then the response should contain the field "sampleUnitsTotal" with an integer value of 500


  # Case Service Set Up -----

  Scenario: Test casesvc case DB state
    Given after a delay of 390 seconds
    When check "casesvc.case" records in DB equal 500 for "statefk = 'ACTIONABLE'"
    Then check "casesvc.case" distinct records in DB equal 500 for "iac" where "statefk = 'ACTIONABLE'"


  # Action Service Set Up -----

  Scenario: Test actionsvc case DB state for actionplan 1
    Given after a delay of 60 seconds
    When check "action.case" records in DB equal 497 for "actionplanfk = 1"
    When check "action.case" records in DB equal 3 for "actionplanfk = 2"

  Scenario: Test action creation by post request to create jobs for specified action plan
    Given the case start date is adjusted to trigger action plan
      | actionplanfk  | actionrulepk | actiontypefk | total |
      | 1             | 1            | 1            | 497   |
    When after a delay of 90 seconds
    # Note now we are passed the trigger point for action the case auto trigger 500 letters + 497 test created
    Then check "action.action" records in DB equal 997 for "statefk = 'COMPLETED'"
    When check "casesvc.caseevent" records in DB equal 497 for "description = 'Enrolment Invitation Letter'"


  # Action Exporter Service Set Up -----

  Scenario: Test print file generation and confirm contents
    Given after a delay of 90 seconds
    When get the contents of the print files where the filename begins "BSNOT" for "BSD"
    And the sftp exit status should be "-1"
    Then each line should contain an iac
    And the contents should contain ":null:null"
    And the contents should contain 497 lines


  # Endpoint Tests -----

  # GET /reports/types
  # 200
  Scenario: Get all report types
    Given I make the GET call to the actionexporter reports endpoint for all types
    And the response status should be 200
    When the response should contain a JSON array of size 1
    Then one element of the JSON array must be {"reportType":"PRINT_VOLUMES","displayOrder":10,"displayName":"Print Volumes"}

  # 204 not tested as preloaded


  # GET /reports/types/{reportTypes}
  # 200
  Scenario: Get report type specified
    Given I make the GET call to the actionexporter reports endpoint for type "PRINT_VOLUMES"
    When the response status should be 200
    # Array size not tested as it can vary on different runs
    Then one element of the JSON array must be {"id":
    And one element of the JSON array must be ,"reportType":"PRINT_VOLUMES","createdDateTime":

  # 204 reports run before test so not tested

  # 404
  Scenario: Get report type not found
    Given I make the GET call to the actionexporter reports endpoint for type "NOT_FOUND"
    When the response status should be 404
    

  # GET /reports/{reportId}
  # 200
  Scenario: Get report by specified id
    Given I make the GET call to the actionexporter reports endpoint for id
    When the response status should be 200
    Then the response should contain the field "id"
    And the response should contain the field "reportType" with value "PRINT_VOLUMES"

  # 404
  Scenario: Get report by specified id not found
    Given I make the GET call to the actionexporter reports endpoint for id "e71012ac-3575-47eb-b87f-cd9db92bf9a7"
    When the response status should be 404
