# Author: Edward Stevens 11/07/2017
#
# Keywords Summary : This feature file contains the scenario tests for the action exporter template mapping endpoints - details are in the swagger spec
#										 https://github.com/ONSdigital/response-management-service/blob/master/actionexportersvc/swagger.yml (old project) TODO copy to current project
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
Feature: action exporter template end points

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
		And one element of the JSON array must be "actionType":"BRESEL",
        And one element of the JSON array must be "template":"initialPrint",
		And one element of the JSON array must be "file":"BRESEL",
		And one element of the JSON array must be "dateModified":

  # 204 Not tested as templates pre loaded


  # GET /templatemappings/{actiontype}
  # 200
	Scenario: Get the template mapping information for the specified action type
		Given I make the GET call to the actionexporter template mapping endpoint for the action type "BRESEL"
		When the response status should be 200
		Then the response should contain the field "actionType"
		And the response should contain the field "template"
		And the response should contain the field "file"
    And the response should contain the field "dateModified"

#  # 404 TODO Currently returns 500 for action type not found rather than 404
#  Scenario: Get the template mapping information for the specified action type
#    Given I make the GET call to the actionexporter template mapping endpoint for the action type "ACTION_TYPE"
#    Then the response status should be 404


  # POST /templatemappings
  # 201
  Scenario: Post request to actionexporter to store a specific template mapping
    When I make the POST call to the actionexporter template mapping endpoint
    Then  the response status should be 201

  # TODO Add test for invalid input 400