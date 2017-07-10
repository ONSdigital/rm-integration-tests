# Author: Edward Stevens 29/06/2017
#
# Keywords Summary : This feature file contains the scenario tests for the action exporter endpoints - details are in the swagger spec
#										 https://github.com/ONSdigital/response-management-service/blob/master/actionexportersvc/swagger.yml
#										 Note: Assuption DB has been preloaded with template data, samples have been created and actions run
#
# Feature: List of action scenarios:  Clean DB to pre test condition
#                                     Get all templates
#                                     Get the template information for the specified template name
#                                     Post request to actionexporter to store a specific template
#
# Feature Tag:  @actionexporter
#               @actionExporterTemplate

@actionExporter @actionExporterTemplate
Feature: action exporter template end points

	Scenario: Reset actionexporter database to pre test condition
		When for the "actionexporter" run the "actionexporterreset.sql" postgres DB script
		Then the actionexporter database has been reset

	Scenario: Get all templates
		Given after a delay of 30 seconds
		When I make the GET call to the actionexporter template endpoint for all templates
		Then the response status should be 200
		And the response should contain a JSON array of size 2
		And one element of the JSON array must be {"name":"initialPrint"
        And one element of the JSON array must be ,"dateModified":
		And one element of the JSON array must be ,"content":"<#list actionRequests as actionRequest>\n  ${(actionRequest.address.sampleUnitRef)!}|${actionRequest.iac?trim}|${(actionRequest.contact.forename?trim)!}|${(actionRequest.contact.emailaddress)!}\n  <\/#list>"

	Scenario: Get the template information for the specified template name
		Given after a delay of 30 seconds
		When I make the GET call to the actionexporter template endpoint for the template name "initialPrint"
		Then the response status should be 200
		And the response should contain the field "name"
		And the response should contain the field "content"
		And the response should contain the field "dateModified"

   # POST /templates/{templateName}
   # 201
    Scenario: Post request to actionexporter to store a specific template
        When I make the POST call to the actionexporter template endpoint for template with specific name
          | action_exporter_template_test | CucumberTest |
        Then  the response status should be 201