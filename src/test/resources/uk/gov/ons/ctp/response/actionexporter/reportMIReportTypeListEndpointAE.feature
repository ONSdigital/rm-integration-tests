# Author: Kieran Wardle 10/02/2017
#
# Keywords Summary: Test to see if the correct JSON array with the correct list of report types is returned by the actionexportersvc report endpoint. - details are in the swagger spec
#										 https://github.com/ONSdigital/response-management-service/blob/master/actionexportersvc/swagger.yml
#
# Feature: List of scenarios: Clean DB to pre test condition
#						                  actionexportersvc reports endpoint
#
# Feature Tag:  @actionexporter
#               @reportTypesListEndpointAE
#               @reportEndpoints
#               @AEReportsEndpoints
#               @reportTypesEndpoints

@actionexporter @reportTypesListEndpointAE @reportEndpoints @AEReportsEndpoints @reportTypesEndpoints
Feature: Test that the /reports/types endpoint returns the correct list of actionexportersvc report types

  Scenario: Clean DB to pre test condition
    When reset the postgres DB
    Then call the "actionexporter.generate_print_volumes_mi()" function

  Scenario: actionexportersvc reports endpoint
    Given after a delay of 30 seconds
    When I make the GET call to the actionexporter Report endpoint
    Then the response status should be 200
    And the response should contain a JSON array of size 1
    And one element of the JSON array must be "reportTypeId":1,"reportType":"PRINT_VOLUMES","orderId":10,"displayName":"Print Volumes"
