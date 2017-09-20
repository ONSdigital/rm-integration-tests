# Author: Edward Stevens 11/07/2017
#
# Keywords Summary : This feature file contains the scenario tests for the action exporter template mapping endpoints - details are in the swagger spec
#										 https://github.com/ONSdigital/rm-actionexporter-service/blob/master/API.md
#										 Note: Assuption DB has been preloaded with template data, samples have been created and actions run
#
# Feature: List of action scenarios:  Reset actionexporter database to pre test condition
#                                     Get all template mappings
#                                     Get the template mapping information for the specified action type
#                                     Post request to actionexporter to store a specific template mapping
#
# Feature Tag:  @actionExporter
#               @actionExporterTemplateMapping
#
@actionExporter @actionExporterTemplateMapping
Feature: action exporter template mappings end points

	Scenario: Reset actionexporter database to pre test condition
		When for the "actionexporter" run the "actionexporterreset.sql" postgres DB script
		Then the actionexporter database has been reset


  # Endpoint Tests -----

  # GET /templatemappings
  # 200
	Scenario: Get all template mappings
		Given I make the GET call to the actionexporter template mapping endpoint for all template mappings
		Then the response status should be 200
		And the response should contain a JSON array of size 2
		And one element of the JSON array must be "actionType":"BSNOT",
    And one element of the JSON array must be "template":"initialPrint",
		And one element of the JSON array must be "fileNamePrefix":"BSNOT",
		And one element of the JSON array must be "dateModified":

  # 204 Not tested as templates pre loaded


  # GET /templatemappings/{actiontype}
  # 200
	Scenario: Get the template mapping information for the specified action type
		Given I make the GET call to the actionexporter template mapping endpoint for the action type "BSNOT"
		When the response status should be 200
		Then the response should contain the field "actionType" with value "BSNOT"
		And the response should contain the field "template" with value "initialPrint"
		And the response should contain the field "fileNamePrefix" with value "BSNOT"
    And the response should contain the field "dateModified"

  # 404
  Scenario: Get the template mapping information for the specified action type
    Given I make the GET call to the actionexporter template mapping endpoint for the action type "ACTION_TYPE"
    When the response status should be 404
    Then the response should contain the field "error.code" with value "RESOURCE_NOT_FOUND"
    And the response should contain the field "error.message" with value "TemplateMapping not found. ACTION_TYPE"
    And the response should contain the field "error.timestamp"


  # POST /templatemappings/{actionType}
  # 201
  Scenario: Post request to actionexporter to store a specific template mapping
    Given I make the POST call to the actionexporter template mapping endpoint
      | initialPrint | cucumberTestPrefix |
    When  the response status should be 201
    Then the response should contain a JSON array of size 1
    And one element of the JSON array must be {"actionType":"TEST","template":"initialPrint","fileNamePrefix":"cucumberTestPrefix","dateModified":

  # 400
  Scenario: Post request to actionexporter to store a specific template mapping invalid input
    Given I make the POST call to the actionexporter template mapping endpoint for invalid input
    When  the response status should be 400
    Then the response should contain the field "error.code" with value "VALIDATION_FAILED"
    And the response should contain the field "error.message" with value "Provided json is incorrect."
    And the response should contain the field "error.timestamp"
