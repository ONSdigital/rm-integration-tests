# Author: Edward Stevens 29/06/2017
#
# Keywords Summary : This feature file contains the scenario tests for the action exporter endpoints - details are in the swagger spec
#										 https://github.com/ONSdigital/response-management-service/blob/master/actionexportersvc/swagger.yml
#										 Note: Assuption DB has been preloaded with action plan data, samples have been created and actions run
#
# Feature: List of action scenarios: Get the action requests information for the specified action id
#
# Feature Tag: @actionexporter

@actionexporter
Feature: action exporter end points

	Scenario: Reset actionexporter database to pre test condition
		When for the "actionexporter" run the "actionexporterreset.sql" postgres DB script
		Then the actionexporter database has been reset
        When for the "actionexporter" run the "actionexporterseed.sql" postgres DB script

	Scenario: Get the action requests information for all action requests
		Given after a delay of 30 seconds
		When I make the GET call to the actionexporter endpoint for all action requests
		Then the response status should be 200
		And the response should contain a JSON array of size 1
		And one element of the JSON array must be {"actionId":
		And one element of the JSON array must be ,"responseRequired":true,"actionPlan":"BRES","actionType":"BRESEL","questionSet":"QUESTONSET","caseId":"7bc5d41b-0549-40b3-ba76-42f6d4cf3fd1","caseRef":"CASEREF","iac":"IAC","dateStored":1492473600000,"dateSent":1492473600000}]

	Scenario: Get the action requests information for the specified action id
		Given after a delay of 30 seconds
		When I make the GET call to the actionexporter endpoint for the action id "7bc5d41b-0549-40b3-ba76-42f6d4cf3fd1"
		Then the response status should be 200
		And the response should contain the field "actionId"
		And the response should contain the field "responseRequired"
		And the response should contain the field "actionPlan"
		And the response should contain the field "actionType"
		And the response should contain the field "questionSet"
		And the response should contain the field "caseId"
		And the response should contain the field "caseRef"
		And the response should contain the field "iac"
		And the response should contain the field "dateStored"
		And the response should contain the field "dateSent"

   # POST /actionrequests/{actionId}
   # 201
    Scenario: Post request to actionrequest to export a specific ActionRequest
      When I make the POST call to the actionexporter actionrequests endpoint for actionrequest with specific id
        | 7bc5d41b-0549-40b3-ba76-42f6d4cf3fd1 | CucumberTest |
      Then the response status should be 201
      And the response should contain the field "actionId"
      And the response should contain the field "responseRequired"
      And the response should contain the field "actionPlan"
      And the response should contain the field "actionType"
      And the response should contain the field "questionSet"
      And the response should contain the field "caseId"
      And the response should contain the field "caseRef"
      And the response should contain the field "iac"
      And the response should contain the field "dateStored"
      And the response should contain the field "dateSent"
