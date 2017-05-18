# Author: Stephen Goddard 16/05/2017
#
# Keywords Summary : This feature file contains the scenario tests for the survey service endpoints - details are in the swagger spec
#                    https://github.com/ONSdigital/rm-survey-service/blob/master/API.md
#
# Feature: List of cases scenarios: Get surveys
#                                   Get survey by valid id
#                                   Get survey by invalid id
#                                   Get classifiers for survey by valid id
#                                   Get classifiers for survey by invalid id
#                                   Get classifier type selector for survey by valid survey id and valid classifier id
#                                   Get classifier type selector for survey by invalid survey id and invalid classifier id
#
# Feature Tags: @surveySvc
#               @surveyEndpoints
#
# Scenario Tags:
#
@surveySvc @surveyEndpoints
Feature: Runs the survey service endpoints

  # Endpoint Tests -----

  # GET /surveys
  # 200
  Scenario: Get request to survey service for surveys
    Given I make the GET call to the survey service endpoint for surveys
    When the response status should be 200
    Then the response should contain a JSON array of size 1
    And one element of the JSON array must be {"id":"cb0711c3-0ac8-41d3-ae0e-567e5ea1ef87","name":"BRES"}


  # GET /surveys/{id}
  # 200
  Scenario: Get request to survey service for surveys by valid id
    Given I make the GET call to the survey service endpoint for survey by id "cb0711c3-0ac8-41d3-ae0e-567e5ea1ef87"
    When the response status should be 200
    Then the response should contain the field "id" with value "cb0711c3-0ac8-41d3-ae0e-567e5ea1ef87"
    And the response should contain the field "name" with value "BRES"

  # 404
  @test404
  Scenario: Get request to survey service for surveys by invalid id
    Given I make the GET call to the survey service endpoint for survey by id "cb0711c3-0ac8-41d3-ae0e-567e5ea1ef88"
    When the response status should be 404
    Then the response should contain "Survey not found"


  # GET /surveys/{id}/classifiertypeselectors
  # 200
  Scenario: Get request to survey service for classifiers by valid survey id
    Given I make the GET call to the survey service endpoint for classifiers by id "cb0711c3-0ac8-41d3-ae0e-567e5ea1ef87"
    When the response status should be 200
    Then the response should contain a JSON array of size 2
    And one element of the JSON array must be {"id":"efa868fb-fb80-44c7-9f33-d6800a17c4da","name":"COLLECTION_INSTRUMENT"}
    And one element of the JSON array must be {"id":"e119ffd6-6fc1-426c-ae81-67a96f9a71ba","name":"COMMUNICATION_TEMPLATE"}

  # 404
  Scenario: Get request to survey service for classifiers by invalid survey id
    Given I make the GET call to the survey service endpoint for classifiers by id "cb0711c3-0ac8-41d3-ae0e-567e5ea1ef88"
    When the response status should be 404
    Then the response should contain "Survey not found"


  # GET /surveys/{id}/classifiertypeselectors/{id}
  # 200
  Scenario: Get request to survey service for classifier by valid survey id and valid classifier id
    Given I make the GET call to the survey service endpoint for classifier by id "cb0711c3-0ac8-41d3-ae0e-567e5ea1ef87" and "efa868fb-fb80-44c7-9f33-d6800a17c4da"
    When the response status should be 200
    Then the response should contain the field "id" with value "efa868fb-fb80-44c7-9f33-d6800a17c4da"
    And the response should contain the field "name" with value "COLLECTION_INSTRUMENT"
    And the response should contain the field "classifierTypes" with one element of the JSON array must be ["COLLECTION_EXERCISE","RU_REF"]

  # 404
  Scenario: Get request to survey service for classifier by invalid survey id and invalid classifier id
    Given I make the GET call to the survey service endpoint for classifier by id "cb0711c3-0ac8-41d3-ae0e-567e5ea1ef88" and "cb0711c3-0ac8-41d3-ae0e-567e5ea1ef89"
    When the response status should be 404
    Then the response should contain "Survey or classifier type selector not found"
