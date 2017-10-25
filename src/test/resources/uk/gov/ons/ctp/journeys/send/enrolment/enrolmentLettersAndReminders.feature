# Author: Stephen Goddard 19/06/2017
#
# Keywords Summary: This feature confirms that the print files are generated as expected. The journey is specified in:
#                   https://collaborate2.ons.gov.uk/confluence/pages/viewpage.action?pageId=5190519
#                   https://collaborate2.ons.gov.uk/confluence/display/SDC/Test+Scenario+3+-+Send+Enrolment+Letters
#                   https://collaborate2.ons.gov.uk/confluence/display/SDC/Test+Scenario+4+-+Send+Enrolment+Reminder+Letters
#
# Feature: List of publish collection exercise scenarios: Pre test DB clean of sample service
#                                                         Pre test load of business sample file into sample service
#                                                         Pre test DB clean of collection exercise
#                                                         Pre test DB clean of case exercise
#                                                         Pre test DB clean of action exercise
#                                                         Pre test DB clean of actionexporter
#                                                         Pre test previous print file clean of actionexporter
#                                                         Generate cases
#                                                         Test case generation
#                                                         Test action case created
#                                                         Test enrolment letter action creation by change date offset and case event creation (Journey steps: 3.1, 3.2, 3.3, 3.4, 3.5, 3.7)
#                                                         Test print file generation and confirm contents (Journey steps: 3.6, 3.8)
#                                                         Pre test DB clean of actionexporter
#                                                         Pre test previous print file clean of actionexporter
#                                                         Test enrolment reminder letter (first) action creation by change date offset and case event creation (Journey steps: 4.1, 4.2, 4.3, 4.4, 4.5, 4.7)
#                                                         Test print file generation and confirm contents (Journey steps: 4.6, 4.8)
#                                                         Pre test DB clean of actionexporter
#                                                         Pre test previous print file clean of actionexporter
#                                                         Test enrolment reminder letter (second) action creation by change date offset and case event creation (Journey steps: 4.1, 4.2, 4.3, 4.4, 4.5, 4.7)
#                                                         Test print file generation and confirm contents (Journey steps: 4.6, 4.8)
#
# NOTE: Report not developed so not tested (Journey steps: 3.9, 4.9)
#
# Feature Tags: @sendEnrolement
#
@sendEnrolment
Feature: Tests the enrolment letter and reminder letters are sent

  # Pre Test Set Up

  # Pre Test Sample Service Environment Set Up -----

  Scenario: Reset sample service database to pre test condition
    When for the "samplesvc" run the "samplereset.sql" postgres DB script
    Then the samplesvc database has been reset

  Scenario: Load Business example survey
    Given clean sftp folders of all previous ingestions for "BSD" surveys
    And the sftp exit status should be "-1"
    When for the "BSD" survey move the "valid" file to trigger ingestion
    And the sftp exit status should be "-1"
    And after a delay of 50 seconds
    Then for the "BSD" survey confirm processed file "BSD-survey-full*.xml.processed" is found
    And the sftp exit status should be "-1"


  # Pre Test Collection Exercise Service Environment Set Up -----
  Scenario: Reset collection exercise service database to pre test condition
    When for the "collectionexercisesvc" run the "collectionexercisereset.sql" postgres DB script
    Then the collectionexercisesvc database has been reset


  # Pre Test Case Service Environment Set Up -----
  Scenario: Reset case service database to pre test condition
    When for the "casesvc" run the "casereset.sql" postgres DB script
    Then the casesvc database has been reset


  # Pre Test Action Service Environment Set Up -----
  Scenario: Reset action service database to pre test condition
    When for the "actionsvc" run the "actionreset.sql" postgres DB script
    Then the actionsvc database has been reset


  # Pre Test Action Exporter Environment Set Up -----
  Scenario: Reset actionexporter database to pre test condition
    When for the "actionexporter" run the "actionexporterreset.sql" postgres DB script
    Then the actionexporter database has been reset

  Scenario: Clean old print files from directory
    Given create test directory "previousTests" for "BSD"
    And the sftp exit status should be "-1"
    When move print files to "previousTests/" for "BSD"
    Then the sftp exit status should be "-1"


  # Generate Cases -----

  Scenario: Execute collection exercise by put request for specific business survey by exercise id
    Given I make the PUT call to the collection exercise endpoint for exercise id "14fb3e68-4dca-46db-bf49-04b84e07e77c"
    When the response status should be 200
    Then the response should contain the field "sampleUnitsTotal" with an integer value of 500

  Scenario: Test casesvc case DB state
    Given after a delay of 400 seconds
    When check "casesvc.case" records in DB equal 500 for "statefk = 'ACTIONABLE'"
    Then check "casesvc.case" distinct records in DB equal 500 for "iac" where "statefk = 'ACTIONABLE'"

  Scenario: Test actionsvc case DB state for actionplan 1
    Given after a delay of 60 seconds
    Then check "action.case" records in DB equal 497 for "actionplanfk = 1"
    And check "action.case" records in DB equal 3 for "actionplanfk = 2"


  # Journey Tests

  # Send Enrolment Letters -----
  Scenario: Test action creation by post request to create actions for specified action plan (Journey steps: 3.1, 3.2, 3.3, 3.4, 3.5, 3.7)
    Given the case start date is adjusted to trigger action plan
      | actionplanfk  | actionrulepk | actiontypefk | total |
      | 1             | 1            | 1            | 497   |
    When after a delay of 90 seconds
    Then check "action.action" records in DB
      | actionplanfk  | actionrulepk | actiontypefk | statefk   | total |
      | 1             | 1            | 1            | COMPLETED | 497   |
    And check "casesvc.caseevent" records in DB equal 497 for "description = 'Enrolment Invitation Letter'"

  Scenario: Test print file generation and confirm contents (Journey steps: 3.6, 3.8)
    Given after a delay of 90 seconds
    When get the contents of the print files where the filename begins "BSNOT" for "BSD"
    And the sftp exit status should be "-1"
    Then each line should contain an iac
    And the contents should contain ":null:null"
    And the contents should contain 497 lines

  # checks enrolment letter reports
  Scenario: Test report for print volumes (Test scenario PO3.03-6)
    Given the "test" user has logged in using "chrome"
    When the user navigates to the reports page and selects "print" reports
    When retrieves Print Volume reports table
