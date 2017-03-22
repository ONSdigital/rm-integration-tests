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

  Scenario: Search for a valid HH postcode
    Given the "Test" user has logged in using "Chrome"
    When the user gets the addresses for postcode "TF107BH"
    Then the user gets the verification for found addresses "true"
    And the user logs out

  Scenario: Search for an valid (format:space) postcode
    Given the "Test" user has logged in using "Chrome"
    When the user gets the addresses for postcode "TF10 7BH"
    Then the user gets the verification for found addresses "true"
    And the user logs out

  Scenario: Search for an invalid (out of area) postcode
    Given the "Test" user has logged in using "Chrome"
    When the user gets the addresses for postcode "TF117BH"
    Then the user gets the verification for found addresses "false"
    And the user logs out

  Scenario: Search for an invalid (format) postcode
    Given the "Test" user has logged in using "Chrome"
    When the user gets the addresses for postcode "117"
    Then the user gets the verification for found addresses "false"
    And the user logs out
