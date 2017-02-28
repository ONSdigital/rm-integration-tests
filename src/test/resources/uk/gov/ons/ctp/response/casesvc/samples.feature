# Author: Stephen Goddard 07/03/2016
#
# Keywords Summary : This feature file contains the scenario tests for the casesvc - samples - details are in the swagger spec
#										 https://github.com/ONSdigital/response-management-service/blob/master/casesvc-api/swagger.yml
#										 Note: Assumption that the DB has been loaded with seed data.
#
# Feature: List of Samples scenarios: Clean DB to pre test condition
#																			Get samples by valid sample (Repeated for all 22 samples)
#																			Get samples by invalid sample id
#																			Put samples by sample id (Repeated for all 22 samples)
#																			Put samples by invalid sample id
#																			Test cases created in database
#
# Feature Tags: @casesvc
#							  @case
#
# Scenario Tags: @samplesCleanEnvironment
#								 @samples
#								 @generateIAC
@casesvc @case
Feature: Validating samples requests

  # Clean Environment -----
  @samplesCleanEnvironment @samples
  Scenario: Clean DB to pre test condition
    When reset the postgres DB
    Then check "casesvc.case" records in DB equal 0
    And check "casesvc.caseevent" records in DB equal 0
    And check "casesvc.casegroup" records in DB equal 0
    And check "casesvc.contact" records in DB equal 0
    And check "casesvc.response" records in DB equal 0
    And check "casesvc.messagelog" records in DB equal 0
    And check "casesvc.unlinkedcasereceipt" records in DB equal 0
    And check "action.action" records in DB equal 0
    And check "action.actionplanjob" records in DB equal 0
    And check "action.case" records in DB equal 0
    And check "action.messagelog" records in DB equal 0
    And check "casesvc.caseeventidseq" sequence in DB equal 1
    And check "casesvc.caseidseq" sequence in DB equal 1
    And check "casesvc.casegroupidseq" sequence in DB equal 1
    And check "casesvc.caserefseq" sequence in DB equal 1000000000000001
    And check "casesvc.responseidseq" sequence in DB equal 1
    And check "casesvc.messageseq" sequence in DB equal 1
    And check "action.actionidseq" sequence in DB equal 1
    And check "action.actionplanjobseq" sequence in DB equal 1
    And check "action.messageseq" sequence in DB equal 1

  # Endpoint Tests -----
  # GET /samples/{sampleId}
  # 200
  @samples
  Scenario: Get request for samples for sample id
    When I make the GET call to the caseservice for samples for sample id "1"
    Then the response status should be 200
    And the response should contain the field "sampleId" with an integer value of 1
    And the response should contain the field "name" with value "C2EO332E"
    And the response should contain the field "description" with value "component 2 no sex id online first 332 england"
    And the response should contain the field "addressCriteria" with value "SAMPLE = C2EO332E"
    And the response should contain the field "survey" with value "2017 TEST"
    And the response should contain the field "sampleCaseTypes" with one element of the JSON array must be {"caseTypeId":17,"respondentType":"H"}
    And the response should contain the field "sampleCaseTypes" with one element of the JSON array must be {"caseTypeId":26,"respondentType":"HI"}

  # 200
  @samples
  Scenario: Get request for samples for sample id
    When I make the GET call to the caseservice for samples for sample id "2"
    Then the response status should be 200
    And the response should contain the field "sampleId" with an integer value of 2
    And the response should contain the field "name" with value "C2EO331BIE"
    And the response should contain the field "description" with value "component 2 no sex id online first 331 england beavioural insights"
    And the response should contain the field "addressCriteria" with value "SAMPLE = C2EO331BIE"
    And the response should contain the field "survey" with value "2017 TEST"
    And the response should contain the field "sampleCaseTypes" with one element of the JSON array must be {"caseTypeId":18,"respondentType":"H"}
    And the response should contain the field "sampleCaseTypes" with one element of the JSON array must be {"caseTypeId":26,"respondentType":"HI"}

  # 200
  @samples
  Scenario: Get request for samples for sample id
    When I make the GET call to the caseservice for samples for sample id "3"
    Then the response status should be 200
    And the response should contain the field "sampleId" with an integer value of 3
    And the response should contain the field "name" with value "C2EO332BIE"
    And the response should contain the field "description" with value "component 2 no sex id online first 332 england beavioural insights"
    And the response should contain the field "addressCriteria" with value "SAMPLE = C2EO332BIE"
    And the response should contain the field "survey" with value "2017 TEST"
    And the response should contain the field "sampleCaseTypes" with one element of the JSON array must be {"caseTypeId":19,"respondentType":"H"}
    And the response should contain the field "sampleCaseTypes" with one element of the JSON array must be {"caseTypeId":26,"respondentType":"HI"}

  # 200
  @samples
  Scenario: Get request for samples for sample id
    When I make the GET call to the caseservice for samples for sample id "4"
    Then the response status should be 200
    And the response should contain the field "sampleId" with an integer value of 4
    And the response should contain the field "name" with value "C2EO300E"
    And the response should contain the field "description" with value "component 2 no sex id online first 300 england"
    And the response should contain the field "addressCriteria" with value "SAMPLE = C2EO300E"
    And the response should contain the field "survey" with value "2017 TEST"
    And the response should contain the field "sampleCaseTypes" with one element of the JSON array must be {"caseTypeId":20,"respondentType":"H"}
    And the response should contain the field "sampleCaseTypes" with one element of the JSON array must be {"caseTypeId":26,"respondentType":"HI"}

  # 200
  @samples
  Scenario: Get request for samples for sample id
    When I make the GET call to the caseservice for samples for sample id "5"
    Then the response status should be 200
    And the response should contain the field "sampleId" with an integer value of 5
    And the response should contain the field "name" with value "C2EO200E"
    And the response should contain the field "description" with value "component 2 no sex id online first 200 england"
    And the response should contain the field "addressCriteria" with value "SAMPLE = C2EO200E"
    And the response should contain the field "survey" with value "2017 TEST"
    And the response should contain the field "sampleCaseTypes" with one element of the JSON array must be {"caseTypeId":21,"respondentType":"H"}
    And the response should contain the field "sampleCaseTypes" with one element of the JSON array must be {"caseTypeId":26,"respondentType":"HI"}

  # 200
  @samples
  Scenario: Get request for samples for sample id
    When I make the GET call to the caseservice for samples for sample id "6"
    Then the response status should be 200
    And the response should contain the field "sampleId" with an integer value of 6
    And the response should contain the field "name" with value "C2EO331ADE"
    And the response should contain the field "description" with value "component 2 no sex id online first 331 assisted digital england"
    And the response should contain the field "addressCriteria" with value "SAMPLE = C2EO331ADE"
    And the response should contain the field "survey" with value "2017 TEST"
    And the response should contain the field "sampleCaseTypes" with one element of the JSON array must be {"caseTypeId":22,"respondentType":"H"}
    And the response should contain the field "sampleCaseTypes" with one element of the JSON array must be {"caseTypeId":26,"respondentType":"HI"}

  # 200
  @samples
  Scenario: Get request for samples for sample id
    When I make the GET call to the caseservice for samples for sample id "7"
    Then the response status should be 200
    And the response should contain the field "sampleId" with an integer value of 7
    And the response should contain the field "name" with value "C1SO331D4E"
    And the response should contain the field "description" with value "component 1 sex id online first 331 day 4 england"
    And the response should contain the field "addressCriteria" with value "SAMPLE = C1SO331D4E"
    And the response should contain the field "survey" with value "2017 TEST"
    And the response should contain the field "sampleCaseTypes" with one element of the JSON array must be {"caseTypeId":1,"respondentType":"H"}
    And the response should contain the field "sampleCaseTypes" with one element of the JSON array must be {"caseTypeId":23,"respondentType":"HI"}

  # 200
  @samples
  Scenario: Get request for samples for sample id
    When I make the GET call to the caseservice for samples for sample id "8"
    Then the response status should be 200
    And the response should contain the field "sampleId" with an integer value of 8
    And the response should contain the field "name" with value "C1SO331D4W"
    And the response should contain the field "description" with value "component 1 sex id online first 331 day 4 wales"
    And the response should contain the field "addressCriteria" with value "SAMPLE = C1SO331D4W"
    And the response should contain the field "survey" with value "2017 TEST"
    And the response should contain the field "sampleCaseTypes" with one element of the JSON array must be {"caseTypeId":2,"respondentType":"H"}

  # 200
  @samples
  Scenario: Get request for samples for sample id
    When I make the GET call to the caseservice for samples for sample id "9"
    Then the response status should be 200
    And the response should contain the field "sampleId" with an integer value of 9
    And the response should contain the field "name" with value "C1SO331D10E"
    And the response should contain the field "description" with value "component 1 sex id online first 331 day 10 england"
    And the response should contain the field "addressCriteria" with value "SAMPLE = C1SO331D10E"
    And the response should contain the field "survey" with value "2017 TEST"
    And the response should contain the field "sampleCaseTypes" with one element of the JSON array must be {"caseTypeId":3,"respondentType":"H"}
    And the response should contain the field "sampleCaseTypes" with one element of the JSON array must be {"caseTypeId":23,"respondentType":"HI"}

  # 200
  @samples
  Scenario: Get request for samples for sample id
    When I make the GET call to the caseservice for samples for sample id "10"
    Then the response status should be 200
    And the response should contain the field "sampleId" with an integer value of 10
    And the response should contain the field "name" with value "C1SO331D10W"
    And the response should contain the field "description" with value "component 1 sex id online first 331 day 10 wales"
    And the response should contain the field "addressCriteria" with value "SAMPLE = C1SO331D10W"
    And the response should contain the field "survey" with value "2017 TEST"
    And the response should contain the field "sampleCaseTypes" with one element of the JSON array must be {"caseTypeId":4,"respondentType":"H"}

  # 200
  @samples
  Scenario: Get request for samples for sample id
    When I make the GET call to the caseservice for samples for sample id "11"
    Then the response status should be 200
    And the response should contain the field "sampleId" with an integer value of 11
    And the response should contain the field "name" with value "C1EO331D4E"
    And the response should contain the field "description" with value "component 1 no sex id online first 331 day 4 england"
    And the response should contain the field "addressCriteria" with value "SAMPLE = C1EO331D4E"
    And the response should contain the field "survey" with value "2017 TEST"
    And the response should contain the field "sampleCaseTypes" with one element of the JSON array must be {"caseTypeId":5,"respondentType":"H"}
    And the response should contain the field "sampleCaseTypes" with one element of the JSON array must be {"caseTypeId":25,"respondentType":"HI"}

  # 200
  @samples
  Scenario: Get request for samples for sample id
    When I make the GET call to the caseservice for samples for sample id "12"
    Then the response status should be 200
    And the response should contain the field "sampleId" with an integer value of 12
    And the response should contain the field "name" with value "C1EO331D4W"
    And the response should contain the field "description" with value "component 1 no sex id online first 331 day 4 wales"
    And the response should contain the field "addressCriteria" with value "SAMPLE = C1EO331D4W"
    And the response should contain the field "survey" with value "2017 TEST"
    And the response should contain the field "sampleCaseTypes" with one element of the JSON array must be {"caseTypeId":6,"respondentType":"H"}

  # 200
  @samples
  Scenario: Get request for samples for sample id
    When I make the GET call to the caseservice for samples for sample id "13"
    Then the response status should be 200
    And the response should contain the field "sampleId" with an integer value of 13
    And the response should contain the field "name" with value "C1EO331D10E"
    And the response should contain the field "description" with value "component 1 no sex id online first 331 day 10 england"
    And the response should contain the field "addressCriteria" with value "SAMPLE = C1EO331D10E"
    And the response should contain the field "survey" with value "2017 TEST"
    And the response should contain the field "sampleCaseTypes" with one element of the JSON array must be {"caseTypeId":7,"respondentType":"H"}
    And the response should contain the field "sampleCaseTypes" with one element of the JSON array must be {"caseTypeId":25,"respondentType":"HI"}

  # 200
  @samples
  Scenario: Get request for samples for sample id
    When I make the GET call to the caseservice for samples for sample id "14"
    Then the response status should be 200
    And the response should contain the field "sampleId" with an integer value of 14
    And the response should contain the field "name" with value "C1EO331D10W"
    And the response should contain the field "description" with value "component 1 no sex id online first 331 day 10 wales"
    And the response should contain the field "addressCriteria" with value "SAMPLE = C1EO331D10W"
    And the response should contain the field "survey" with value "2017 TEST"
    And the response should contain the field "sampleCaseTypes" with one element of the JSON array must be {"caseTypeId":8,"respondentType":"H"}

  # 200
  @samples
  Scenario: Get request for samples for sample id
    When I make the GET call to the caseservice for samples for sample id "15"
    Then the response status should be 200
    And the response should contain the field "sampleId" with an integer value of 15
    And the response should contain the field "name" with value "C2SP331E"
    And the response should contain the field "description" with value "component 2 sex id paper first 331 england"
    And the response should contain the field "addressCriteria" with value "SAMPLE = C2SP331E"
    And the response should contain the field "survey" with value "2017 TEST"
    And the response should contain the field "sampleCaseTypes" with one element of the JSON array must be {"caseTypeId":9,"respondentType":"H"}
    And the response should contain the field "sampleCaseTypes" with one element of the JSON array must be {"caseTypeId":23,"respondentType":"HI"}

  # 200
  @samples
  Scenario: Get request for samples for sample id
    When I make the GET call to the caseservice for samples for sample id "16"
    Then the response status should be 200
    And the response should contain the field "sampleId" with an integer value of 16
    And the response should contain the field "name" with value "C2SP331W"
    And the response should contain the field "description" with value "component 2 sex id paper first 331 wales"
    And the response should contain the field "addressCriteria" with value "SAMPLE = C2SP331W"
    And the response should contain the field "survey" with value "2017 TEST"
    And the response should contain the field "sampleCaseTypes" with one element of the JSON array must be {"caseTypeId":10,"respondentType":"H"}

  # 200
  @samples
  Scenario: Get request for samples for sample id
    When I make the GET call to the caseservice for samples for sample id "17"
    Then the response status should be 200
    And the response should contain the field "sampleId" with an integer value of 17
    And the response should contain the field "name" with value "C2EP331E"
    And the response should contain the field "description" with value "component 2 no sex id paper first 331 england"
    And the response should contain the field "addressCriteria" with value "SAMPLE = C2EP331E"
    And the response should contain the field "survey" with value "2017 TEST"
    And the response should contain the field "sampleCaseTypes" with one element of the JSON array must be {"caseTypeId":11,"respondentType":"H"}
    And the response should contain the field "sampleCaseTypes" with one element of the JSON array must be {"caseTypeId":25,"respondentType":"HI"}

  # 200
  @samples
  Scenario: Get request for samples for sample id
    When I make the GET call to the caseservice for samples for sample id "18"
    Then the response status should be 200
    And the response should contain the field "sampleId" with an integer value of 18
    And the response should contain the field "name" with value "C2EP331W"
    And the response should contain the field "description" with value "component 2 no sex id paper first 331 wales"
    And the response should contain the field "addressCriteria" with value "SAMPLE = C2EP331W"
    And the response should contain the field "survey" with value "2017 TEST"
    And the response should contain the field "sampleCaseTypes" with one element of the JSON array must be {"caseTypeId":12,"respondentType":"H"}

  # 200
  @samples
  Scenario: Get request for samples for sample id
    When I make the GET call to the caseservice for samples for sample id "19"
    Then the response status should be 200
    And the response should contain the field "sampleId" with an integer value of 19
    And the response should contain the field "name" with value "C2SO331E"
    And the response should contain the field "description" with value "component 2 sex id online first 331 england"
    And the response should contain the field "addressCriteria" with value "SAMPLE = C2SO331E"
    And the response should contain the field "survey" with value "2017 TEST"
    And the response should contain the field "sampleCaseTypes" with one element of the JSON array must be {"caseTypeId":13,"respondentType":"H"}
    And the response should contain the field "sampleCaseTypes" with one element of the JSON array must be {"caseTypeId":23,"respondentType":"HI"}

  # 200
  @samples
  Scenario: Get request for samples for sample id
    When I make the GET call to the caseservice for samples for sample id "20"
    Then the response status should be 200
    And the response should contain the field "sampleId" with an integer value of 20
    And the response should contain the field "name" with value "C2SO331W"
    And the response should contain the field "description" with value "component 2 sex id online first 331 wales"
    And the response should contain the field "addressCriteria" with value "SAMPLE = C2SO331W"
    And the response should contain the field "survey" with value "2017 TEST"
    And the response should contain the field "sampleCaseTypes" with one element of the JSON array must be {"caseTypeId":14,"respondentType":"H"}

  # 200
  @samples
  Scenario: Get request for samples for sample id
    When I make the GET call to the caseservice for samples for sample id "21"
    Then the response status should be 200
    And the response should contain the field "sampleId" with an integer value of 21
    And the response should contain the field "name" with value "C2EO331E"
    And the response should contain the field "description" with value "component 2 no sex id online first 331 england"
    And the response should contain the field "addressCriteria" with value "SAMPLE = C2EO331E"
    And the response should contain the field "survey" with value "2017 TEST"
    And the response should contain the field "sampleCaseTypes" with one element of the JSON array must be {"caseTypeId":15,"respondentType":"H"}
    And the response should contain the field "sampleCaseTypes" with one element of the JSON array must be {"caseTypeId":25,"respondentType":"HI"}

  # 200
  @samples
  Scenario: Get request for samples for sample id
    When I make the GET call to the caseservice for samples for sample id "22"
    Then the response status should be 200
    And the response should contain the field "sampleId" with an integer value of 22
    And the response should contain the field "name" with value "C2EO331W"
    And the response should contain the field "description" with value "component 2 no sex id online first 331 wales"
    And the response should contain the field "addressCriteria" with value "SAMPLE = C2EO331W"
    And the response should contain the field "survey" with value "2017 TEST"
    And the response should contain the field "sampleCaseTypes" with one element of the JSON array must be {"caseTypeId":16,"respondentType":"H"}

  # 200
  @samples
  Scenario: Put request for sample to create online cases for the specified sample id
    When I make the GET call to the caseservice for samples for sample id "23"
    Then the response status should be 200
    And the response should contain the field "sampleId" with an integer value of 23
    And the response should contain the field "name" with value "SHOUSING"
    And the response should contain the field "description" with value "sheltered housing"
    And the response should contain the field "addressCriteria" with value "SAMPLE = SHOUSING"
    And the response should contain the field "survey" with value "2017 TEST"
    And the response should contain the field "sampleCaseTypes" with one element of the JSON array must be {"caseTypeId":29,"respondentType":"H"}
    And the response should contain the field "sampleCaseTypes" with one element of the JSON array must be {"caseTypeId":26,"respondentType":"HI"}

  # 200
  @samples
  Scenario: Put request for sample to create online cases for the specified sample id
    When I make the GET call to the caseservice for samples for sample id "24"
    Then the response status should be 200
    And the response should contain the field "sampleId" with an integer value of 24
    And the response should contain the field "name" with value "HOTEL"
    And the response should contain the field "description" with value "hotel"
    And the response should contain the field "addressCriteria" with value "SAMPLE = HOTEL"
    And the response should contain the field "survey" with value "2017 TEST"
    And the response should contain the field "sampleCaseTypes" with one element of the JSON array must be {"caseTypeId":30,"respondentType":"C"}

  # 200
  @samples
  Scenario: Put request for sample to create online cases for the specified sample id
    When I make the GET call to the caseservice for samples for sample id "25"
    Then the response status should be 200
    And the response should contain the field "sampleId" with an integer value of 25
    And the response should contain the field "name" with value "UNIVERSITY"
    And the response should contain the field "description" with value "university"
    And the response should contain the field "addressCriteria" with value "SAMPLE = UNIVERSITY"
    And the response should contain the field "survey" with value "2017 TEST"
    And the response should contain the field "sampleCaseTypes" with one element of the JSON array must be {"caseTypeId":31,"respondentType":"CI"}

  # 404
  @samples
  Scenario: Get request for samples for a non sample id
    When I make the GET call to the caseservice for samples for sample id "101"
    Then the response status should be 404
    And the response should contain the field "error.code" with value "RESOURCE_NOT_FOUND"
    And the response should contain the field "error.message" with value "Sample not found for id 101"
    And the response should contain the field "error.timestamp"

  # PUT /samples/{sampleId}
  # 200
  @samples
  Scenario: Put request for sample to create online cases for the specified sample id
    When I make the PUT call to the caseservice sample endpoint for sample id "1" for area "REGION" code "E12000005"
    Then the response status should be 200
    And the response should contain the field "sampleId" with an integer value of 1
    And the response should contain the field "name" with value "C2EO332E"
    And the response should contain the field "description" with value "component 2 no sex id online first 332 england"
    And the response should contain the field "addressCriteria" with value "SAMPLE = C2EO332E"
    And the response should contain the field "survey" with value "2017 TEST"
    And the response should contain the field "sampleCaseTypes" with one element of the JSON array must be {"caseTypeId":17,"respondentType":"H"}
    And the response should contain the field "sampleCaseTypes" with one element of the JSON array must be {"caseTypeId":26,"respondentType":"HI"}

  # 200
  @samples
  Scenario: Put request for sample to create online cases for the specified sample id
    When I make the PUT call to the caseservice sample endpoint for sample id "2" for area "REGION" code "E12000005"
    Then the response status should be 200
    And the response should contain the field "sampleId" with an integer value of 2
    And the response should contain the field "name" with value "C2EO331BIE"
    And the response should contain the field "description" with value "component 2 no sex id online first 331 england beavioural insights"
    And the response should contain the field "addressCriteria" with value "SAMPLE = C2EO331BIE"
    And the response should contain the field "survey" with value "2017 TEST"
    And the response should contain the field "sampleCaseTypes" with one element of the JSON array must be {"caseTypeId":18,"respondentType":"H"}
    And the response should contain the field "sampleCaseTypes" with one element of the JSON array must be {"caseTypeId":26,"respondentType":"HI"}

  # 200
  @samples
  Scenario: Put request for sample to create online cases for the specified sample id
    When I make the PUT call to the caseservice sample endpoint for sample id "3" for area "REGION" code "E12000005"
    Then the response status should be 200
    And the response should contain the field "sampleId" with an integer value of 3
    And the response should contain the field "name" with value "C2EO332BIE"
    And the response should contain the field "description" with value "component 2 no sex id online first 332 england beavioural insights"
    And the response should contain the field "addressCriteria" with value "SAMPLE = C2EO332BIE"
    And the response should contain the field "survey" with value "2017 TEST"
    And the response should contain the field "sampleCaseTypes" with one element of the JSON array must be {"caseTypeId":19,"respondentType":"H"}
    And the response should contain the field "sampleCaseTypes" with one element of the JSON array must be {"caseTypeId":26,"respondentType":"HI"}

  # 200
  @samples
  Scenario: Put request for sample to create online cases for the specified sample id
    When I make the PUT call to the caseservice sample endpoint for sample id "4" for area "REGION" code "E12000005"
    Then the response status should be 200
    And the response should contain the field "sampleId" with an integer value of 4
    And the response should contain the field "name" with value "C2EO300E"
    And the response should contain the field "description" with value "component 2 no sex id online first 300 england"
    And the response should contain the field "addressCriteria" with value "SAMPLE = C2EO300E"
    And the response should contain the field "survey" with value "2017 TEST"
    And the response should contain the field "sampleCaseTypes" with one element of the JSON array must be {"caseTypeId":20,"respondentType":"H"}
    And the response should contain the field "sampleCaseTypes" with one element of the JSON array must be {"caseTypeId":26,"respondentType":"HI"}

  # 200
  @samples
  Scenario: Put request for sample to create online cases for the specified sample id
    When I make the PUT call to the caseservice sample endpoint for sample id "5" for area "REGION" code "E12000005"
    Then the response status should be 200
    And the response should contain the field "sampleId" with an integer value of 5
    And the response should contain the field "name" with value "C2EO200E"
    And the response should contain the field "description" with value "component 2 no sex id online first 200 england"
    And the response should contain the field "addressCriteria" with value "SAMPLE = C2EO200E"
    And the response should contain the field "survey" with value "2017 TEST"
    And the response should contain the field "sampleCaseTypes" with one element of the JSON array must be {"caseTypeId":21,"respondentType":"H"}
    And the response should contain the field "sampleCaseTypes" with one element of the JSON array must be {"caseTypeId":26,"respondentType":"HI"}

  # 200
  @samples
  Scenario: Put request for sample to create online cases for the specified sample id
    When I make the PUT call to the caseservice sample endpoint for sample id "6" for area "REGION" code "E12000005"
    Then the response status should be 200
    And the response should contain the field "sampleId" with an integer value of 6
    And the response should contain the field "name" with value "C2EO331ADE"
    And the response should contain the field "description" with value "component 2 no sex id online first 331 assisted digital england"
    And the response should contain the field "addressCriteria" with value "SAMPLE = C2EO331ADE"
    And the response should contain the field "survey" with value "2017 TEST"
    And the response should contain the field "sampleCaseTypes" with one element of the JSON array must be {"caseTypeId":22,"respondentType":"H"}
    And the response should contain the field "sampleCaseTypes" with one element of the JSON array must be {"caseTypeId":26,"respondentType":"HI"}

  # 200
  @samples
  Scenario: Put request for sample to create online cases for the specified sample id
    When I make the PUT call to the caseservice sample endpoint for sample id "7" for area "REGION" code "E12000005"
    Then the response status should be 200
    And the response should contain the field "sampleId" with an integer value of 7
    And the response should contain the field "name" with value "C1SO331D4E"
    And the response should contain the field "description" with value "component 1 sex id online first 331 day 4 england"
    And the response should contain the field "addressCriteria" with value "SAMPLE = C1SO331D4E"
    And the response should contain the field "survey" with value "2017 TEST"
    And the response should contain the field "sampleCaseTypes" with one element of the JSON array must be {"caseTypeId":1,"respondentType":"H"}
    And the response should contain the field "sampleCaseTypes" with one element of the JSON array must be {"caseTypeId":23,"respondentType":"HI"}

  # 200
  @samples
  Scenario: Put request for sample to create online cases for the specified sample id
    When I make the PUT call to the caseservice sample endpoint for sample id "8" for area "REGION" code "E12000005"
    Then the response status should be 200
    And the response should contain the field "sampleId" with an integer value of 8
    And the response should contain the field "name" with value "C1SO331D4W"
    And the response should contain the field "description" with value "component 1 sex id online first 331 day 4 wales"
    And the response should contain the field "addressCriteria" with value "SAMPLE = C1SO331D4W"
    And the response should contain the field "survey" with value "2017 TEST"
    And the response should contain the field "sampleCaseTypes" with one element of the JSON array must be {"caseTypeId":2,"respondentType":"H"}

  # 200
  @samples
  Scenario: Put request for sample to create online cases for the specified sample id
    When I make the PUT call to the caseservice sample endpoint for sample id "9" for area "REGION" code "E12000005"
    Then the response status should be 200
    And the response should contain the field "sampleId" with an integer value of 9
    And the response should contain the field "name" with value "C1SO331D10E"
    And the response should contain the field "description" with value "component 1 sex id online first 331 day 10 england"
    And the response should contain the field "addressCriteria" with value "SAMPLE = C1SO331D10E"
    And the response should contain the field "survey" with value "2017 TEST"
    And the response should contain the field "sampleCaseTypes" with one element of the JSON array must be {"caseTypeId":3,"respondentType":"H"}
    And the response should contain the field "sampleCaseTypes" with one element of the JSON array must be {"caseTypeId":23,"respondentType":"HI"}

  # 200
  @samples
  Scenario: Put request for sample to create online cases for the specified sample id
    When I make the PUT call to the caseservice sample endpoint for sample id "10" for area "REGION" code "E12000005"
    Then the response status should be 200
    And the response should contain the field "sampleId" with an integer value of 10
    And the response should contain the field "name" with value "C1SO331D10W"
    And the response should contain the field "description" with value "component 1 sex id online first 331 day 10 wales"
    And the response should contain the field "addressCriteria" with value "SAMPLE = C1SO331D10W"
    And the response should contain the field "survey" with value "2017 TEST"
    And the response should contain the field "sampleCaseTypes" with one element of the JSON array must be {"caseTypeId":4,"respondentType":"H"}

  # 200
  @samples
  Scenario: Put request for sample to create online cases for the specified sample id
    When I make the PUT call to the caseservice sample endpoint for sample id "11" for area "REGION" code "E12000005"
    Then the response status should be 200
    And the response should contain the field "sampleId" with an integer value of 11
    And the response should contain the field "name" with value "C1EO331D4E"
    And the response should contain the field "description" with value "component 1 no sex id online first 331 day 4 england"
    And the response should contain the field "addressCriteria" with value "SAMPLE = C1EO331D4E"
    And the response should contain the field "survey" with value "2017 TEST"
    And the response should contain the field "sampleCaseTypes" with one element of the JSON array must be {"caseTypeId":5,"respondentType":"H"}
    And the response should contain the field "sampleCaseTypes" with one element of the JSON array must be {"caseTypeId":25,"respondentType":"HI"}

  # 200
  @samples
  Scenario: Put request for sample to create online cases for the specified sample id
    When I make the PUT call to the caseservice sample endpoint for sample id "12" for area "REGION" code "E12000005"
    Then the response status should be 200
    And the response should contain the field "sampleId" with an integer value of 12
    And the response should contain the field "name" with value "C1EO331D4W"
    And the response should contain the field "description" with value "component 1 no sex id online first 331 day 4 wales"
    And the response should contain the field "addressCriteria" with value "SAMPLE = C1EO331D4W"
    And the response should contain the field "survey" with value "2017 TEST"
    And the response should contain the field "sampleCaseTypes" with one element of the JSON array must be {"caseTypeId":6,"respondentType":"H"}

  # 200
  @samples
  Scenario: Put request for sample to create online cases for the specified sample id
    When I make the PUT call to the caseservice sample endpoint for sample id "13" for area "REGION" code "E12000005"
    Then the response status should be 200
    And the response should contain the field "sampleId" with an integer value of 13
    And the response should contain the field "name" with value "C1EO331D10E"
    And the response should contain the field "description" with value "component 1 no sex id online first 331 day 10 england"
    And the response should contain the field "addressCriteria" with value "SAMPLE = C1EO331D10E"
    And the response should contain the field "survey" with value "2017 TEST"
    And the response should contain the field "sampleCaseTypes" with one element of the JSON array must be {"caseTypeId":7,"respondentType":"H"}
    And the response should contain the field "sampleCaseTypes" with one element of the JSON array must be {"caseTypeId":25,"respondentType":"HI"}

  # 200
  @samples
  Scenario: Put request for sample to create online cases for the specified sample id
    When I make the PUT call to the caseservice sample endpoint for sample id "14" for area "REGION" code "E12000005"
    Then the response status should be 200
    And the response should contain the field "sampleId" with an integer value of 14
    And the response should contain the field "name" with value "C1EO331D10W"
    And the response should contain the field "description" with value "component 1 no sex id online first 331 day 10 wales"
    And the response should contain the field "addressCriteria" with value "SAMPLE = C1EO331D10W"
    And the response should contain the field "survey" with value "2017 TEST"
    And the response should contain the field "sampleCaseTypes" with one element of the JSON array must be {"caseTypeId":8,"respondentType":"H"}

  # 200
  @samples
  Scenario: Put request for sample to create online cases for the specified sample id
    When I make the PUT call to the caseservice sample endpoint for sample id "15" for area "REGION" code "E12000005"
    Then the response status should be 200
    And the response should contain the field "sampleId" with an integer value of 15
    And the response should contain the field "name" with value "C2SP331E"
    And the response should contain the field "description" with value "component 2 sex id paper first 331 england"
    And the response should contain the field "addressCriteria" with value "SAMPLE = C2SP331E"
    And the response should contain the field "survey" with value "2017 TEST"
    And the response should contain the field "sampleCaseTypes" with one element of the JSON array must be {"caseTypeId":9,"respondentType":"H"}
    And the response should contain the field "sampleCaseTypes" with one element of the JSON array must be {"caseTypeId":23,"respondentType":"HI"}

  # 200
  @samples
  Scenario: Put request for sample to create online cases for the specified sample id
    When I make the PUT call to the caseservice sample endpoint for sample id "16" for area "REGION" code "E12000005"
    Then the response status should be 200
    And the response should contain the field "sampleId" with an integer value of 16
    And the response should contain the field "name" with value "C2SP331W"
    And the response should contain the field "description" with value "component 2 sex id paper first 331 wales"
    And the response should contain the field "addressCriteria" with value "SAMPLE = C2SP331W"
    And the response should contain the field "survey" with value "2017 TEST"
    And the response should contain the field "sampleCaseTypes" with one element of the JSON array must be {"caseTypeId":10,"respondentType":"H"}

  # 200
  @samples
  Scenario: Put request for sample to create online cases for the specified sample id
    When I make the PUT call to the caseservice sample endpoint for sample id "17" for area "REGION" code "E12000005"
    Then the response status should be 200
    And the response should contain the field "sampleId" with an integer value of 17
    And the response should contain the field "name" with value "C2EP331E"
    And the response should contain the field "description" with value "component 2 no sex id paper first 331 england"
    And the response should contain the field "addressCriteria" with value "SAMPLE = C2EP331E"
    And the response should contain the field "survey" with value "2017 TEST"
    And the response should contain the field "sampleCaseTypes" with one element of the JSON array must be {"caseTypeId":11,"respondentType":"H"}
    And the response should contain the field "sampleCaseTypes" with one element of the JSON array must be {"caseTypeId":25,"respondentType":"HI"}

  # 200
  @samples
  Scenario: Put request for sample to create online cases for the specified sample id
    When I make the PUT call to the caseservice sample endpoint for sample id "18" for area "REGION" code "E12000005"
    Then the response status should be 200
    And the response should contain the field "sampleId" with an integer value of 18
    And the response should contain the field "name" with value "C2EP331W"
    And the response should contain the field "description" with value "component 2 no sex id paper first 331 wales"
    And the response should contain the field "addressCriteria" with value "SAMPLE = C2EP331W"
    And the response should contain the field "survey" with value "2017 TEST"
    And the response should contain the field "sampleCaseTypes" with one element of the JSON array must be {"caseTypeId":12,"respondentType":"H"}

  # 200
  @samples
  Scenario: Put request for sample to create online cases for the specified sample id
    When I make the PUT call to the caseservice sample endpoint for sample id "19" for area "REGION" code "E12000005"
    Then the response status should be 200
    And the response should contain the field "sampleId" with an integer value of 19
    And the response should contain the field "name" with value "C2SO331E"
    And the response should contain the field "description" with value "component 2 sex id online first 331 england"
    And the response should contain the field "addressCriteria" with value "SAMPLE = C2SO331E"
    And the response should contain the field "survey" with value "2017 TEST"
    And the response should contain the field "sampleCaseTypes" with one element of the JSON array must be {"caseTypeId":13,"respondentType":"H"}
    And the response should contain the field "sampleCaseTypes" with one element of the JSON array must be {"caseTypeId":23,"respondentType":"HI"}

  # 200
  @samples
  Scenario: Put request for sample to create online cases for the specified sample id
    When I make the PUT call to the caseservice sample endpoint for sample id "20" for area "REGION" code "E12000005"
    Then the response status should be 200
    And the response should contain the field "sampleId" with an integer value of 20
    And the response should contain the field "name" with value "C2SO331W"
    And the response should contain the field "description" with value "component 2 sex id online first 331 wales"
    And the response should contain the field "addressCriteria" with value "SAMPLE = C2SO331W"
    And the response should contain the field "survey" with value "2017 TEST"
    And the response should contain the field "sampleCaseTypes" with one element of the JSON array must be {"caseTypeId":14,"respondentType":"H"}

  # 200
  @samples
  Scenario: Put request for sample to create online cases for the specified sample id
    When I make the PUT call to the caseservice sample endpoint for sample id "21" for area "REGION" code "E12000005"
    Then the response status should be 200
    And the response should contain the field "sampleId" with an integer value of 21
    And the response should contain the field "name" with value "C2EO331E"
    And the response should contain the field "description" with value "component 2 no sex id online first 331 england"
    And the response should contain the field "addressCriteria" with value "SAMPLE = C2EO331E"
    And the response should contain the field "survey" with value "2017 TEST"
    And the response should contain the field "sampleCaseTypes" with one element of the JSON array must be {"caseTypeId":15,"respondentType":"H"}
    And the response should contain the field "sampleCaseTypes" with one element of the JSON array must be {"caseTypeId":25,"respondentType":"HI"}

  # 200
  @samples
  Scenario: Put request for sample to create online cases for the specified sample id
    When I make the PUT call to the caseservice sample endpoint for sample id "22" for area "REGION" code "E12000005"
    Then the response status should be 200
    And the response should contain the field "sampleId" with an integer value of 22
    And the response should contain the field "name" with value "C2EO331W"
    And the response should contain the field "description" with value "component 2 no sex id online first 331 wales"
    And the response should contain the field "addressCriteria" with value "SAMPLE = C2EO331W"
    And the response should contain the field "survey" with value "2017 TEST"
    And the response should contain the field "sampleCaseTypes" with one element of the JSON array must be {"caseTypeId":16,"respondentType":"H"}

  # 200
  @samples
  Scenario: Put request for sample to create online cases for the specified sample id
    When I make the PUT call to the caseservice sample endpoint for sample id "23" for area "REGION" code "E12000006"
    Then the response status should be 200
    And the response should contain the field "sampleId" with an integer value of 23
    And the response should contain the field "name" with value "SHOUSING"
    And the response should contain the field "description" with value "sheltered housing"
    And the response should contain the field "addressCriteria" with value "SAMPLE = SHOUSING"
    And the response should contain the field "survey" with value "2017 TEST"
    And the response should contain the field "sampleCaseTypes" with one element of the JSON array must be {"caseTypeId":29,"respondentType":"H"}
    And the response should contain the field "sampleCaseTypes" with one element of the JSON array must be {"caseTypeId":26,"respondentType":"HI"}

  # 200
  @samples
  Scenario: Put request for sample to create online cases for the specified sample id
    When I make the PUT call to the caseservice sample endpoint for sample id "24" for area "REGION" code "E12000006"
    Then the response status should be 200
    And the response should contain the field "sampleId" with an integer value of 24
    And the response should contain the field "name" with value "HOTEL"
    And the response should contain the field "description" with value "hotel"
    And the response should contain the field "addressCriteria" with value "SAMPLE = HOTEL"
    And the response should contain the field "survey" with value "2017 TEST"
    And the response should contain the field "sampleCaseTypes" with one element of the JSON array must be {"caseTypeId":30,"respondentType":"C"}

  # 200
  @samples
  Scenario: Put request for sample to create online cases for the specified sample id
    When I make the PUT call to the caseservice sample endpoint for sample id "25" for area "REGION" code "E12000003"
    Then the response status should be 200
    And the response should contain the field "sampleId" with an integer value of 25
    And the response should contain the field "name" with value "UNIVERSITY"
    And the response should contain the field "description" with value "university"
    And the response should contain the field "addressCriteria" with value "SAMPLE = UNIVERSITY"
    And the response should contain the field "survey" with value "2017 TEST"
    And the response should contain the field "sampleCaseTypes" with one element of the JSON array must be {"caseTypeId":31,"respondentType":"CI"}

  # 404
  @samples
  Scenario: Get request for samples for a non sample id
    When I make the PUT call to the caseservice sample endpoint for sample id "101" for area "REGION" code "E12000005"
    Then the response status should be 404
    And the response should contain the field "error.code" with value "RESOURCE_NOT_FOUND"
    And the response should contain the field "error.message" with value "Sample not found for id 101"
    And the response should contain the field "error.timestamp"

  @generateIAC @samples
  Scenario: Each case has a unique IAC assigned to it
    and in Actionable state
    and action service has been notified case has been created

    Given after a delay of 400 seconds
    When check "casesvc.case" distinct records in DB equal 2044 for "iac" where "state = 'ACTIONABLE'"
    And check "casesvc.case" records in DB equal 10 for "state = 'ACTIONABLE' AND casetypeid = 1"
    And check "casesvc.case" records in DB equal 10 for "state = 'ACTIONABLE' AND casetypeid = 2"
    And check "casesvc.case" records in DB equal 10 for "state = 'ACTIONABLE' AND casetypeid = 3"
    And check "casesvc.case" records in DB equal 10 for "state = 'ACTIONABLE' AND casetypeid = 4"
    And check "casesvc.case" records in DB equal 10 for "state = 'ACTIONABLE' AND casetypeid = 5"
    And check "casesvc.case" records in DB equal 10 for "state = 'ACTIONABLE' AND casetypeid = 6"
    And check "casesvc.case" records in DB equal 10 for "state = 'ACTIONABLE' AND casetypeid = 7"
    And check "casesvc.case" records in DB equal 10 for "state = 'ACTIONABLE' AND casetypeid = 8"
    And check "casesvc.case" records in DB equal 10 for "state = 'ACTIONABLE' AND casetypeid = 9"
    And check "casesvc.case" records in DB equal 10 for "state = 'ACTIONABLE' AND casetypeid = 10"
    And check "casesvc.case" records in DB equal 10 for "state = 'ACTIONABLE' AND casetypeid = 11"
    And check "casesvc.case" records in DB equal 10 for "state = 'ACTIONABLE' AND casetypeid = 12"
    And check "casesvc.case" records in DB equal 10 for "state = 'ACTIONABLE' AND casetypeid = 13"
    And check "casesvc.case" records in DB equal 10 for "state = 'ACTIONABLE' AND casetypeid = 14"
    And check "casesvc.case" records in DB equal 10 for "state = 'ACTIONABLE' AND casetypeid = 15"
    And check "casesvc.case" records in DB equal 10 for "state = 'ACTIONABLE' AND casetypeid = 16"
    And check "casesvc.case" records in DB equal 10 for "state = 'ACTIONABLE' AND casetypeid = 17"
    And check "casesvc.case" records in DB equal 10 for "state = 'ACTIONABLE' AND casetypeid = 18"
    And check "casesvc.case" records in DB equal 10 for "state = 'ACTIONABLE' AND casetypeid = 19"
    And check "casesvc.case" records in DB equal 10 for "state = 'ACTIONABLE' AND casetypeid = 21"
    And check "casesvc.case" records in DB equal 10 for "state = 'ACTIONABLE' AND casetypeid = 22"
    And check "casesvc.case" records in DB equal 10 for "state = 'ACTIONABLE' AND casetypeid = 29"
    And check "casesvc.case" records in DB equal 10 for "state = 'ACTIONABLE' AND casetypeid = 30"
    And check "casesvc.case" records in DB equal 1804 for "state = 'ACTIONABLE' AND casetypeid = 31"
    And check "action.case" records in DB equal 2044
    And check "casesvc.case" records in DB equal 2044
