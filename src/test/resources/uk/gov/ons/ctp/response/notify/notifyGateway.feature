# Author: Stephen Goddard 21/09/2017
#
# Keywords Summary : This feature file contains the scenario tests for the notify gateway - details are in the swagger spec
#                    https://github.com/ONSdigital/rm-notify-gateway/blob/master/API.md
#
# Feature: List of action scenarios: XXX
#                                    Get info endpoint
#
# Feature Tags: @notify
#
@notify
Feature: Validating notify gateway requests

  # Endpoint Tests -----

  # GET /info
  # 200
  Scenario: Info get request to notify gateway for current verison number
    Given I make get call to the notify gateway endpoint for info
    When the response status should be 200
    Then the response should contain the field "name" with value "notifygatewaysvc"
    And the response should contain the field "version"
    And the response should contain the field "origin" with value "git@github.com:ONSdigital/rm-notify-gateway.git"
    And the response should contain the field "commit"
    And the response should contain the field "branch"
    And the response should contain the field "built"


  # POST /texts/{templateid}
  # 200

  # 400
  Scenario: Post request to notify gateway for texts
    Given I make post call to the notify gateway endpoint for texts with invalid input
    When the response status should be 400
    Then the response should contain the field "error.code" with value "VALIDATION_FAILED"
    And the response should contain the field "error.message" with value "Provided json fails validation."
    And the response should contain the field "error.timestamp"


  # POST /emails/{templateid}
  # 200

  # 400
  Scenario: Post request to notify gateway for emails
    Given I make post call to the notify gateway endpoint for emails with invalid input
    When the response status should be 400
    Then the response should contain the field "error.code" with value "VALIDATION_FAILED"
    And the response should contain the field "error.message" with value "Provided json fails validation."
    And the response should contain the field "error.timestamp"


  # GET /messages/{messageid}
  # 200
  
  # 404
  Scenario: Post request to notify gateway for texts
    Given I make get call to the notify gateway endpoint by message id "de0da3c1-2cad-421a-bddd-054ef101c6ab"
    When the response status should be 404
    Then the response should contain the field "error.code" with value "RESOURCE_NOT_FOUND"
    And the response should contain the field "error.message" with value "Message not found for message id de0da3c1-2cad-421a-bddd-054ef101c6ab"
    And the response should contain the field "error.timestamp"

  # 503 Not tested as service is available
    
    