# Author: Stephen Goddard 06/04/2017
#
# Keywords Summary: This feature confirms that teh sample service will ingest files as specified in the scenarios
#
# Feature: List of survey xsd scenarios: test business survey file ingestion
#																				 test business survey invalid file ingestion
#																				 test census survey file ingestion
#																				 test census survey invalid file ingestion
#																				 test social survey file ingestion
#																				 test social survey invalid file ingestion
#
# Feature Tags: @samplesvc
#								@sampleIngest
#
# Scenario Tags: @businessIngest
#								 @censusIngest
#								 @socialIngest

@sampleSvc @sampleIngest
Feature: Tests the file ingestion of samples for each survey area

	# File ingest Tests -----

  @businessIngest
  Scenario: Title of your scenario
    Given clean sftp folders of all previous ingestions for "business" surveys
    And the exit status should be 0
    When for the "business" survey move the "valid" file to trigger ingestion
    Then for the "business" survey confirm processed file "business-survey-full*.xml.processed" is found
    And the exit status should be 0

	@businessIngest
  Scenario: Title of your scenario
    Given clean sftp folders of all previous ingestions for "business" surveys
    And the exit status should be 0
    When for the "business" survey move the "invalid" file to trigger ingestion
    Then for the "business" survey confirm processed file "business-survey-invalid*.error" is found
    And the exit status should be 0
    Then get the contents of the file from "Documents/errors/" where the filename begins "business-survey-invalid"
		And the exit status should be 0
		And and the contents should contain "org.springframework.integration.xml.AggregatedXmlMessageValidationException: Multiple causes:"
		And and the contents should contain "cvc-complex-type.2.4.a: Invalid content was found starting with element 'sampleUnitType'. One of '{treatmentRef}' is expected."
		And and the contents should contain "cvc-enumeration-valid: Value 'Invalid' is not facet-valid with respect to enumeration '[H, HI, C, CI, B, BI]'. It must be a value from the enumeration."
		And and the contents should contain "cvc-type.3.1.3: The value 'Invalid' of element 'sampleUnitType' is not valid."

  @censusIngest
  Scenario: Title of your scenario
    Given clean sftp folders of all previous ingestions for "census" surveys
    And the exit status should be 0
    When for the "census" survey move the "valid" file to trigger ingestion
    Then for the "census" survey confirm processed file "census-survey-full*.xml.processed" is found
    And the exit status should be 0

	@censusIngest
  Scenario: Title of your scenario
    Given clean sftp folders of all previous ingestions for "census" surveys
    And the exit status should be 0
    When for the "census" survey move the "invalid" file to trigger ingestion
    Then for the "census" survey confirm processed file "census-survey-invalid*.error" is found
    And the exit status should be 0
    Then get the contents of the file from "Documents/errors/" where the filename begins "census-survey-invalid"
		And the exit status should be 0
		And and the contents should contain "org.springframework.integration.xml.AggregatedXmlMessageValidationException: Multiple causes:"
		And and the contents should contain "cvc-complex-type.2.4.a: Invalid content was found starting with element 'sampleUnitType'. One of '{treatmentRef}' is expected."
		And and the contents should contain "cvc-enumeration-valid: Value 'Invalid' is not facet-valid with respect to enumeration '[H, HI, C, CI, B, BI]'. It must be a value from the enumeration."
		And and the contents should contain "cvc-type.3.1.3: The value 'Invalid' of element 'sampleUnitType' is not valid."

  @socialIngest
  Scenario: Title of your scenario
    Given clean sftp folders of all previous ingestions for "social" surveys
    And the exit status should be 0
    When for the "social" survey move the "valid" file to trigger ingestion
    Then for the "social" survey confirm processed file "social-survey-full*.xml.processed" is found
    And the exit status should be 0

  @socialIngest
  Scenario: Title of your scenario
    Given clean sftp folders of all previous ingestions for "social" surveys
    And the exit status should be 0
    When for the "social" survey move the "invalid" file to trigger ingestion
    Then for the "social" survey confirm processed file "social-survey-invalid*.error" is found
    And the exit status should be 0
    Then get the contents of the file from "Documents/errors/" where the filename begins "social-survey-invalid"
		And the exit status should be 0
		And and the contents should contain "org.springframework.integration.xml.AggregatedXmlMessageValidationException: Multiple causes:"
		And and the contents should contain "cvc-complex-type.2.4.a: Invalid content was found starting with element 'sampleUnitType'. One of '{treatmentRef}' is expected."
		And and the contents should contain "cvc-enumeration-valid: Value 'Invalid' is not facet-valid with respect to enumeration '[H, HI, C, CI, B, BI]'. It must be a value from the enumeration."
		And and the contents should contain "cvc-type.3.1.3: The value 'Invalid' of element 'sampleUnitType' is not valid."
