# Author: Kieran Wardle
#
# Keywords Summary : Checking that the reports show the correct details
#
# Feature: Clean Database
#					 Check that the report table contains the correct values.
#
# Feature Tags: @reportMI
#								@reportsListed
#

@reportMI @correctReportData
Feature: Report view contains correct data

  Scenario: Clean DB to pre test condition
    When reset the postgres DB
    Then call the "casesvc.insert_helpline_report_into_report()" function
    And call the "actionexporter.generate_print_volumes_mi()" function

  Scenario: Check that the report table contains the correct values
    Given the "Report" user has logged in using "Chrome"
    When the user navigates to the page for reports
    And the user navigates to the "HL Metrics" page
    And the report for todays date should be present
    And the user navigates to the report details page
    Then the table should contain the headings "Count_type"
    And the table should contain the headings "Count"
    And the table should contain "Total Calls Received" with the value of "0"
    And the table should contain "Total calls received 09-10" with the value of "0"
    And the table should contain "Total calls received 10-11" with the value of "0"
    And the table should contain "Total calls received 11-12" with the value of "0"
    And the table should contain "Total calls received 12-13" with the value of "0"
    And the table should contain "Total calls received 13-14" with the value of "0"
    And the table should contain "Total calls received 14-15" with the value of "0"
    And the table should contain "Total calls received 15-16" with the value of "0"
    And the table should contain "Total calls received 16-17" with the value of "0"
    And the table should contain "Total calls received 17-18" with the value of "0"
    And the table should contain "Total calls received 18-19" with the value of "0"
    And the table should contain "Total calls received 19-20" with the value of "0"
    And the table should contain "Total calls received 20-21" with the value of "0"
    And the table should contain "Total Accessibility Materials Calls" with the value of "0"
    And the table should contain "Total Address Details Incorrect Calls" with the value of "0"
    And the table should contain "Total Communal Individual Replacement IAC Requested Calls" with the value of "0"
    And the table should contain "Total Classification Incorrect Calls" with the value of "0"
    And the table should contain "Total Close Escalation Calls" with the value of "0"
    And the table should contain "Total Escalated Refusal Calls" with the value of "0"
    And the table should contain "Total Field Complaint - Escalated Calls" with the value of "0"
    And the table should contain "Total Field Emergency - Escalated Calls" with the value of "0"
    And the table should contain "Total General Complaint Calls" with the value of "0"
    And the table should contain "Total General Complaint - Escalated Calls" with the value of "0"
    And the table should contain "Total General Enquiry Calls" with the value of "0"
    And the table should contain "Total General Enquiry - Escalated Calls" with the value of "0"
    And the table should contain "Total Household Individual Paper Requested Calls" with the value of "0"
    And the table should contain "Total Household Individual Replacement IAC Requested Calls" with the value of "0"
    And the table should contain "Total Household Individual Response Requested Calls" with the value of "0"
    And the table should contain "Total Household Paper Requested Calls" with the value of "0"
    And the table should contain "Total Household Replacement IAC Requested Calls" with the value of "0"
    And the table should contain "Total Incorrect Escalation Calls" with the value of "0"
    And the table should contain "Total Miscellaneous Calls" with the value of "0"
    And the table should contain "Total Pending Calls" with the value of "0"
    And the table should contain "Total Refusal Calls" with the value of "0"
    And the table should contain "Total Technical Query Calls" with the value of "0"
    And the table should contain "Total Arabic Translation Calls" with the value of "0"
    And the table should contain "Total Bengali Translation Calls" with the value of "0"
    And the table should contain "Total Cantonese Translation Calls" with the value of "0"
    And the table should contain "Total Gujarati Translation Calls" with the value of "0"
    And the table should contain "Total Lithuanian Translation Calls" with the value of "0"
    And the table should contain "Total Mandarin Translation Calls" with the value of "0"
    And the table should contain "Total Polish Translation Calls" with the value of "0"
    And the table should contain "Total Portuguese Translation Calls" with the value of "0"
    And the table should contain "Total Punjabi (Gurmukhi) Translation Calls" with the value of "0"
    And the table should contain "Total Punjabi (Shahmuki) Translation Calls" with the value of "0"
    And the table should contain "Total Somali Translation Calls" with the value of "0"
    And the table should contain "Total Spanish Translation Calls" with the value of "0"
    And the table should contain "Total Turkish Translation Calls" with the value of "0"
    And the table should contain "Total Urdu Translation Calls" with the value of "0"
    And the user logs out

  Scenario: Check that the report table contains the correct values
    Given the "Report" user has logged in using "Chrome"
    When the user navigates to the page for reports
    And the user navigates to the "Print Volumes" page
    And the report for todays date should be present
    And the user navigates to the report details page
    Then the table should contain the headings "filename"
    And the table should contain the headings "rowcount"
    And the table should contain the headings "datesent"
    And the report emtpty message is displayed "Report is empty."
    And the user logs out
