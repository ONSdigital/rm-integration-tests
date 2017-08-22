# Author: Stephen Goddard 25/05/2017
#
# Keywords Summary: This feature confirms that the sample service will fail load validation for census samples. The journey is specified in:
#                   https://collaborate2.ons.gov.uk/confluence/pages/viewpage.action?pageId=5190519
#                   https://collaborate2.ons.gov.uk/confluence/display/SDC/Test+Scenario+1+-+Load+Sample
#
# Feature: List of fail load validation for census sample scenarios: pre test clean of sample service
#                                                                    test fail validation for census sample file (Journey steps: 1.1, 1.2.1, 1.2.2)
#                                                                    test sample DB state - nothing loaded (Journey steps: 1.5)
#
# Feature Tags: @loadSample
#               @censusLoadFail
#
@loadSample @censusLoadFail
Feature: Tests the load validation failure for census sample

  # Pre Test Environment Set Up -----

  Scenario: Reset sample service database to pre test condition
    When for the "samplesvc" run the "samplereset.sql" postgres DB script
    Then the samplesvc database has been reset


  # Census Sample Load Tests -----

  Scenario: Test fail validation for census sample file (Journey steps: 1.1, 1.2.1, 1.2.2) 
    Given clean sftp folders of all previous ingestions for "CTP" surveys 
    And the sftp exit status should be "-1" 
    When for the "CTP" survey move the "invalid" file to trigger ingestion 
    And after a delay of 15 seconds 
    Then for the "CTP" survey confirm processed file "CTP-survey-invalid*.error" is found 
    And the sftp exit status should be "-1" 
    Then for the "CTP" survey get the contents of the file "CTP-survey-invalid*error.txt" 
    And the sftp exit status should be "-1" 
    And the contents should contain "org.springframework.integration.xml.AggregatedXmlMessageValidationException: Multiple causes:" 
    And the contents should contain "cvc-complex-type.2.4.a: Invalid content was found starting with element 'sampleUnitType'. One of '{formType}' is expected." 
    And the contents should contain "cvc-enumeration-valid: Value 'Invalid' is not facet-valid with respect to enumeration '[H, HI, C, CI, B, BI]'. It must be a value from the enumeration." 
    And the contents should contain "cvc-type.3.1.3: The value 'Invalid' of element 'sampleUnitType' is not valid."

  Scenario: Test sample DB state - nothing loaded (Journey steps: 1.5)
    When check "sample.samplesummary" records in DB equal 0 for "statefk = 'ACTIVE' AND surveyref = 'CENSUS'"
    Then check "sample.sampleunit" records in DB equal 0 for "statefk = 'INIT' AND samplesummaryfk = 1"
