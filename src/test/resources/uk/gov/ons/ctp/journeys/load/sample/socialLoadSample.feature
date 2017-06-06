# Author: Stephen Goddard 25/05/2017
#
# Keywords Summary: This feature confirms that the sample service will load social samples. The journey is specified in:
#                   https://collaborate2.ons.gov.uk/confluence/pages/viewpage.action?pageId=5190519
#
# Feature: List of load social sample scenarios: pre test clean of sample service
#                                                test load of social sample file (Journey steps: 1.1, 1.2, 1.3, 1.4)
#                                                test sample DB state (Journey steps: 1.5)
#
# Feature Tags: @loadSample
#
# Scenario Tags: @socialLoad
#
@loadSample @socialLoad
Feature: Tests the load of census sample

  # Pre Test Environment Set Up -----

  Scenario: Reset sample service database to pre test condition
    When for the "samplesvc" run the "samplereset.sql" postgres DB script
    Then the samplesvc database has been reset


  # Social Sample Load Tests -----

  Scenario: Test load of social sample file (Journey steps: 1.1, 1.2, 1.3, 1.4)
    Given clean sftp folders of all previous ingestions for "social" surveys 
    And the sftp exit status should be "-1" 
    When for the "social" survey move the "valid" file to trigger ingestion 
    And the sftp exit status should be "-1" 
    And after a delay of 5 seconds 
    Then for the "social" survey confirm processed file "social-survey-full*.xml.processed" is found 
    And the sftp exit status should be "-1" 

  Scenario: Test sample DB state (Journey steps: 1.5)
    When check "sample.samplesummary" records in DB equal 1 for "state = 'ACTIVE' AND surveyref = 'SOCIAL'"
    Then check "sample.sampleunit" records in DB equal 1 for "state = 'INIT' AND samplesummaryfk = 1"
