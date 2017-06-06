# Author: Stephen Goddard 25/05/2017
#
# Keywords Summary: This feature confirms that the sample service will fail load validation for business samples. The journey is specified in:
#                   https://collaborate2.ons.gov.uk/confluence/pages/viewpage.action?pageId=5190519
#
# Feature: List of fail load validation for business sample scenarios: pre test clean of sample service
#                                                                      test fail validation for business sample file (Journey steps: 1.1, 1.2)
#                                                                      test sample DB state - nothing loaded (Journey steps: 1.5)
#
# Feature Tags: @loadSample
#
# Scenario Tags: @businessLoadFail
#
@loadSample @businessLoadFail
Feature: Tests the load validation failure for business sample

  # Pre Test Environment Set Up -----

  Scenario: Reset sample service database to pre test condition
    When for the "samplesvc" run the "samplereset.sql" postgres DB script
    Then the samplesvc database has been reset


  # Business Sample Load Tests -----

  Scenario: Test fail validation for business sample file (Journey steps: 1.1, 1.2) 
    Given clean sftp folders of all previous ingestions for "business" surveys 
    And the sftp exit status should be "-1" 
    When for the "business" survey move the "invalid" file to trigger ingestion 
    And after a delay of 5 seconds 
    Then for the "business" survey confirm processed file "business-survey-invalid*.error" is found 
    And the sftp exit status should be "-1" 
    Then for the "business" survey get the contents of the file "business-survey-invalid*error.txt" 
    And the sftp exit status should be "-1" 
    And and the contents should contain "org.springframework.integration.xml.AggregatedXmlMessageValidationException: Multiple causes:" 
    And and the contents should contain "cvc-complex-type.2.4.a: Invalid content was found starting with element 'sampleUnitType'. One of '{formType, line1}' is expected." 
    And and the contents should contain "cvc-enumeration-valid: Value 'Invalid' is not facet-valid with respect to enumeration '[H, HI, C, CI, B, BI]'. It must be a value from the enumeration." 
    And and the contents should contain "cvc-type.3.1.3: The value 'Invalid' of element 'sampleUnitType' is not valid." 

  Scenario: Test sample DB state - nothing loaded (Journey steps: 1.5)
    When check "sample.samplesummary" records in DB equal 0 for "state = 'ACTIVE' AND surveyref = 'BRES'"
    Then check "sample.sampleunit" records in DB equal 0 for "state = 'INIT' AND samplesummaryfk = 1"
