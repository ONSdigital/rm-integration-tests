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
#							  @case
#
# Scenario Tags: @categories

@casesvc @case
Feature: Validating categories requests

	# GET /categories
	# 200
	@categories
	Scenario: Get request for categories
		When I make the GET call to the caseservice for categories
		Then the response status should be 200
		And the response should contain a JSON array of size 48
		And one element of the JSON array must be {"group":"general","name":"ACCESSIBILITY_MATERIALS","longDescription":"Accessibility Materials","shortDescription":"Accessibility Materials","role":"collect-csos, collect-admins","manual":true}
		And one element of the JSON array must be {"group":null,"name":"ACTION_CANCELLATION_COMPLETED","longDescription":"Action Cancellation Completed","shortDescription":"Action Cancellation Completed","role":null,"manual":false}
		And one element of the JSON array must be {"group":null,"name":"ACTION_CANCELLATION_CREATED","longDescription":"Action Cancellation Created","shortDescription":"Action Cancellation Created","role":null,"manual":false}
		And one element of the JSON array must be {"group":null,"name":"ACTION_COMPLETED","longDescription":"Action Completed","shortDescription":"Action Completed","role":null,"manual":false}
		And one element of the JSON array must be {"group":null,"name":"ACTION_COMPLETED_DEACTIVATED","longDescription":"Action Completed Deactivated","shortDescription":"Action Completed Deactivated","role":null,"manual":false}
		And one element of the JSON array must be {"group":null,"name":"ACTION_COMPLETED_DISABLED","longDescription":"Action Completed Disabled","shortDescription":"Action Completed Disabled","role":null,"manual":false}
		And one element of the JSON array must be {"group":null,"name":"ACTION_CREATED","longDescription":"Action Created","shortDescription":"Action Created","role":null,"manual":false},
		And one element of the JSON array must be {"group":null,"name":"ACTION_UPDATED","longDescription":"Action Updated","shortDescription":"Action Updated","role":null,"manual":false}
		And one element of the JSON array must be {"group":"general","name":"ADDRESS_DETAILS_INCORRECT","longDescription":"Address Details Incorrect","shortDescription":"Address Details Incorrect","role":"collect-csos, collect-admins","manual":true}
		And one element of the JSON array must be {"group":null,"name":"CASE_CREATED","longDescription":"Case Created","shortDescription":"Case Created","role":null,"manual":false}
		And one element of the JSON array must be {"group":"general","name":"CLASSIFICATION_INCORRECT","longDescription":"Classification Incorrect","shortDescription":"Classification Incorrect","role":"collect-csos, collect-admins","manual":true}
		And one element of the JSON array must be {"group":"general","name":"CLOSE_ESCALATION","longDescription":"Close Escalation","shortDescription":"Close Escalation","role":"collect-field-escalate, collect-general-escalate, collect-admins","manual":true}
		And one element of the JSON array must be {"group":null,"name":"C_INDIVIDUAL_REPLACEMENT_IAC_REQUESTED","longDescription":"Communal Individual Replacement IAC Requested","shortDescription":"Communal Individual Replacement IAC Requested","role":"collect-csos, collect-admins","manual":true}
		And one element of the JSON array must be {"group":"general","name":"ESCALATED_REFUSAL","longDescription":"Escalated Refusal","shortDescription":"Escalated Refusal","role":"collect-field-escalate, collect-general-escalate, collect-admins","manual":true}
		And one element of the JSON array must be {"group":"general","name":"FIELD_COMPLAINT_ESCALATED","longDescription":"Field Complaint - Escalated","shortDescription":"Field Complaint - Escalated","role":"collect-csos, collect-admins","manual":true}
		And one element of the JSON array must be {"group":"general","name":"FIELD_EMERGENCY_ESCALATED","longDescription":"Field Emergency - Escalated","shortDescription":"Field Emergency - Escalated","role":"collect-csos, collect-admins","manual":true}
		And one element of the JSON array must be {"group":"general","name":"GENERAL_COMPLAINT","longDescription":"General Complaint","shortDescription":"General Complaint","role":"collect-csos, collect-admins","manual":true}
		And one element of the JSON array must be {"group":"general","name":"GENERAL_COMPLAINT_ESCALATED","longDescription":"General Complaint - Escalated","shortDescription":"General Complaint - Escalated","role":"collect-csos, collect-admins","manual":true}
		And one element of the JSON array must be {"group":"general","name":"GENERAL_ENQUIRY","longDescription":"General Enquiry","shortDescription":"General Enquiry","role":"collect-csos, collect-admins","manual":true}
		And one element of the JSON array must be {"group":"general","name":"GENERAL_ENQUIRY_ESCALATED","longDescription":"General Enquiry - Escalated","shortDescription":"General Enquiry - Escalated","role":"collect-csos, collect-admins","manual":true}
		And one element of the JSON array must be {"group":null,"name":"HOUSEHOLD_PAPER_REQUESTED","longDescription":"Household Paper Requested","shortDescription":"Household Paper Requested","role":"collect-csos, collect-admins","manual":true}
		And one element of the JSON array must be {"group":null,"name":"HOUSEHOLD_REPLACEMENT_IAC_REQUESTED","longDescription":"Household Replacement IAC Requested","shortDescription":"Household Replacement IAC Requested","role":"collect-csos, collect-admins","manual":true}
		And one element of the JSON array must be {"group":null,"name":"H_INDIVIDUAL_PAPER_REQUESTED","longDescription":"Household Individual Paper Requested","shortDescription":"Household Individual Paper Requested","role":"collect-csos, collect-admins","manual":true}
		And one element of the JSON array must be {"group":null,"name":"H_INDIVIDUAL_REPLACEMENT_IAC_REQUESTED","longDescription":"Household Individual Replacement IAC Requested","shortDescription":"Household Individual Replacement IAC Requested","role":"collect-csos, collect-admins","manual":true}
		And one element of the JSON array must be {"group":null,"name":"H_INDIVIDUAL_RESPONSE_REQUESTED","longDescription":"Household Individual Response Requested","shortDescription":"Household Individual Response Requested","role":"collect-csos, collect-admins","manual":true}
		And one element of the JSON array must be {"group":null,"name":"IAC_AUTHENTICATED","longDescription":"Access Code Authenticated By Respondent","shortDescription":"Access Code Authenticated","role":null,"manual":false},
		And one element of the JSON array must be {"group":"general","name":"INCORRECT_ESCALATION","longDescription":"Incorrect Escalation","shortDescription":"Incorrect Escalation","role":"collect-field-escalate, collect-general-escalate, collect_admins","manual":true}
		And one element of the JSON array must be {"group":"general","name":"MISCELLANEOUS","longDescription":"Miscellaneous","shortDescription":"Miscellaneous","role":"collect-csos, collect-admins","manual":true}
		And one element of the JSON array must be {"group":null,"name":"ONLINE_QUESTIONNAIRE_RESPONSE","longDescription":"Online Questionnaire Response","shortDescription":"Online Questionnaire Response","role":null,"manual":false}
		And one element of the JSON array must be {"group":null,"name":"PAPER_QUESTIONNAIRE_RESPONSE","longDescription":"Paper Questionnaire Response","shortDescription":"Paper Questionnaire Response","role":null,"manual":false}
		And one element of the JSON array must be {"group":"general","name":"PENDING","longDescription":"Pending","shortDescription":"Pending","role":"collect-field-escalate, collect-general-escalate, collect-admins","manual":true}
		And one element of the JSON array must be {"group":"general","name":"REFUSAL","longDescription":"Refusal","shortDescription":"Refusal","role":"collect-csos, collect-admins","manual":true}
		And one element of the JSON array must be {"group":"general","name":"TECHNICAL_QUERY","longDescription":"Technical Query","shortDescription":"Technical Query","role":"collect-csos, collect-admins","manual":true}
		And one element of the JSON array must be {"group":"translation","name":"TRANSLATION_ARABIC","longDescription":"Arabic Translation","shortDescription":"Arabic","role":"collect-csos, collect-admins","manual":true}
		And one element of the JSON array must be {"group":"translation","name":"TRANSLATION_BENGALI","longDescription":"Bengali Translation","shortDescription":"Bengali","role":"collect-csos, collect-admins","manual":true}
		And one element of the JSON array must be {"group":"translation","name":"TRANSLATION_CANTONESE","longDescription":"Cantonese Translation","shortDescription":"Cantonese","role":"collect-csos, collect-admins","manual":true}
		And one element of the JSON array must be {"group":"translation","name":"TRANSLATION_GUJARATI","longDescription":"Gujarati Translation","shortDescription":"Gujarati","role":"collect-csos, collect-admins","manual":true}
		And one element of the JSON array must be {"group":"translation","name":"TRANSLATION_LITHUANIAN","longDescription":"Lithuanian Translation","shortDescription":"Lithuanian","role":"collect-csos, collect-admins","manual":true}
		And one element of the JSON array must be {"group":"translation","name":"TRANSLATION_MANDARIN","longDescription":"Mandarin Translation","shortDescription":"Mandarin","role":"collect-csos, collect-admins","manual":true}
		And one element of the JSON array must be {"group":"translation","name":"TRANSLATION_POLISH","longDescription":"Polish Translation","shortDescription":"Polish","role":"collect-csos, collect-admins","manual":true}
		And one element of the JSON array must be {"group":"translation","name":"TRANSLATION_PORTUGUESE","longDescription":"Portuguese Translation","shortDescription":"Portuguese","role":"collect-csos, collect-admins","manual":true}
		And one element of the JSON array must be {"group":"translation","name":"TRANSLATION_PUNJABI_GURMUKHI","longDescription":"Punjabi (Gurmukhi) Translation","shortDescription":"Punjabi (Gurmukhi)","role":"collect-csos, collect-admins","manual":true}
		And one element of the JSON array must be {"group":"translation","name":"TRANSLATION_PUNJABI_SHAHMUKI","longDescription":"Punjabi (Shahmuki) Translation","shortDescription":"Punjabi (Shahmuki)","role":"collect-csos, collect-admins","manual":true}
		And one element of the JSON array must be {"group":"translation","name":"TRANSLATION_SOMALI","longDescription":"Somali Translation","shortDescription":"Somali","role":"collect-csos, collect-admins","manual":true}
		And one element of the JSON array must be {"group":"translation","name":"TRANSLATION_SPANISH","longDescription":"Spanish Translation","shortDescription":"Spanish","role":"collect-csos, collect-admins","manual":true}
		And one element of the JSON array must be {"group":"translation","name":"TRANSLATION_TURKISH","longDescription":"Turkish Translation","shortDescription":"Turkish","role":"collect-csos, collect-admins","manual":true}
		And one element of the JSON array must be {"group":"translation","name":"TRANSLATION_URDU","longDescription":"Urdu Translation","shortDescription":"Urdu","role":"collect-csos, collect-admins","manual":true}
		And one element of the JSON array must be {"group":"general","name":"UNDELIVERABLE","longDescription":"Undeliverable","shortDescription":"Undeliverable","role":"collect-csos, collect-admins","manual":true}


	# GET /categories/{categoryId}
	# 200
	@categories
	Scenario: Get request for categories
		When I make the GET call to the caseservice for category "ACCESSIBILITY_MATERIALS"
		Then the response status should be 200
		And the response should contain the field "group" with value "general"
		And the response should contain the field "name" with value "ACCESSIBILITY_MATERIALS"
		And the response should contain the field "longDescription" with value "Accessibility Materials"
		And the response should contain the field "shortDescription" with value "Accessibility Materials"
		And the response should contain the field "role" with value "collect-csos, collect-admins"
		And the response should contain the field "manual" with boolean value "true"

	# 404
	@categories
	Scenario: Get request for categories invalid id
		When I make the GET call to the caseservice for category "INVALID_NAME"
		Then the response status should be 404
		And the response should contain the field "error.code" with value "RESOURCE_NOT_FOUND"
		And the response should contain the field "error.message" with value "Category not found for categoryName INVALID_NAME"
		And the response should contain the field "error.timestamp"
