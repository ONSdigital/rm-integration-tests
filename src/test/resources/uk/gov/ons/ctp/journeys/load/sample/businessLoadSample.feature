# Author: Stephen Goddard 25/05/2017
#
# Keywords Summary: This feature confirms that the sample service will load business samples. The journey is specified in:
#                   https://collaborate2.ons.gov.uk/confluence/pages/viewpage.action?pageId=5190519
#                   https://collaborate2.ons.gov.uk/confluence/display/SDC/Test+Scenario+1+-+Load+Sample
#
# Feature: List of load business sample scenarios: pre test clean of sample service
#                                                  test load of business sample file (Journey steps: 1.1, 1.2, 1.3, 1.4)
#                                                  test sample DB state (Journey steps: 1.5)
#                                                  test service report viewed (Test scenario PO1.10)
#
# Feature Tags: @loadSample
#               @businessLoad
#
@loadSample @businessLoad
Feature: Tests the load of business sample

  # Pre Test Environment Set Up -----

  Scenario: Reset sample service database to pre test condition
    When for the "samplesvc" run the "samplereset.sql" postgres DB script
    Then the samplesvc database has been reset

  # Business Sample Load Tests -----

  Scenario: Test load of business sample file (Journey steps: 1.1, 1.2, 1.3, 1.4)
    When I make the POST call to the sample "bres" service endpoint for the "BSD" survey "valid" file to trigger ingestion
    When the response status should be 201
    Then the response should contain the field "sampleSummaryPK" with an integer value of 1
    And after a delay of 70 seconds 
    Then resets the sample queue

  Scenario: Put repuest to sample service service links the sample summary to a collection exercise
    Given I retrieve From Sample DB the Sample Summary
    Given I make the PUT call to the collection exercise for id "14fb3e68-4dca-46db-bf49-04b84e07e77c" endpoint for sample summary id

  Scenario: Test sample DB state (Journey steps: 1.5)
    And after a delay of 70 seconds 
    When check "sample.samplesummary" records in DB equal 1 for "statefk = 'ACTIVE'"
    Then check "sample.sampleunit" records in DB equal 500 for "statefk = 'PERSISTED' AND samplesummaryfk = 1"

  Scenario: Test ui report viewed correct form type - total 500 (Test scenario PO1.10)
    Given the "test" user has logged in using "chrome"
    When the user navigates to the reports page and selects "sample" reports
    When the user goes to view the most recent report
    And  checks values of column number 2 against value "0015" and should appear 237 times
    And  checks values of column number 2 against value "0016" and should appear 252 times
    And  checks values of column number 2 against value "0017" and should appear 4 times
    And  checks values of column number 2 against value "0019" and should appear 7 times
    Then the user logs out

