#Author: Kieran Wardle
#
#Keywords Summary : Checking that the correct reports exist for a report type in the correct place
#
#Feature: Clean Database
#					No report exists and the correct error message is displayed.
#					Reports exist and the correct report date is shown
#
# Feature Tags: @reportMI
#								@reportsListed

@reportMI @reportsListed
Feature: List of reports is shown when a report type is selected, and correct error if none exist

  Scenario: Clean DB to pre test condition
    When reset the postgres DB
    Then call the "casesvc.insert_helpline_report_into_report()" function
    And call the "actionexporter.generate_print_volumes_mi()" function

  Scenario: No reports
    Given the "Report" user has logged in using "Chrome"
    Then navigates to the "Reports" page
    And navigates to the "HH Returnrate" page
    And an error message appears on screen
    And the error message is "No reports found for type HH Returnrate."
    And the user logs out

  Scenario: Check correct report exists for casesvc
    Given the "Report" user has logged in using "Chrome"
    Then navigates to the "Reports" page
    And navigates to the "HL Metrics" page
    And there is no error message
    And the report for todays date should be present
    And navigates to the "Reports" page
    And the user logs out

  Scenario: Check correct report exists for action exporter reports
    Given the "Report" user has logged in using "Chrome"
    Then navigates to the "Reports" page
    And navigates to the "Print Volumes" page
    And there is no error message
    And the report for todays date should be present
    And the user logs out
