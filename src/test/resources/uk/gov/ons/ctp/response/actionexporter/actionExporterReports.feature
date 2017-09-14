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
@actionExporter2 @actionExporterReport
Feature: action exporter template end points


  # Endpoint Tests -----

  # GET /reports/types
  # 200
  Scenario: Get all report types
    Given I make the GET call to the actionexporter reports endpoint for all types
    When the response status should be 200

  # 204 not tested as preloaded


  # GET /reports/types/{reportTypes}
  # 200
  Scenario: Get report type specified
    Given I make the GET call to the actionexporter reports endpoint for type "PRINT_VOLUMES"
    When the response status should be 200

  # 204 reports run before test so not tested

  # 404
  Scenario: Get report type not found
    Given I make the GET call to the actionexporter reports endpoint for type "NOT_FOUND"
    When the response status should be 200
    

  # GET /reports/{reportId}
  # 200
  Scenario: Get report by specified id
    Given I make the GET call to the actionexporter reports endpoint for id
    When the response status should be 200

  # 404
  Scenario: Get report by specified id not found
    Given I make the GET call to the actionexporter reports endpoint for id "e71012ac-3575-47eb-b87f-cd9db92bf9a7"
    When the response status should be 200
