# Author: Stephen Goddard 25/05/2017
#
# Keywords Summary: This feature confirms that the sample service will load census samples. The journey is specified in:
#                   https://collaborate2.ons.gov.uk/confluence/pages/viewpage.action?pageId=5190519
#                   https://collaborate2.ons.gov.uk/confluence/display/SDC/Test+Scenario+1+-+Load+Sample
#
# Feature: List of load census sample scenarios: pre test clean of sample service
#                                                test load of census sample file (Journey steps: 1.1, 1.2, 1.3, 1.4)
#                                                test sample DB state (Journey steps: 1.5)
#
# Feature Tags: @loadSample
#               @censusLoad
#
@loadSample @censusLoad
Feature: Tests the load of census sample

  # Pre Test Environment Set Up -----

  Scenario: Reset sample service database to pre test condition
    When for the "samplesvc" run the "samplereset.sql" postgres DB script
    Then the samplesvc database has been reset


  # Census Sample Load Tests -----

  Scenario: Test load of census sample file (Journey steps: 1.1, 1.2, 1.3, 1.4) 
    Given clean sftp folders of all previous ingestions for "census" surveys 
    And the sftp exit status should be "-1" 
    When for the "census" survey move the "valid" file to trigger ingestion 
    And the sftp exit status should be "-1" 
    And after a delay of 50 seconds 
    Then for the "census" survey confirm processed file "census-survey-full*.xml.processed" is found 
    And the sftp exit status should be "-1" 

  Scenario: Test sample DB state (Journey steps: 1.5)
    # Remains in INIT state as seed data/party svc does not work for Census
    When check "sample.samplesummary" records in DB equal 1 for "state = 'INIT' AND surveyref = 'CENSUS'"
    Then check "sample.sampleunit" records in DB equal 1 for "state = 'INIT' AND samplesummaryfk = 1"
    