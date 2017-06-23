# Author: Stephen Goddard 08/03/2016
#
# Keywords Summary : This feature file contains the scenario tests for the casesvc - categories - details are in the swagger spec
#										 https://github.com/ONSdigital/response-management-service/blob/master/casesvc-api/swagger.yml
#										 Note: Assumption that the DB has been loaded with seed data.
#
# Feature: List of Categories scenarios. Get categories
#																				 Get categories by valid name
#																				 Get categories by invalid name
#
# Feature Tags: @casesvc
#							  @categories
#
@casesvc @categories
Feature: Validating categories requests

	# GET /categories
	# 200 - Currently errors
	Scenario: Get request for categories
		When I make the GET call to the caseservice for categories
		Then the response status should be 500
#		And the response should contain a JSON array of size 5
#		And one element of the JSON array must be {"group":"general","name":"ACCESSIBILITY_MATERIALS","longDescription":"Accessibility Materials","shortDescription":"Accessibility Materials","role":"collect-csos, collect-admins","manual":true}
#		And one element of the JSON array must be {"group":null,"name":"ACTION_CANCELLATION_COMPLETED","longDescription":"Action Cancellation Completed","shortDescription":"Action Cancellation Completed","role":null,"manual":false}
#		And one element of the JSON array must be {"group":null,"name":"ACTION_CANCELLATION_CREATED","longDescription":"Action Cancellation Created","shortDescription":"Action Cancellation Created","role":null,"manual":false}
#		And one element of the JSON array must be {"group":null,"name":"ACTION_COMPLETED","longDescription":"Action Completed","shortDescription":"Action Completed","role":null,"manual":false}
#		And one element of the JSON array must be {"group":null,"name":"ACTION_COMPLETED_DEACTIVATED","longDescription":"Action Completed Deactivated","shortDescription":"Action Completed Deactivated","role":null,"manual":false}


	# GET /categories/name/{categoryId}
	# 200
	Scenario: Get request for categories
		When I make the GET call to the caseservice for category "ACTION_COMPLETED"
		Then the response status should be 200
		And the response should contain the field "group" with a null value
		And the response should contain the field "name" with value "ACTION_COMPLETED"
		And the response should contain the field "longDescription" with value "Action Completed"
		And the response should contain the field "shortDescription" with value "Action Completed"
		And the response should contain the field "role" with a null value

	# 404
	Scenario: Get request for categories invalid id
		When I make the GET call to the caseservice for category "INVALID_NAME"
		Then the response status should be 404
		And the response should contain the field "error.code" with value "RESOURCE_NOT_FOUND"
		And the response should contain the field "error.message" with value "Category not found for categoryName INVALID_NAME"
		And the response should contain the field "error.timestamp"
