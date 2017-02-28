# Author: Kieran Wardle 10/02/2017
#
# Keywords Summary: Test to see if the correct JSON array with the correct list of report content is returned by the Actionexporter report endpoint. - details are in the swagger spec
#										 https://github.com/ONSdigital/response-management-service/blob/master/actionexportersvc/swagger.yml
#
# Feature: List of scenarios: Clean DB to pre test condition
#						                  Actionexporter report content endpoint
#
# Feature Tag:  @actionexporter
#               @reportContentEndpointAE
#               @reportEndpoints
#               @AEReportsEndpoints
#               @reportContentEndpoint

@actionexporter @reportContentEndpointAE @reportEndpoints @AEReportsEndpoints @reportContentEndpoint
Feature: Test that the /reports/{reportId} endpoint returns the correct report content for actionexoprter reports

  Scenario: Clean DB to pre test condition
    When reset the postgres DB

  Scenario: actionexportersvcreport content endpoint
    Given after a delay of 60 seconds
    When I make the GET call to the actionexporter Report Content endpoint for the report of type "PRINT_VOLUMES"
    Then the response status should be 200
    And the response should contain the field "reportId"
    And the response should contain the field "createdDateTime"
    And the response should contain the field "reportType" with value "PRINT_VOLUMES"
    And the response should contain the field "contents" with contents "filename,rowcount,datesent"
