# Author: Edward Stevens 11/07/2017
#
# Keywords Summary : This feature file contains the scenario tests for the action exporter template mapping endpoints - details are in the swagger spec
#										 https://github.com/ONSdigital/response-management-service/blob/master/actionexportersvc/swagger.yml
#										 Note: Assuption DB has been preloaded with template data, samples have been created and actions run
#
# Feature: List of action scenarios:  Reset actionexporter database to pre test condition
#                                     Get all template mappings
#                                     Get the template mapping information for the specified action type
#                                     Post request to actionexporter to store a specific template mapping
#
# Feature Tag:  @actionexporter
#               @actionExporterTemplateMapping

@actionExporter @actionExporterTemplate
Feature: action exporter template end points

	Scenario: Reset actionexporter database to pre test condition
		When for the "actionexporter" run the "actionexporterreset.sql" postgres DB script
		Then the actionexporter database has been reset

	Scenario: Get all template mappings
		Given after a delay of 30 seconds
		When I make the GET call to the actionexporter template mappings endpoint for all template mappings
		Then the response status should be 200
		And the response should contain a JSON array of size 2
		And one element of the JSON array must be "actionType":"BRESEL",
        And one element of the JSON array must be "template":"initialPrint",
		And one element of the JSON array must be "file":"BRESEL",
		And one element of the JSON array must be "dateModified":1499696370711

	Scenario: Get the template mapping information for the specified action type
		Given after a delay of 30 seconds
		When I make the GET call to the actionexporter template mappings endpoint for the action type "BRESEL"
		Then the response status should be 200
		And the response should contain the field "actionType"
		And the response should contain the field "template"
		And the response should contain the field "file"
        And the response should contain the field "dateModified"

   # POST /templates/{templateName}
   # 201
    Scenario: Post request to actionexporter to store a specific template mapping
        When I make the POST call to the actionexporter template mappings endpoint
          | CucumberTest |
        Then  the response status should be 201