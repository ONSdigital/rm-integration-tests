# Author: Chris Hardman 18/11/2016
# Keywords Summary : This feature tests the inputs of the postcode
#										 Note: Assumption that the DB has been loaded with seed data.
#
# Feature: List of scenarios: Search for a valid HH postcode
#															Search for an invalid (format) postcode
#															Search for an invalid (out of area) postcode
#															Review all addresses associated to a postcode
#
# Feature Tag: @helplineUI
#							 @postcodeVerifcation

@helplineUI @postcodeVerifcation
Feature: Post Code Search & Address Selection

  Scenario Outline: Search for valid postcodes:
  		Testing format AA99 9AA, AA9 9AA, A99 9AA, A9 9AA with and without spaces
    Given the "Test" user has logged in using "Chrome"
    When the user gets the addresses for postcode "<foundPostcode>"
    Then the user gets verification addresses found
    And the user logs out
  Examples:
  	| foundPostcode |
  	| TF107BH       |
  	| TF10 7BH      |
  	| TF13BP        |
  	| TF1 3BP       |
  	| S103AP        |
  	| S10 3AP       |
  	| S14HL         |
  	| S1 4HL        |

  Scenario Outline: Search for valid postcode where addresses not found:
  		Testing format A9A 9AA, AA9A 9AA with and without spaces
    Given the "Test" user has logged in using "Chrome"
    When the user gets the addresses for postcode "<notFoundPostcode>"
    Then the user gets verification addresses not found
    And the user logs out
  Examples:
  	| notFoundPostcode |
  	| TF117BH          |
  	| TF11 7BH         |
  #	| S1S4HL           |
  #	| S1S 4HL          |
  #	| TF1T3BP          |
  #	| TF1T 3BP         |

  Scenario Outline: Search for a invalid postcodes:
    Given the "Test" user has logged in using "Chrome"
    When the user gets the addresses for postcode "<invalidPostcode>"
    Then the user gets verification of invalid postcode
    And the user logs out
  Examples:
  	| invalidPostcode |
  	| 117             |

# Valid format: A9 9AA, A99 9AA, AA9 9AA, AA99 9AA, A9A 9AA, AA9A 9AA

