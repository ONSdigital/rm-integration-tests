# Author: Kieran Wardle 10/02/2017
#
# Keywords Summary: Test to see if the correct JSON array with the correct list of report types is returned by the Casesvc report endpoint. - details are in the swagger spec
#										 https://github.com/ONSdigital/response-management-service/blob/master/casesvc-api/swagger.yml
#
# Feature: List of scenarios: Clean DB to pre test condition
#                     			  Casesvc reports endpoint
#
# Feature Tag:  @casesvc
#               @reportTypesListEndpoint
#               @reportEndpoints
#               @caseSvcReportsEndpoints
#               @reportContentEndpoints

@casesvc @reportTypesListEndpoint @reportEndpoints @caseSvcReportsEndpoints @reportTypesEndpoints
Feature: Test that the /reports/types endpoint returns the correct list of report types for casesvc

  Scenario: Clean DB to pre test condition
    When reset the postgres DB
    Then call the "casesvc.insert_helpline_report_into_report()" function

  Scenario: Casesvc reports endpoint
    Given after a delay of 30 seconds
    When I make the GET call to the casesvc Report endpoint
    Then the response status should be 200
    And the response should contain a JSON array of size 11
    And one element of the JSON array must be "reportTypeId":18,"reportType":"HH_RETURNRATE","orderId":10,"displayName":"HH Returnrate"
    And one element of the JSON array must be "reportTypeId":19,"reportType":"HH_NORETURNS","orderId":20,"displayName":"HH Noreturns"
    And one element of the JSON array must be "reportTypeId":20,"reportType":"HH_RETURNRATE_SAMPLE","orderId":30,"displayName":"HH Returnrate Sample"
    And one element of the JSON array must be "reportTypeId":21,"reportType":"HH_RETURNRATE_LA","orderId":40,"displayName":"HH Returnrate LA"
    And one element of the JSON array must be "reportTypeId":22,"reportType":"CE_RETURNRATE_UNI","orderId":50,"displayName":"CE Returnrate Uni"
    And one element of the JSON array must be "reportTypeId":29,"reportType":"CE_RETURNRATE_SHOUSING","orderId":51,"displayName":"CE ReturnRate SHousing"
    And one element of the JSON array must be "reportTypeId":23,"reportType":"CE_RETURNRATE_HOTEL","orderId":60,"displayName":"CE Returnrate Hotel"
    And one element of the JSON array must be "reportTypeId":24,"reportType":"HL_METRICS","orderId":70,"displayName":"HL Metrics"
    And one element of the JSON array must be "reportTypeId":26,"reportType":"HH_OUTSTANDING_CASES","orderId":90,"displayName":"HH Outstanding Cases"
    And one element of the JSON array must be "reportTypeId":27,"reportType":"SH_OUTSTANDING_CASES","orderId":100,"displayName":"SH Outstanding Cases"
    And one element of the JSON array must be "reportTypeId":28,"reportType":"CE_OUTSTANDING_CASES","orderId":110,"displayName":"CE Outstanding Cases"
