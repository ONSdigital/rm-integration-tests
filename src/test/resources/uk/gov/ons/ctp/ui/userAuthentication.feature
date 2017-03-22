# Author: Chris Hardman 17/11/2016
# Edited: Chris Hardman 16/1/2017
# Keywords Summary : This feature tests User login Authentication
#										 Note: Assumption that the DB has been loaded with seed data.
#
# Feature: List of scenarios: Login as a Helpline Operator
#															Login as a General Operator
#															Login as a Field Operator
#                             Login with incorrect details
#                             
# Feature Tag: @helplineUI
#              @UiLogins
#
# Scenario Tags: @UserAuthentication

@helplineUI @uiLogins 
Feature: User Authentication

	# UI Test Case Events -----

	@UserAuthentication
	Scenario: Login as a Helpline Operator
	 Given the "CSO" user has logged in using "Chrome"
	 When permissions should be verified for user "cso"
	 Then the user logs out

	@UserAuthentication
	Scenario: Login as a Manager Operator
	 Given the "General" user has logged in using "Chrome"
	 When permissions should be verified for user "general"
	 Then the user logs out
	 
	@UserAuthentication
	Scenario: Login as a Field Operator
	 Given the "Field" user has logged in using "Chrome"
	 When permissions should be verified for user "field"
	 Then the user logs out
	 
	@UserAuthentication
	Scenario: Login as a Report Operator
	 Given the "Report" user has logged in using "Chrome"
	 When permissions should be verified for user "report"
	 Then the user logs out
	 
	@UserAuthentication
	Scenario: Login using incorrect details
	 Given the "Error" user has logged in using "Chrome"
	 When permissions should be verified for user "error"
	 Then close browser
