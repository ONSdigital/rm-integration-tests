# Author: Stephen Goddard 08/03/2016
#
# Keywords Summary : This feature file contains the scenario tests for the casesvc - casetypes - details are in the swagger spec
#										 https://github.com/ONSdigital/response-management-service/blob/master/casesvc-api/swagger.yml
#										 Note: Assumption that the DB has been loaded with seed data.
#
# Feature: List of Case Type scenarios. Get casetypes by valid casetype
#																				Get addresses by invalid casetype
#
# Feature Tags: @casesvc
#							  @case
#
# Scenario Tags: @casetypes


@casesvc @case
Feature: Validating casetype requests

	# GET /casetypes/{casetype}
	# 200
	@casetypes
	Scenario: Get request for casetypes by casetype
		When I make the GET call to the caseservice for casetypes by casetype "1"
		Then the response status should be 200
		And the response should contain the field "caseTypeId" with an integer value of 1
		And the response should contain the field "name" with value "HC1SO331D4E"
		And the response should contain the field "description" with value "component 1 sex id online first 331 day 4 england household"
		And the response should contain the field "respondentType" with value "H"
		And the response should contain the field "questionSet" with value "H1S"

	# 404
	@casetypes
	Scenario: Get request for casetypes for a non existing casetype
		When I make the GET call to the caseservice for casetypes by casetype "101"
		Then the response status should be 404
		And the response should contain the field "error.code" with value "RESOURCE_NOT_FOUND"
		And the response should contain the field "error.message" with value "CaseType not found for id 101"
		And the response should contain the field "error.timestamp"
