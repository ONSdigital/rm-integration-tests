# Author: Stephen Goddard 03/04/2017
#
# Keywords Summary: This feature file contains the scenario tests for the survey xsd
#
# Feature: List of survey xsd scenarios: xsd validation without failure
#																				 xsd validation with failure
#
# Feature Tags: @sampleSvc
#								@sampleXsd
#
# Scenario Tags: @xsdValidation
#								 @businessXsdInvalid
#								 @censusXsdInvalid
#								 @socialXsdInvalid

@sampleSvc @sampleXsd
Feature: Test the sample service survey xsd

  @xsdValidation
  Scenario Outline: Title of your scenario outline
    Given xsd is available "<xsdName>"
    When xml is available "<xmlName>"
    Then Validate
    And the total number of warnings was <warnings>
    And the total number of errors was <errors>

    Examples: 
      | xsdName             			 | xmlName                     | warnings | errors |
      | business-survey-sample.xsd | business-survey-min.xml     |        0 |      0 |
      | business-survey-sample.xsd | business-survey-full.xml    |        0 |      0 |
      | business-survey-sample.xsd | business-survey-invalid.xml |        0 |      3 |
      | census-survey-sample.xsd   | census-survey-min.xml       |        0 |      0 |
      | census-survey-sample.xsd   | census-survey-full.xml      |        0 |      0 |
      | census-survey-sample.xsd   | census-survey-invalid.xml   |        0 |      3 |
      | social-survey-sample.xsd   | social-survey-min.xml       |        0 |      0 |
      | social-survey-sample.xsd   | social-survey-full.xml      |        0 |      0 |
      | social-survey-sample.xsd   | social-survey-invalid.xml   |        0 |      3 |

  @businessXsdInvalid
  Scenario: Title of your scenario outline
    Given xsd is available "business-survey-sample.xsd"
    When xml is available "business-survey-invalid.xml"
    Then Validate
    And the total number of warnings was 0
    And the total number of errors was 3
    And the error list should contain "Invalid content was found starting with element"
    And the error list should contain "Value 'Invalid' is not facet-valid with respect to enumeration"
    And the error list should contain "The value 'Invalid' of element 'sampleUnitType' is not valid"

	@censusXsdInvalid
  Scenario: Title of your scenario outline
    Given xsd is available "census-survey-sample.xsd"
    When xml is available "census-survey-invalid.xml"
    Then Validate
    And the total number of warnings was 0
    And the total number of errors was 3
    And the error list should contain "Invalid content was found starting with element"
    And the error list should contain "Value 'Invalid' is not facet-valid with respect to enumeration"
    And the error list should contain "The value 'Invalid' of element 'sampleUnitType' is not valid"

  @socialXsdInvalid
  Scenario: Title of your scenario outline
    Given xsd is available "social-survey-sample.xsd"
    When xml is available "social-survey-invalid.xml"
    Then Validate
    And the total number of warnings was 0
    And the total number of errors was 3
    And the error list should contain "Invalid content was found starting with element"
    And the error list should contain "Value 'Invalid' is not facet-valid with respect to enumeration"
    And the error list should contain "The value 'Invalid' of element 'sampleUnitType' is not valid"
