# Author: Chris Hardman 15/12/2016
# Keywords Summary : Create communal establishment Samples
#
# Feature: List of Samples scenarios: Clean DB to pre test condition
#																			Put samples by sample id (Repeated for all CE samples)
#																			Test cases created within UI
#
# Feature Tags: @caseCE
#
# Scenario Tags: @samplesCleanEnvironment
#								 @samples
#								 @caseCEcheck
@other @caseCE
Feature: Create communal establishment Samples

  # Clean Environment -----
  @samplesCleanEnvironment
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

  # creates  samples
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

  Scenario: Put request for sample to create online cases for the specified sample id
    When I make the PUT call to the caseservice sample endpoint for sample id "24" for area "REGION" code "E12000006"
    Then the response status should be 200
    And the response should contain the field "sampleId" with an integer value of 24
    And the response should contain the field "name" with value "HOTEL"
    And the response should contain the field "description" with value "hotel"
    And the response should contain the field "addressCriteria" with value "SAMPLE = HOTEL"
    And the response should contain the field "survey" with value "2017 TEST"
    And the response should contain the field "sampleCaseTypes" with one element of the JSON array must be {"caseTypeId":30,"respondentType":"C"}

  Scenario: Put request for sample to create online cases for the specified sample id
    When I make the PUT call to the caseservice sample endpoint for sample id "25" for area "REGION" code "E12000003"
    Then the response status should be 200
    And the response should contain the field "sampleId" with an integer value of 25
    And the response should contain the field "name" with value "UNIVERSITY"
    And the response should contain the field "description" with value "university"
    And the response should contain the field "addressCriteria" with value "SAMPLE = UNIVERSITY"
    And the response should contain the field "survey" with value "2017 TEST"
    And the response should contain the field "sampleCaseTypes" with one element of the JSON array must be {"caseTypeId":31,"respondentType":"CI"}


  # checks the cases can be reviewed within the UI
  @caseCECheck
  Scenario: check that the CE appear within the UI with the corresponding question set.
    Given the user login as "CSO" using "Chrome"
    When the user gets the addresses for postcode "BA20 1DG"
    And selects case for address "FLAT 1 PARK LODGE"
    And navigates to the cases page for case "1"
    Then reviews and validates information "QuestionSet"
    And the user logs out

  @caseCECheck
  Scenario: check that the CE appear within the UI with the corresponding question set.
    Given the user login as "CSO" using "Chrome"
    When the user gets the addresses for postcode "FY4 1AY"
    And selects case for address "469-477"
    And navigates to the cases page for case "17"
    Then reviews and validates information "QuestionSet"
    And the user logs out

  @caseCECheck
  Scenario: check that the CE appear within the UI with the corresponding question set.
    Given the user login as "CSO" using "Chrome"
    When the user gets the addresses for postcode "S1 4GU"
    And selects case for address "FLAT B1"
    And navigates to the cases page for case "54"
    Then reviews and validates information "QuestionSet"
    And the user logs out
