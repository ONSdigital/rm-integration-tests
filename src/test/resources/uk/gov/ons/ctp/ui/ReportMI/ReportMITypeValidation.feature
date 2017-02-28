# Author: Chris Hardman 17/01/2017
# Keywords Summary : Validate report types
#
# Feature: Validate report type within the UI
#                                                                       
#
# Feature Tags: @reportMI
#
# Scenario Tags:@reportTypeValidation
@reportMI @reportTypeValidation
Feature: Validate report type within the UI
        
        Scenario: validate the report types
        Given the user login as "Report" using "Chrome"
        And navigates to the "Reports" page
        Then validates the report types shown to the user