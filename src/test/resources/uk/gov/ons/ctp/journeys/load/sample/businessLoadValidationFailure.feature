# Author: Stephen Goddard 25/05/2017
#
# Keywords Summary: This feature confirms that the sample service will fail load validation for business samples. The journey is specified in:
#                   https://collaborate2.ons.gov.uk/confluence/pages/viewpage.action?pageId=5190519
#                   https://collaborate2.ons.gov.uk/confluence/display/SDC/Test+Scenario+1+-+Load+Sample
#
# Feature: List of fail load validation for business sample scenarios: pre test clean of sample service
#                                                                      test fail validation for business sample file (Journey steps: 1.1, 1.2.1, 1.2.2)
#                                                                      test sample DB state - nothing loaded (Journey steps: 1.5)
#
# Feature Tags: @loadSample
#               @businessLoadFail
#
@loadSample @businessLoadFail
Feature: Tests the load validation failure for business sample

  # Pre Test Environment Set Up -----

  Scenario: Reset sample service database to pre test condition
    When for the "samplesvc" run the "samplereset.sql" postgres DB script
    Then the samplesvc database has been reset


  # Business Sample Load Tests -----

  Scenario: Test fail validation for business sample file (Journey steps: 1.1, 1.2.1, 1.2.2) 
    When I make the POST call to the sample "bres" service endpoint for the "BSD" survey "invalid" file to trigger ingestion
    When the response status should be 400
    Then the response should contain the field "error"

  Scenario: Test sample DB state - nothing loaded (Journey steps: 1.5)
    When check "sample.samplesummary" records in DB equal 0 for "statefk = 'ACTIVE'"
    Then check "sample.sampleunit" records in DB equal 0 for "statefk = 'INIT' AND samplesummaryfk = 1"
