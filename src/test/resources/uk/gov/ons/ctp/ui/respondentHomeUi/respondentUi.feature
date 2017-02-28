# Author: Edward Stevens 17/11/16
# Keywords Summary : This feature tests valid and invalid IACs as well as the incorrect IAC limit
#
# Feature: List of scenarios:	Entering a valid Internet Access Code
#															Entering an invalid Internet Access Code
#															Exceeding number of permissable IAC attempts (currently 5) within a set time period.
#
# Feature Tag: @respondentHomeUi
#
# Scenario Tags: @iacTestSuccess
#                @iacTestIncorrect
#                @iacTestAuthenticationLimit
@respondentHomeUiIacTest
Feature: Test IAC input for Respondent Home UI

  @iacTestIncorrect
  Scenario Outline: 
    Given user navigates to RespondentHome using "Chrome"
    When I enter IAC1 as "<iac1>" and IAC2 as "<iac2>" and IAC3 as "<iac3>"
    Then result of verification should be "Unsuccessful"

    Examples: 
      | iac1 | iac2  | iac3 |
      | YXF5 | F87D  | HJ73 |
      | YXF  | F87D  | HJ73 |
      | YXF  | F8\\D | HJ!3 |

  @iacTestSuccess
  Scenario: 
    Given user navigates to RespondentHome using "Chrome"
    When I enter IAC1 as "YXF4" and IAC2 as "F87D" and IAC3 as "HJ73"
    Then result of verification should be "Successful"

  @iacTestAuthenticationLimit
  Scenario: iacTestAuthenticationLimit
    Given user navigates to RespondentHome using "Chrome"
    When I enter multiple IAC as "YXF5" "F87D" "HJ73"
    Then authentication limit should be reached
    Then result of verification should be "Limit Reached"
