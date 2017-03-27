# Author: Chris Hardman 17/01/2017
# Keywords Summary : Validate report types
#
# Feature: Validate report type within the UI
#
# Feature Tags: @reportMI
#
# Scenario Tags:@reportTypeValidation

@reportMI @reportTypeValidation
Feature: Validate report type within the UI

  Scenario Outline: validate the report types
    Given the "Report" user has logged in using "Chrome"
    When the user navigates to the page for reports
    Then the number of report types found is 12
    And validates the report types shown "<reportType>"
    And the user logs out
  Examples:
    | reportType             |
		| HH Returnrate					 |
		| HH Noreturns           |
 		| HH Returnrate Sample   |
		| HH Returnrate LA       |
		| CE Returnrate Uni      |
		| CE ReturnRate SHousing |
		| CE Returnrate Hotel    |
		| HL Metrics             |
		| HH Outstanding Cases   |
		| SH Outstanding Cases   |
		| CE Outstanding Cases   |
		| Print Volumes          |
