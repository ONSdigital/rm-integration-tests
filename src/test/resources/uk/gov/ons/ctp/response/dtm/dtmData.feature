# Author:  Kieran Wardle 10/02/2017
#
# Keywords Summary : Test that the DTM data is returned correctly
# 
# Feature: List of scenarios: Clean DB to pre test condition
#					                    Get request for samples for sample id
#
# Feature Tag: @dtmData
#
# Scenario Tags: @samplesCleanEnvironment
#                @samples

@casesvc @dtmData
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

  @samples
  Scenario: Get request for samples for sample id
    When I make the GET call to the caseservice for samples for sample id "1001"
    Then the response status should be 200
    And the response should contain the field "sampleId" with an integer value of 1001
    And the response should contain the field "name" with value "DTMTESTH1"
    And the response should contain the field "description" with value "DTM test for H1"
    And the response should contain the field "addressCriteria" with value "SAMPLE = DTMTESTH1"
    And the response should contain the field "survey" with value "DTM TEST"
    And the response should contain the field "sampleCaseTypes" with one element of the JSON array must be {"caseTypeId":1001,"respondentType":"H"}

  @samples
  Scenario: Get request for samples for sample id
    When I make the GET call to the caseservice for samples for sample id "1002"
    Then the response status should be 200
    And the response should contain the field "sampleId" with an integer value of 1002
    And the response should contain the field "name" with value "DTMTESTH1S"
    And the response should contain the field "description" with value "DTM test for H1S"
    And the response should contain the field "addressCriteria" with value "SAMPLE = DTMTESTH1S"
    And the response should contain the field "survey" with value "DTM TEST"
    And the response should contain the field "sampleCaseTypes" with one element of the JSON array must be {"caseTypeId":1002,"respondentType":"H"}

  @samples
  Scenario: Get request for samples for sample id
    When I make the GET call to the caseservice for samples for sample id "1003"
    Then the response status should be 200
    And the response should contain the field "sampleId" with an integer value of 1003
    And the response should contain the field "name" with value "DTMTESTH2"
    And the response should contain the field "description" with value "DTM test for H2"
    And the response should contain the field "addressCriteria" with value "SAMPLE = DTMTESTH2"
    And the response should contain the field "survey" with value "DTM TEST"
    And the response should contain the field "sampleCaseTypes" with one element of the JSON array must be {"caseTypeId":1003,"respondentType":"H"}

  @samples
  Scenario: Get request for samples for sample id
    When I make the GET call to the caseservice for samples for sample id "1004"
    Then the response status should be 200
    And the response should contain the field "sampleId" with an integer value of 1004
    And the response should contain the field "name" with value "DTMTESTH2S"
    And the response should contain the field "description" with value "DTM test for H2S"
    And the response should contain the field "addressCriteria" with value "SAMPLE = DTMTESTH2S"
    And the response should contain the field "survey" with value "DTM TEST"
    And the response should contain the field "sampleCaseTypes" with one element of the JSON array must be {"caseTypeId":1004,"respondentType":"H"}

  @samples
  Scenario: Get request for samples for sample id
    When I make the GET call to the caseservice for samples for sample id "1005"
    Then the response status should be 200
    And the response should contain the field "sampleId" with an integer value of 1005
    And the response should contain the field "name" with value "DTMTESTSHOUSING"
    And the response should contain the field "description" with value "DTM test for SHOUSING"
    And the response should contain the field "addressCriteria" with value "SAMPLE = DTMTESTSHOUSING"
    And the response should contain the field "survey" with value "DTM TEST"
    And the response should contain the field "sampleCaseTypes" with one element of the JSON array must be {"caseTypeId":1005,"respondentType":"H"}

  @samples
  Scenario: Get request for samples for sample id
    When I make the GET call to the caseservice for samples for sample id "1006"
    Then the response status should be 200
    And the response should contain the field "sampleId" with an integer value of 1006
    And the response should contain the field "name" with value "DTMTESTUNI"
    And the response should contain the field "description" with value "DTM test for UNIVERSITY"
    And the response should contain the field "addressCriteria" with value "SAMPLE = DTMTESTUNI"
    And the response should contain the field "survey" with value "DTM TEST"
    And the response should contain the field "sampleCaseTypes" with one element of the JSON array must be {"caseTypeId":1006,"respondentType":"CI"}

  @samples
  Scenario: Get request for samples for sample id
    When I make the GET call to the caseservice for samples for sample id "1007"
    Then the response status should be 200
    And the response should contain the field "sampleId" with an integer value of 1007
    And the response should contain the field "name" with value "DTMTESTHOTEL"
    And the response should contain the field "description" with value "DTM test for HOTEL"
    And the response should contain the field "addressCriteria" with value "SAMPLE = DTMTESTHOTEL"
    And the response should contain the field "survey" with value "DTM TEST"
    And the response should contain the field "sampleCaseTypes" with one element of the JSON array must be {"caseTypeId":1007,"respondentType":"C"}
