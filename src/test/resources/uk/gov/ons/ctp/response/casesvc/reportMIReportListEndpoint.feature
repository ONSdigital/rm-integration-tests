# Author: Kieran Wardle 10/02/2017
#
# Keywords Summary: Test to see if the correct JSON array with the correct list of reports is returned by the Casesvc report endpoint. - details are in the swagger spec
#										 hhttps://github.com/ONSdigital/response-management-service/blob/master/casesvc-api/swagger.yml
#
# Feature: List of scenarios: Clean DB to pre test condition
#						                  Casesvc report list endpoint
#
# Feature Tag:  @casesvc
#               @reportListEndpoint
#               @reportEndpoints
#               @caseSvcReportsEndpoints
#               @reportContentEndpoints

@casesvc @reportListEndpoint @reportEndpoints @caseSvcReportsEndpoints @reportListEndpoints
Feature: Test that the /reports/types/{reportType} returns the correct number of reports for the selected report type in casesvc

  Scenario: Clean DB to pre test condition
    When reset the postgres DB
    Then call the "casesvc.insert_helpline_report_into_report()" function

  Scenario: Casesvc report list endpoint
    Given after a delay of 30 seconds
    When I make the GET call to the casesvc Report List endpoint for report type "HL_METRICS"
    Then the response status should be 200
    And the response should contain a JSON array of size 1
    And one element of the JSON array must be "reportType":"HL_METRICS"
    And one element of the JSON array must be "createdDateTime"
    And one element of the JSON array must be "reportId"
