# Author: Kieran Wardle 10/02/2017
#
# Keywords Summary: Test to see if the correct JSON array with the correct list of reports is returned by the actionexportersvc report endpoint. - details are in the swagger spec
#										 https://github.com/ONSdigital/response-management-service/blob/master/actionexportersvc/swagger.yml
#
# Feature: List of scenarios: Clean DB to pre test condition
#						                  actionexportersvc report list endpoint
#
# Feature Tag:  @actionexporter
#               @reportListEndpointAE
#               @reportEndpoints
#               @AEReportsEndpoints
#               @reportListEndpoints

@actionexporter @reportListEndpointAE @reportEndpoints @AEReportsEndpoints @reportListEndpoints
Feature: Test that the /reports/types endpoint returns the correct list of reports for actionexportersvc report type Print Volumes

  Scenario: Clean DB to pre test condition
    When reset the postgres DB

  Scenario: actionexportersvc report list endpoint
    Given after a delay of 60 seconds
    When I make the GET call to the actionexporter Report List endpoint for report type "PRINT_VOLUMES"
    Then the response status should be 200
    And the response should contain a JSON array of size 1
    And one element of the JSON array must be "reportType":"PRINT_VOLUMES"
    And one element of the JSON array must be "createdDateTime"
    And one element of the JSON array must be "reportId"
