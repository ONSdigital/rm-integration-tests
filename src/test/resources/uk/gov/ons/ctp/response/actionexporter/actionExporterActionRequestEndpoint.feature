# Author: Edward Stevens 29/06/2017
#
# Keywords Summary : This feature file contains the scenario tests for the action exporter endpoints - details are in the swagger spec
#										 https://github.com/ONSdigital/response-management-service/blob/master/actionexportersvc/swagger.yml (old project) TODO copy to current project
#										 Note: Assuption DB has been preloaded with action plan data, samples have been created and actions run
#
# Feature: List of action scenarios: Get the action requests information for the specified action id
#
# Feature Tag: @actionExporter
#
# REMOVE AS NO LONGER AS ENDPOINTS HAVE BEEN REMOVED
#
@actionExporterREMOVE @actionExporterEndpoints
Feature: action exporter end points

	Scenario: Reset actionexporter database to pre test condition
		When for the "actionexporter" run the "actionexporterreset.sql" postgres DB script
		Then the actionexporter database has been reset
    And for the "actionexporter" run the "actionexporterseed.sql" postgres DB script


  # Endpoint Tests -----

  # GET /actionrequests
  # 200
	Scenario: Get the action requests information for all action requests
		Given I make the GET call to the actionexporter endpoint for all action requests
		When the response status should be 200
		Then the response should contain a JSON array of size 1
		And one element of the JSON array must be {"actionId":
		And one element of the JSON array must be ,"responseRequired":true,"actionPlan":"BRES","actionType":"BSNOT","questionSet":"QUESTONSET","caseId":"8bc5d41b-0549-40b3-ba76-42f6d4cf3fd1","caseRef":"CASEREF","iac":"IAC","dateStored":
    And one element of the JSON array must be ,"dateSent": 


  # GET /actionrequests/{actionid}
  # 200
	Scenario: Get the action requests information for the specified action id
		Given I make the GET call to the actionexporter endpoint for the action id "7bc5d41b-0549-40b3-ba76-42f6d4cf3fd1"
		When the response status should be 200
		Then the response should contain the field "actionId" with value "7bc5d41b-0549-40b3-ba76-42f6d4cf3fd1"
		And the response should contain the field "responseRequired" with boolean value "true"
		And the response should contain the field "actionPlan" with value "BRES"
		And the response should contain the field "actionType" with value "BSNOT"
		And the response should contain the field "questionSet" with value "QUESTONSET"
		And the response should contain the field "caseId" with value "8bc5d41b-0549-40b3-ba76-42f6d4cf3fd1"
		And the response should contain the field "caseRef" with value "CASEREF"
		And the response should contain the field "iac" with value "IAC"
		And the response should contain the field "dateStored"
		And the response should contain the field "dateSent"

  # 404
  Scenario: Get the action requests information for the specified action id
    Given I make the GET call to the actionexporter endpoint for the action id "7bc5d41b-1019-40b3-ba76-42f6d4cf3fd1"
    When the response status should be 404
    Then the response should contain the field "error.code" with value "RESOURCE_NOT_FOUND"
    And the response should contain the field "error.message" with value "ActionRequest not found for actionId 7bc5d41b-1019-40b3-ba76-42f6d4cf3fd1"
    And the response should contain the field "error.timestamp"


  # POST /actionrequests/{actionId}
  # 201
  Scenario: Post request to actionrequest to export a specific ActionRequest
    Given I make the POST call to the actionexporter actionrequests endpoint for actionrequest with specific id
      | 7bc5d41b-0549-40b3-ba76-42f6d4cf3fd1 | CucumberTest |
    When the response status should be 201
    Then the response should contain the field "actionId" with value "7bc5d41b-0549-40b3-ba76-42f6d4cf3fd1"
    And the response should contain the field "responseRequired" with boolean value "true"
    And the response should contain the field "actionPlan" with value "BRES"
    And the response should contain the field "actionType" with value "BSNOT"
    And the response should contain the field "questionSet" with value "QUESTONSET"
    And the response should contain the field "caseId" with value "8bc5d41b-0549-40b3-ba76-42f6d4cf3fd1"
    And the response should contain the field "caseRef" with value "CASEREF"
    And the response should contain the field "iac" with value "IAC"
    And the response should contain the field "dateStored"
    And the response should contain the field "dateSent"
    
  # INFO /info
  # 200
  @sampleEndpointsInfo
  Scenario: Info request to action service for current verison number
    Given I make the call to the actionexporter endpoint for info
    When the response status should be 200
    Then the response should contain the field "name" with value "actionexportersvc"

