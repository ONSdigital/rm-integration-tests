# Author: Kieran Wardle 10/02/2017
#
# Keywords Summary: Test to see if the correct JSON array with the correct list of report content is returned by the Casesvc report endpoint. - details are in the swagger spec
#										 https://github.com/ONSdigital/response-management-service/blob/master/casesvc-api/swagger.yml
#
# Feature: List of scenarios:	Clean DB to pre test condition
#						                  Casesvc report content endpoint
#
# Feature Tag:  @casesvc
#               @reportContentEndpoint
#               @reportEndpoints
#               @caseSvcReportsEndpoints
#               @reportContentEndpoints

@casesvc @reportContentEndpoint @reportEndpoints @caseSvcReportsEndpoints @reportContentEndpoints
Feature: Test that the /reports/{reportId} endpoint returns the correct contents for the chosen report in casesvc

  Scenario: Clean DB to pre test condition
    When reset the postgres DB
    Then call the "casesvc.insert_helpline_report_into_report()" function

  Scenario: Casesvc report content endpoint
    Given after a delay of 30 seconds
    When I make the GET call to the casesvc Report Content endpoint for the report of report type "HL_METRICS"
    Then the response status should be 200
    And the response should contain the field "reportId"
    And the response should contain the field "createdDateTime"
    And the response should contain the field "reportType" with value "HL_METRICS"
    And the response should contain the field "contents" with contents "Count_type, Count"
    And the response should contain the field "contents" with contents "Total Calls Received,0"
    And the response should contain the field "contents" with contents "Total calls received 09-10,0"
    And the response should contain the field "contents" with contents "Total calls received 10-11,0"
    And the response should contain the field "contents" with contents "Total calls received 11-12,0"
    And the response should contain the field "contents" with contents "Total calls received 12-13,0"
    And the response should contain the field "contents" with contents "Total calls received 13-14,0"
    And the response should contain the field "contents" with contents "Total calls received 14-15,0"
    And the response should contain the field "contents" with contents "Total calls received 15-16,0"
    And the response should contain the field "contents" with contents "Total calls received 16-17,0"
    And the response should contain the field "contents" with contents "Total calls received 17-18,0"
    And the response should contain the field "contents" with contents "Total calls received 18-19,0"
    And the response should contain the field "contents" with contents "Total calls received 19-20,0"
    And the response should contain the field "contents" with contents "Total calls received 20-21,0"
    And the response should contain the field "contents" with contents "Total Accessibility Materials Calls,0"
    And the response should contain the field "contents" with contents "Total Address Details Incorrect Calls,0"
    And the response should contain the field "contents" with contents "Total Communal Individual Replacement IAC Requested Calls,0"
    And the response should contain the field "contents" with contents "Total Classification Incorrect Calls,0"
    And the response should contain the field "contents" with contents "Total Close Escalation Calls,0"
    And the response should contain the field "contents" with contents "Total Escalated Refusal Calls,0"
    And the response should contain the field "contents" with contents "Total Field Complaint - Escalated Calls,0"
    And the response should contain the field "contents" with contents "Total Field Emergency - Escalated Calls,0"
    And the response should contain the field "contents" with contents "Total General Complaint Calls,0"
    And the response should contain the field "contents" with contents "Total General Complaint - Escalated Calls,0"
    And the response should contain the field "contents" with contents "Total General Enquiry Calls,0"
    And the response should contain the field "contents" with contents "Total General Enquiry - Escalated Calls,0"
    And the response should contain the field "contents" with contents "Total Household Individual Paper Requested Calls,0"
    And the response should contain the field "contents" with contents "Total Household Individual Replacement IAC Requested Calls,0"
    And the response should contain the field "contents" with contents "Total Household Individual Response Requested Calls,0"
    And the response should contain the field "contents" with contents "Total Household Paper Requested Calls,0"
    And the response should contain the field "contents" with contents "Total Household Replacement IAC Requested Calls,0"
    And the response should contain the field "contents" with contents "Total Incorrect Escalation Calls,0"
    And the response should contain the field "contents" with contents "Total Miscellaneous Calls,0"
    And the response should contain the field "contents" with contents "Total Pending Calls,0"
    And the response should contain the field "contents" with contents "Total Refusal Calls,0"
    And the response should contain the field "contents" with contents "Total Technical Query Calls,0"
    And the response should contain the field "contents" with contents "Total Arabic Translation Calls,0"
    And the response should contain the field "contents" with contents "Total Bengali Translation Calls,0"
    And the response should contain the field "contents" with contents "Total Cantonese Translation Calls,0"
    And the response should contain the field "contents" with contents "Total Gujarati Translation Calls,0"
    And the response should contain the field "contents" with contents "Total Lithuanian Translation Calls,0"
    And the response should contain the field "contents" with contents "Total Mandarin Translation Calls,0"
    And the response should contain the field "contents" with contents "Total Polish Translation Calls,0"
    And the response should contain the field "contents" with contents "Total Portuguese Translation Calls,0"
    And the response should contain the field "contents" with contents "Total Punjabi (Gurmukhi) Translation Calls,0"
    And the response should contain the field "contents" with contents "Total Punjabi (Shahmuki) Translation Calls,0"
    And the response should contain the field "contents" with contents "Total Somali Translation Calls,0"
    And the response should contain the field "contents" with contents "Total Spanish Translation Calls,0"
    And the response should contain the field "contents" with contents "Total Turkish Translation Calls,0"
    And the response should contain the field "contents" with contents "Total Urdu Translation Calls,0"