#    Then checks values of print files rows counts matches value 497
#    When the user navigates to the reports page and selects "action" reports
#    When the user goes to view the most recent report
#    And  checks values of column number 2 against value "BRES Enrolment" and should appear 3 times
#    And  checks values of column number 7 against value "497" and should appear 3 times
#    When the user navigates to the reports page and selects "case" reports
#    When the user goes to view the most recent report
#    And  checks values of column number 4 against value "1" and should appear 500 times
#    When the user searches for case ref "49900000001"
#    Then the user looks at the events table to see the event "Enrolment Invitation Letter" appears in column 4 
    Then the user logs out


  # Reset Action Exporter Environment Set Up -----

  Scenario: Reset actionexporter database to pre test condition
    When for the "actionexporter" run the "actionexporterreset.sql" postgres DB script
    Then the actionexporter database has been reset

  Scenario: Clean old print files from directory
    Given create test directory "previousTests" for "BSD"
    And the sftp exit status should be "-1"
    When move print files to "previousTests/" for "BSD"
    Then the sftp exit status should be "-1"


  # Send Enrolment Reminder Letters (First) -----

  Scenario: Test action creation by post request to create actions for specified action plan (Journey steps: 4.1, 4.2, 4.3, 4.4, 4.5, 4.7)
    Given the case start date is adjusted to trigger action plan
      | actionplanfk  | actionrulepk | actiontypefk | total |
      | 1             | 2            | 2            | 497   |
    When after a delay of 90 seconds
    Then check "action.action" records in DB
      | actionplanfk  | actionrulepk | actiontypefk | statefk   | total |
      | 1             | 2            | 2            | COMPLETED | 497   |
    And check "casesvc.caseevent" records in DB equal 497 for "description = 'Enrolment Reminder Letter'"

  Scenario: Test print file generation and confirm contents (Journey steps: 4.6, 4.8)
    Given after a delay of 90 seconds
    When get the contents of the print files where the filename begins "BSREM" for "BSD"
    And the sftp exit status should be "-1"
    Then each line should contain an iac
    And the contents should contain ":null:null"
    And the contents should contain 497 lines

  # Report not developed so not tested (Journey steps: 4.9)
  Scenario: Test report for print volumes (Test scenario PO7.04-6)
    Given the "test" user has logged in using "chrome"
    When the user navigates to the reports page and selects "print" reports
    When retrieves Print Volume reports table
