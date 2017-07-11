# Author: Stephen Goddard 08/03/2016
#
# Keywords Summary : This feature file contains the scenario tests for the casesvc - categories - details are in the swagger spec
#                    https://github.com/ONSdigital/rm-case-service/blob/master/API.md
#                    http://localhost:8171/swagger-ui.html#/
#
# Feature: List of Categories scenarios. Get categories
#																				 Get categories by valid name
#																				 Get categories by invalid name
#
# Feature Tags: @casesvc
#							  @categories
#
@caseSvc @categories
Feature: Validating categories requests

	# GET /categories
	# 200
	Scenario: Get request for categories
		When I make the GET call to the caseservice for categories
		Then the response status should be 200
    And one element of the JSON array must be {"group":null,"name":"ACCESS_CODE_AUTHENTICATION_ATTEMPT","longDescription":"Access Code authentication attempted","shortDescription":"Access Code authentication attempted","role":null}
    And one element of the JSON array must be {"group":null,"name":"ACTION_CANCELLATION_COMPLETED","longDescription":"Action Cancellation Completed","shortDescription":"Action Cancellation Completed","role":null}
    And one element of the JSON array must be {"group":null,"name":"ACTION_CANCELLATION_CREATED","longDescription":"Action Cancellation Created","shortDescription":"Action Cancellation Created","role":null}
    And one element of the JSON array must be {"group":null,"name":"ACTION_COMPLETED","longDescription":"Action Completed","shortDescription":"Action Completed","role":null}
    And one element of the JSON array must be {"group":null,"name":"ACTION_CREATED","longDescription":"Action Created","shortDescription":"Action Created","role":null}
    And one element of the JSON array must be {"group":null,"name":"ACTION_UPDATED","longDescription":"Action Updated","shortDescription":"Action Updated","role":null}
    And one element of the JSON array must be {"group":null,"name":"CASE_CREATED","longDescription":"Case Created","shortDescription":"Case Created","role":null}
    And one element of the JSON array must be {"group":null,"name":"COLLECTION_INSTRUMENT_DOWNLOADED","longDescription":"Collection Instrument Downloaded","shortDescription":"Collection Instrument Downloaded","role":null}
    And one element of the JSON array must be {"group":null,"name":"OFFLINE_RESPONSE_PROCESSED","longDescription":"Offline Response Processed","shortDescription":"Offline Response Processed","role":null}
    And one element of the JSON array must be {"group":null,"name":"RESPONDENT_ACCOUNT_CREATED","longDescription":"Account created for respondent","shortDescription":"Account created for respondent","role":null}
    And one element of the JSON array must be {"group":null,"name":"RESPONDENT_ENROLED","longDescription":"Respondent Enroled","shortDescription":"Respondent Enroled","role":null}
    And one element of the JSON array must be {"group":null,"name":"SUCCESSFUL_RESPONSE_UPLOAD","longDescription":"Successful Response Upload","shortDescription":"Successful Response Upload","role":null}
    And one element of the JSON array must be {"group":null,"name":"UNSUCCESSFUL_RESPONSE_UPLOAD","longDescription":"Unsuccessful Response Upload","shortDescription":"Unsuccessful Response Upload","role":null}

  # 204 Not tested as categories pre loaded


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
