# Author: Edward Stevens 29/06/2017
#
# Keywords Summary : This feature file contains the scenario tests for the action exporter template endpoints - details are in the swagger spec
#										 https://github.com/ONSdigital/response-management-service/blob/master/actionexportersvc/swagger.yml (old project) TODO copy to current project
#										 Note: Assuption DB has been preloaded with template data, samples have been created and actions run
#
# Feature: List of action scenarios:  Clean DB to pre test condition
#                                     Get all templates
#                                     Get the template information for the specified template name
#                                     Post request to actionexporter to store a specific template
#
# Feature Tag:  @actionExporter
#               @actionExporterTemplate
#
@actionExporter @actionExporterTemplate
Feature: action exporter template end points

	Scenario: Reset actionexporter database to pre test condition
		When for the "actionexporter" run the "actionexporterreset.sql" postgres DB script
		Then the actionexporter database has been reset


  # Endpoint Tests -----

  # GET /templates
  # 200
	Scenario: Get all templates
		Given I make the GET call to the actionexporter template endpoint for all templates
		When the response status should be 200
		Then the response should contain a JSON array of size 1
		And one element of the JSON array must be {"name":"initialPrint"
    And one element of the JSON array must be ,"dateModified":
    And one element of the JSON array must be ,"content":"<#list actionRequests as actionRequest>
    And one element of the JSON array must be ${(actionRequest.address.sampleUnitRef?trim)!}:${actionRequest.iac?trim}:${(actionRequest.contact.forename?trim)!\"null\"}:${(actionRequest.contact.emailAddress)!
    And one element of the JSON array must be <\/#list>"

  # 204 Not tested as templates pre loaded


  # GET /templates/{templateName}
  # 200
	Scenario: Get the template information for the specified template name
		Given I make the GET call to the actionexporter template endpoint for the template name "initialPrint"
		When the response status should be 200
		Then the response should contain the field "name"
		And the response should contain the field "content"
		And the response should contain the field "dateModified"

  # 404
  Scenario: Get the template information for the specified template name
    Given I make the GET call to the actionexporter template endpoint for the template name "invalidName"
    When the response status should be 404
    Then the response should contain the field "error.code" with value "RESOURCE_NOT_FOUND"
    And the response should contain the field "error.message" with value "Template not found for name invalidName"
    And the response should contain the field "error.timestamp"


  # POST /templates/{templateName}
  # 201
  Scenario: Post request to actionexporter to store a specific template
    Given I make the POST call to the actionexporter template endpoint for template with specific name "action_exporter_template_test"
    When  the response status should be 201
    Then the response should contain the field "name" with value "action_exporter_template_test"
    And the response should contain the field "content"
    And the response should contain the field "dateModified"

  # TODO Add test for invalid input 400
