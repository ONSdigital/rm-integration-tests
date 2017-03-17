#Author: Kieran Wardle
#Feature: Clean Database
#					Check that the report table contains the correct values.

@correctReportData @reportMI
Feature: Report view contains correct data


Scenario: Clean DB to pre test condition
    When reset the postgres DB
    Then call the "casesvc.insert_helpline_report_into_report()" function
    And call the "actionexporter.generate_print_volumes_mi()" function
    
Scenario: Check that the report table contains the correct values
Given the "Report" user has logged in using "Chrome"
	 Then navigates to the "Reports" page
	 And navigates to the "HL Metrics" page
	 And there is no error message
	 And the report for todays date should be present
	 And navigates to the "View" page
	 And the table should contain the headings "Count_type" and "Count"
	 And the first row of the table should contain the values "Total Calls Received" and "0" in columns 1 and 2
	 And navigates to the "HL Metrics" page
	 And navigates to the "Reports" page
	 And the user logs out

Scenario: Check that the report table contains the correct values
Given the "Report" user has logged in using "Chrome"
	 Then navigates to the "Reports" page
	 And navigates to the "Print Volumes" page
	 And there is no error message
	 And the report for todays date should be present
	 And navigates to the "View" page
	 And the table should contain the headings "filename" and "rowcount"
	 And the user logs out

