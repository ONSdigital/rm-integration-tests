# Author: Stephen Goddard 29/09/2016
#
# Keywords Summary : This feature file contains the scenario tests for the casesvc - actionplanmappings - details are in the swagger spec
#										 https://github.com/ONSdigital/response-management-service/blob/master/casesvc-api/swagger.yml
#										 Note: Assumption that the DB has been loaded with seed data.
#
# Feature: List of action plan mappings scenarios: Get the action plan mapping identified by actionplanmappingid
#																									 Get the action plan mapping identified by an invalid actionplanmappingid
#																									 Get the action plan mapping linked to by casetypeid
#																									 Get the action plan mapping linked to by an invalid casetypeid
#
# Feature Tags: @casesvc
#								@case
#
# Scenario Tags: @actionPlanMappings

@casesvc @case
Feature: Validating Action Plan Mapping requests

	# GET /actionplanmappings/{mappingid}
	# 200
	@actionPlanMappings
	Scenario: Get request to action plan mapping for specific mappingid
		When I make the GET call to the caseservice actionplanmapping endpoint for mappingid "1"
		Then the response status should be 200
		And the response should contain the field "actionPlanMappingId" with an integer value of 1
		And the response should contain the field "actionPlanId" with an integer value of 1
		And the response should contain the field "caseTypeId" with an integer value of 1
		And the response should contain the field "isDefault" with boolean value "true"
		And the response should contain the field "inboundChannel" with value "ONLINE"
		And the response should contain the field "variant" with value "ENGLISH"
		And the response should contain the field "outboundChannel" with value "POST"

	# 404
  @actionPlanMappings
	Scenario: Get request to action plan mapping for non existing mappingid
		When I make the GET call to the caseservice actionplanmapping endpoint for mappingid "101"
		Then the response status should be 404
		And the response should contain the field "error.code" with value "RESOURCE_NOT_FOUND"
		And the response should contain the field "error.message" with value "ActionPlanMapping not found for id 101"
		And the response should contain the field "error.timestamp"


	# GET /actionplanmappings/casetype/{casetypeid}
	# 200
	@actionPlanMappings
	Scenario: Get request to action plan mapping for specific casetypeid
		When I make the GET call to the caseservice actionplanmapping endpoint for casetypeid "22"
		Then the response status should be 200
		And the response should contain a JSON array of size 2
		And one element of the JSON array must be {"actionPlanMappingId":22,"actionPlanId":16,"caseTypeId":22,"isDefault":true,"inboundChannel":"ONLINE","variant":"ENGLISH","outboundChannel":"POST"}
		And one element of the JSON array must be {"actionPlanMappingId":44,"actionPlanId":28,"caseTypeId":22,"isDefault":false,"inboundChannel":"ONLINE","variant":"ENGLISH","outboundChannel":"SMS"}

	# 404
  @actionPlanMappings
	Scenario: Get request to action plan mapping for a non existing casetypeid
		When I make the GET call to the caseservice actionplanmapping endpoint for casetypeid "101"
		Then the response status should be 404
		And the response should contain the field "error.code" with value "RESOURCE_NOT_FOUND"
		And the response should contain the field "error.message" with value "CaseType not found for id 101"
		And the response should contain the field "error.timestamp"
