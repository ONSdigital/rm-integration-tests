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

@helplineUI @UiLogins 
Feature: User Authentication


	# UI Test Case Events -----
	@UserAuthentication
	Scenario: Login as a Helpline Operator
	 Given the user login as "CSO" using "Chrome"
	 Then collect cso permissions should be verified

	@UserAuthentication
	Scenario: Login as a Manager Operator
	 Given the user login as "General" using "Chrome"
	 Then general escalate permissions should be verified
	 
	@UserAuthentication
	Scenario: Login as a Field Operator
	 Given the user login as "Field" using "Chrome"
	 Then field escalate permissions should be verified
	 
	@UserAuthentication
	Scenario: Login as a Report Operator
	 Given the user login as "Report" using "Chrome"
	 Then report permissions should be verified
	 
	@UserAuthentication
	Scenario: Login using incorrect details
	 Given the user login as "Error" using "Chrome"
	 Then error should be denied permission
