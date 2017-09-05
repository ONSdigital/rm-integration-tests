# Author: Stephen Goddard 25/05/2017
#
# Keywords Summary: This feature confirms that the sample service will load business samples. The journey is specified in:
#                   https://collaborate2.ons.gov.uk/confluence/pages/viewpage.action?pageId=5190519
#                   https://collaborate2.ons.gov.uk/confluence/display/SDC/Test+Scenario+1+-+Load+Sample
#
# Feature: List of load business sample scenarios: pre test clean of sample service
#                                                  test load of business sample file (Journey steps: 1.1, 1.2, 1.3, 1.4)
#                                                  test sample DB state (Journey steps: 1.5)
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
    Given clean sftp folders of all previous ingestions for "BSD" surveys 
    And the sftp exit status should be "-1"
    When for the "BSD" survey move the "valid" file to trigger ingestion 
    And the sftp exit status should be "-1"
    And after a delay of 60 seconds 
    Then for the "BSD" survey confirm processed file "BSD-survey-full*.xml.processed" is found 
    And the sftp exit status should be "-1"
  
  Scenario: Test sample DB state (Journey steps: 1.5)
    Given after a delay of 30 seconds
    When check "sample.samplesummary" records in DB equal 1 for "statefk = 'ACTIVE' AND surveyref = '221'"
    Then check "sample.sampleunit" records in DB equal 500 for "statefk = 'PERSISTED' AND samplesummaryfk = 1"

#  @businessLoadSample  
#  Scenario: Test service report viewed (Test scenario PO1)
#    Given the "test" user has logged in using "chrome"
#    Then permissions should be verified for user "test"
