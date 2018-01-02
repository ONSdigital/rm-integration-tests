# Author: Stephen Goddard 16/05/2017
#
# Keywords Summary : This feature file contains the scenario tests for the survey service endpoints - details are in the swagger spec
#                    https://github.com/ONSdigital/rm-survey-service/blob/master/API.md
#
# Feature: List of cases scenarios: Get surveys
#                                   Get survey by valid id
#                                   Get survey by invalid id
#                                   Get survey by name
#                                   Get survey by invalid name
#                                   Get survey ref by valid id
#                                   Get survey ref by invalid id
#                                   Get classifiers for survey by valid id
#                                   Get classifiers for survey by invalid id
#                                   Get classifier type selector for survey by valid survey id and valid classifier id
#                                   Get classifier type selector for survey by invalid survey id and invalid classifier id
#
# Feature Tags: @surveySvc
#               @surveyEndpoints
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
    And one element of the JSON array must be {"id":"cb0711c3-0ac8-41d3-ae0e-567e5ea1ef87","shortName":"BRES"}

  # 204 Not tested as surveys pre loaded


  # GET /surveys/{surveyid}
  # 200
  Scenario: Get request to survey service for surveys by valid id
    Given I make the GET call to the survey service endpoint for survey by id "cb0711c3-0ac8-41d3-ae0e-567e5ea1ef87"
    When the response status should be 200
    Then the response should contain the field "id" with value "cb0711c3-0ac8-41d3-ae0e-567e5ea1ef87"
    And the response should contain the field "shortName" with value "BRES"

  # 404
  Scenario: Get request to survey service for surveys by invalid id
    Given I make the GET call to the survey service endpoint for survey by id "cb0711c3-0ac8-41d3-ae0e-567e5ea1ef88"
    When the response status should be 404
    Then the response should contain "Survey not found"


  # GET /surveys/shortname/{name}
  # 200
  Scenario: Get request to survey service for surveys by valid id
    Given I make the GET call to the survey service endpoint for name "BRES"
    When the response status should be 200
    Then the response should contain the field "id" with value "cb0711c3-0ac8-41d3-ae0e-567e5ea1ef87"
    And the response should contain the field "shortName" with value "BRES"
    And the response should contain the field "surveyRef" with value "221"

  # 404
  Scenario: Get request to survey service for surveys by invalid id
    Given I make the GET call to the survey service endpoint for name "ROOM101"
    When the response status should be 404
    Then the response should contain "Survey not found"


  # GET /surveys/ref/{surveyref}
  # 200
  Scenario: Get request to survey service for surveys by valid id
    Given I make the GET call to the survey service endpoint for survey ref "221"
    When the response status should be 200
    Then the response should contain the field "id" with value "cb0711c3-0ac8-41d3-ae0e-567e5ea1ef87"
    And the response should contain the field "shortName" with value "BRES"
    And the response should contain the field "surveyRef" with value "221"

  # 404
  Scenario: Get request to survey service for surveys by invalid id
    Given I make the GET call to the survey service endpoint for survey ref "101"
    When the response status should be 404
    Then the response should contain "Survey not found"


  # GET /surveys/{surveyid}/classifiertypeselectors
  # 200
  Scenario: Get request to survey service for classifiers by valid survey id
    Given I make the GET call to the survey service endpoint for classifiers by id "cb0711c3-0ac8-41d3-ae0e-567e5ea1ef87"
    When the response status should be 200
    Then the response should contain a JSON array of size 2
    And one element of the JSON array must be {"id":"efa868fb-fb80-44c7-9f33-d6800a17c4da","name":"COLLECTION_INSTRUMENT"}
    And one element of the JSON array must be {"id":"e119ffd6-6fc1-426c-ae81-67a96f9a71ba","name":"COMMUNICATION_TEMPLATE"}

  # 204 Not tested as surveys pre loaded

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


  # GET /info
  # 200
  Scenario: Info request to survey service for current verison number
    Given I make the call to the survey service endpoint for info
    When the response status should be 200
    Then the response should contain the field "name" with value "surveysvc"
    And the response should contain the field "version"
    And the response should contain the field "origin"
    And the response should contain the field "commit"
    And the response should contain the field "branch"
    And the response should contain the field "built"
