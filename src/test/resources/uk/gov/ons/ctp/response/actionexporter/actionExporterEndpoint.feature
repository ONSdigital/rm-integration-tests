# Author: Chris Hardman 10/02/2017
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

  Scenario: Clean DB to pre test condition
    When reset the postgres DB
    Then check "casesvc.case" records in DB equal 0
    And check "casesvc.caseevent" records in DB equal 0
		And check "casesvc.casegroup" records in DB equal 0
		And check "casesvc.contact" records in DB equal 0
		And check "casesvc.response" records in DB equal 0
    And check "casesvc.messagelog" records in DB equal 0
    And check "casesvc.unlinkedcasereceipt" records in DB equal 0
    And check "action.action" records in DB equal 0
    And check "action.actionplanjob" records in DB equal 0
    And check "action.case" records in DB equal 0
    And check "action.messagelog" records in DB equal 0
    And check "casesvc.caseeventidseq" sequence in DB equal 1
    And check "casesvc.caseidseq" sequence in DB equal 1
    And check "casesvc.casegroupidseq" sequence in DB equal 1
    And check "casesvc.caserefseq" sequence in DB equal 1000000000000001
    And check "casesvc.responseidseq" sequence in DB equal 1
    And check "casesvc.messageseq" sequence in DB equal 1
    And check "action.actionidseq" sequence in DB equal 1
    And check "action.actionplanjobseq" sequence in DB equal 1
    And check "action.messageseq" sequence in DB equal 1

	Scenario: Get the action requests information for the specified action id
		Given after a delay of 30 seconds
		When I make the GET call to the actionexporter endpoint for the action id "1835"
		Then the response status should be 200
		And the response should contain the field "actionId"
		And the response should contain the field "responseRequired"
		And the response should contain the field "actionPlan"
		And the response should contain the field "actionType"
		And the response should contain the field "questionSet"
		And the response should contain the field "contact" with contents "null"
		And the response should contain the field "address"
		And the response should contain the field "caseId"
		And the response should contain the field "priority"
		And the response should contain the field "caseRef"
		And the response should contain the field "iac"
		And the response should contain the field "events" with contents "null"
		And the response should contain the field "dateStored"
		And the response should contain the field "dateSent"
