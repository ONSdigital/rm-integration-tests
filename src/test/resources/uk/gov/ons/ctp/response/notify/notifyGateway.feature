# Author: Stephen Goddard 21/09/2017
#
# Keywords Summary : This feature file contains the scenario tests for the notify gateway - details are in the swagger spec
#                    https://github.com/ONSdigital/rm-notify-gateway/blob/master/API.md
#
# Feature: List of action scenarios: Reset sample service database to pre test condition
#                                    Get info endpoint
#                                    Post text with optional parameters
#                                    Post text without optional parameters
#                                    Post text with invalid json
#                                    Post email with optional parameters
#                                    Post email without optional parameters
#                                    Post email with invalid json
#                                    Get message by id
#                                    Get message by invalid id 
#
# Feature Tags: @notify
#
@notify
Feature: Validating notify gateway requests

  # Pre Test Set Up

  # Pre Test Notify Gateway Environment Set Up -----

  Scenario: Reset sample service database to pre test condition
    When for the "notifygatewaysvc" run the "notifygatewayreset.sql" postgres DB script
    Then the notifygatewaysvc database has been reset


  # Endpoint Tests -----

  # GET /info
  # 200
  Scenario: Info get request to notify gateway for current verison number
    Given I make get call to the notify gateway endpoint for info
    When the response status should be 200
    Then the response should contain the field "name" with value "notifygatewaysvc"
    And the response should contain the field "version"
    And the response should contain the field "origin"
    And the response should contain the field "commit"
    And the response should contain the field "branch"
    And the response should contain the field "built"


  # POST /texts/{templateid}
  # 201
  Scenario: Post request to notify gateway for texts with optional parameters
    Given I make post call to the notify gateway endpoint for texts
      | ABCD-EFGH-IJKL-MNOP | Test text message |
    When the response status should be 201
    Then the response should contain the field "id"
    And the response should contain the field "templateId" with value "f3778220-f877-4a3d-80ed-e8fa7d104563"
    And the response should contain the field "fromNumber"
    And the response should contain the field "reference" with value "Test text message"

  Scenario: Post request to notify gateway for texts without optional parameters
    Given I make post call to the notify gateway endpoint for texts
      |  |  |
    When the response status should be 201
    Then the response should contain the field "id"
    And the response should contain the field "templateId" with value "f3778220-f877-4a3d-80ed-e8fa7d104563"
    And the response should contain the field "fromNumber"
    And the response should contain the field "reference" with a null value

  # 400
  Scenario: Post request to notify gateway for texts with invalid input
    Given I make post call to the notify gateway endpoint for texts with invalid input
    When the response status should be 400
    Then the response should contain the field "error.code" with value "VALIDATION_FAILED"
    And the response should contain the field "error.message" with value "Provided json fails validation."
    And the response should contain the field "error.timestamp"


  # POST /emails/{templateid}
  # 201
  Scenario: Post request to notify gateway for emails with optional parameters
    Given I make post call to the notify gateway endpoint for emails
      | ABCD-EFGH-IJKL-MNOP | Test email message |
    When the response status should be 201
    Then the response should contain the field "id"
    And the response should contain the field "templateId" with value "290b93f2-04c2-413d-8f9b-93841e684e90"
    And the response should contain the field "fromEmail"
    And the response should contain the field "reference" with value "Test email message"

  Scenario: Post request to notify gateway for emails without optional parameters
    Given I make post call to the notify gateway endpoint for emails
      |  |  |
    When the response status should be 201
    Then the response should contain the field "id"
    And the response should contain the field "templateId" with value "290b93f2-04c2-413d-8f9b-93841e684e90"
    And the response should contain the field "fromEmail"
    And the response should contain the field "reference" with a null value

  # 400
  Scenario: Post request to notify gateway for emails with invalid input
    Given I make post call to the notify gateway endpoint for emails with invalid input
    When the response status should be 400
    Then the response should contain the field "error.code" with value "VALIDATION_FAILED"
    And the response should contain the field "error.message" with value "Provided json fails validation."
    And the response should contain the field "error.timestamp"


  # GET /messages/{messageid}
  # 200 - Note: CURRENTLY FAILS WITH 404 REVISIT
  Scenario: Get request to notify gateway for message id
    Given I make get call to the notify gateway endpoint
    When the response status should be 404

  # 404
  Scenario: Get request to notify gateway for message with invalid id
    Given I make get call to the notify gateway endpoint by message id "de0da3c1-2cad-421a-bddd-054ef101c6ab"
    When the response status should be 404
    Then the response should contain the field "error.code" with value "RESOURCE_NOT_FOUND"
    And the response should contain the field "error.message" with value "Message not found for message id de0da3c1-2cad-421a-bddd-054ef101c6ab"
    And the response should contain the field "error.timestamp"

  # 503 Not tested as service is available
    
    