#    Then checks values of print files rows counts matches value 497
#    When the user navigates to the reports page and selects "action" reports
#    When the user goes to view the most recent report
#    And  checks values of column number 7 against value "497" and should appear 3 times
#    And  checks values of column number 2 contains value "BRES Enrolment" and should appear 3 times
#    When the user navigates to the reports page and selects "case" reports
#    When the user goes to view the most recent report
#    And  checks values of column number 5 against value "3" and should appear 497 times
#    When the user searches for case ref "49900000001"
#    Then the user looks at the events table to see the event "Enrolment Reminder Letter" appears in column 4
    Then the user logs out

  # Reset Action Exporter Environment Set Up -----

  Scenario: Reset actionexporter database to pre test condition
    When for the "actionexporter" run the "actionexporterreset.sql" postgres DB script
    Then the actionexporter database has been reset

  Scenario: Clean old print files from directory
    Given create test directory "previousTests" for "BSD"
    And the sftp exit status should be "-1"
    When move print files to "previousTests/" for "BSD"
    Then the sftp exit status should be "-1"


  # Send Enrolment Reminder Letters (Second) -----

  Scenario: Test action creation by post request to create actions for specified action plan (Journey steps: 4.1, 4.2, 4.3, 4.4, 4.5, 4.7)
    Given the case start date is adjusted to trigger action plan
      | actionplanfk  | actionrulepk | actiontypefk | total |
      | 1             | 3            | 2            | 497   |
    When after a delay of 90 seconds
    Then check "action.action" records in DB
      | actionplanfk  | actionrulepk | actiontypefk | statefk   | total |
      | 1             | 3            | 2            | COMPLETED | 497   |
    And check "casesvc.caseevent" records in DB equal 994 for "description = 'Enrolment Reminder Letter'"

  Scenario: Test print file generation and confirm contents (Journey steps: 4.6, 4.8)
    Given after a delay of 90 seconds
    When get the contents of the print files where the filename begins "BSREM" for "BSD"
    And the sftp exit status should be "-1"
    Then each line should contain an iac
    And the contents should contain ":null:null"
    And the contents should contain 497 lines
    
  # checks reminder enroment letter reports  
  Scenario: Test report for print volumes (Test scenario PO7.04-6)
    Given the "test" user has logged in using "chrome"
    When the user navigates to the reports page and selects "print" reports
    When retrieves Print Volume reports table
#    Then checks values of print files rows counts matches value 497
#    When the user navigates to the reports page and selects "action" reports
#    When the user goes to view the most recent report
#    And  checks values of column number 7 against value "497" and should appear 3 times
#    And  checks values of column number 2 contains value "BRES Enrolment" and should appear 3 times
#    When the user navigates to the reports page and selects "case" reports
#    When the user goes to view the most recent report
#    And  checks values of column number 5 against value "3" and should appear 497 times
#    When the user searches for case ref "49900000001"
#    Then the user looks at the events table to see the event "Enrolment Reminder Letter" appears in column 4
    Then the user logs out
  