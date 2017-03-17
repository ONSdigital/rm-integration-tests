# Author: Stephen Goddard 30/11/2016
# Keywords Summary : This feature file contains the scenario tests the follow up where reminder letters are sent.
#										 Detailed in: https://collaborate2.ons.gov.uk/confluence/pages/viewpage.action?pageId=3690875
#										 Note: Assumption that the DB has been loaded with seed data.
#
# Tasks Covered: CTPA-822 Produce Print Files from Default Action Plans
#								 CTPA-838 Integration with MoveIT and testing - Currently only tests file not MoveIT
#
# Feature: List of scenarios: Reset survey date to trigger initial print file
#															Clean print file directory
#															Clean DB to pre test condition
#															Create Sample - Action plan which has 3 reminder letters
#															Test Cases Created - max number of cases
#															Generate PQ print file
#															Adjust action case date to simulate the passing of time
#															Test UI for case events
#
# Feature Tags: @followUp
#								@reminderLetters
#
# Scenario Tags: @reminderAdjustSurveyDate
#								 @reminderPrintFiles
#								 @reminderCleanEnvironment
#								 @reminderSample
#								 @reminderCases
#								 @reminderInitialFile
#								 @reminderInitialUI
#								 @reminderLetter1Date
#								 @reminderLetter2Date
#								 @reminderLetter3Date
#								 @reminderLetter1File
#								 @reminderLetter2File
#								 @reminderLetter3File
#								 @reminderLettersUI

@followUp @reminderLetters
Feature: Test successfull follow up reminder letters

  # Clean Environment -----
  @reminderAdjustSurveyDate
  Scenario: Reset survey date
    When the survey start and is reset to 20 days ahead for "2017 Test"
    Then the survey end and is reset to 50 days ahead for "2017 Test"

  @reminderPrintFiles
  Scenario: Clean folder of previous print files by coping all existing files to /previousTests
    When create test directory "/var/actionexporter-sftp/previousTests/"
    And the exit status should be 0
    Then move print files from "/var/actionexporter-sftp/" to "/var/actionexporter-sftp/previousTests/"
    And the exit status should be 0

  @reminderCleanEnvironment
  Scenario: Clean DB to pre test condition
    When reset the postgres DB
    Then check "casesvc.case" records in DB equal 0
    And check "casesvc.caseevent" records in DB equal 0
    And check "casesvc.casegroup" records in DB equal 0
    And check "casesvc.contact" records in DB equal 0
    And check "casesvc.response" records in DB equal 0
    And check "casesvc.messagelog" records in DB equal 0
    And check "casesvc.unlinkedcasereceipt" records in DB equal 0
    And check "action.action" records in DB equal 0
    And check "action.actionplanjob" records in DB equal 0
    And check "action.case" records in DB equal 0
    And check "action.messagelog" records in DB equal 0
    And check "casesvc.caseeventidseq" sequence in DB equal 1
    And check "casesvc.caseidseq" sequence in DB equal 1
    And check "casesvc.casegroupidseq" sequence in DB equal 1
    And check "casesvc.caserefseq" sequence in DB equal 1000000000000001
    And check "casesvc.responseidseq" sequence in DB equal 1
    And check "casesvc.messageseq" sequence in DB equal 1
    And check "action.actionidseq" sequence in DB equal 1
    And check "action.actionplanjobseq" sequence in DB equal 1
    And check "action.messageseq" sequence in DB equal 1

  # Paper Sample Creation -----
  @reminderSample
  Scenario: Put request for sample to create paper cases for the specified sample id
    When I make the PUT call to the caseservice sample endpoint for sample id "15" for area "REGION" code "E12000005"
    Then the response status should be 200
    And the response should contain the field "name" with value "C2SP331E"
    And the response should contain the field "survey" with value "2017 TEST"
    And check "casesvc.caseevent" records in DB equal 10

  @reminderCases
  Scenario: Get request to case for highest expected case id
    Given after a delay of 20 seconds
    When I make the GET call to the caseservice cases endpoint for case "10"
    Then the response status should be 200
    And the response should contain the field "caseId" with an integer value of 10
    And the response should contain the field "caseGroupId" with an integer value of 10
    And the response should contain the field "caseRef" with value "1000000000000010"
    And the response should contain the field "state" with value "ACTIONABLE"
    And the response should contain the field "caseTypeId" with an integer value of 9
    And the response should contain the field "actionPlanMappingId" with an integer value of 9
    And the response should contain the field "createdDateTime"
    And the response should contain the field "createdBy" with value "SYSTEM"
    And the response should contain the field "iac"
    And the response should contain the field "responses" with one element of the JSON array must be []
    And the response should contain the field "contact" with a null value

  # Test Initial Print File Generation -----
  @reminderInitialFile
  Scenario: Test action plan has created paper questionnaire file for printer
    Given after a delay of 160 seconds
    Then get the contents of the file from "/var/actionexporter-sftp/" where the filename begins "H1S_2003"
    And the exit status should be 0
    When and each line should start with an iac
    And and the contents should contain "|1000000000000002||||||12 EMRAL RISE|DOTHILL|TELFORD|TF1 3LG"
    And and the contents should contain "|1000000000000009||||||19 EMRAL RISE|DOTHILL|TELFORD|TF1 3LG"
    And and the contents should contain "|1000000000000001||||||11 EMRAL RISE|DOTHILL|TELFORD|TF1 3LG"
    And and the contents should contain "|1000000000000008||||||18 EMRAL RISE|DOTHILL|TELFORD|TF1 3LG"
    And and the contents should contain "|1000000000000005||||||15 EMRAL RISE|DOTHILL|TELFORD|TF1 3LG"
    And and the contents should contain "|1000000000000010||||||20 EMRAL RISE|DOTHILL|TELFORD|TF1 3LG"
    And and the contents should contain "|1000000000000004||||||14 EMRAL RISE|DOTHILL|TELFORD|TF1 3LG"
    And and the contents should contain "|1000000000000007||||||17 EMRAL RISE|DOTHILL|TELFORD|TF1 3LG"
    And and the contents should contain "|1000000000000003||||||13 EMRAL RISE|DOTHILL|TELFORD|TF1 3LG"
    And and the contents should contain "|1000000000000006||||||16 EMRAL RISE|DOTHILL|TELFORD|TF1 3LG"

  @reminderInitialUI
  Scenario: Confirmed the UI reflects the online response receipt
    Given the "Test" user has logged in using "Chrome"
    Then the user gets the addresses for postcode "TF13LG"
    And selects case for address "11 EMRAL RISE"
    And the case state should be "ACTIONABLE"
    And navigates to the cases page for case "1"
    Then the case event description should be "Print household paper questionnaire (English with sexual ID)"
    And the user logs out

  # Reminder letter 1 -----
  # CTPA-822
  @reminderLetter1Date
  Scenario: Post request to actionplans to create jobs for specified action plan - reminder letter 1
    Given the case start date is adjusted to trigger action plan
      | actionPlanId | actiontypeid | total |
      |            5 |            5 |    10 |
    And after a delay of 90 seconds

  # Reminder letter 2 -----
  # CTPA-822
  @reminderLetter2Date
  Scenario: Post request to actionplans to create jobs for specified action plan - reminder letter 2
    Given the case start date is adjusted to trigger action plan
      | actionPlanId | actiontypeid | total |
      |            5 |            8 |    10 |
    And after a delay of 90 seconds

  # Reminder letter 3 -----
  # CTPA-822
  @reminderLetter3Date
  Scenario: Post request to actionplans to create jobs for specified action plan - reminder letter 3
    Given the case start date is adjusted to trigger action plan
      | actionPlanId | actiontypeid | total |
      |            5 |           11 |    10 |
    And after a delay of 400 seconds

  # CTPA-838
  @reminderLetter1File
  Scenario: Test action plan has created paper questionnaire file for printer
    Given after a delay of 90 seconds
    Then get the contents of the file from "/var/actionexporter-sftp/" where the filename begins "1RL1_0504"
    And the exit status should be 0
    When and each line should start with an iac
    And and the contents should contain "|1000000000000002||||||12 EMRAL RISE|DOTHILL|TELFORD|TF1 3LG"
    And and the contents should contain "|1000000000000009||||||19 EMRAL RISE|DOTHILL|TELFORD|TF1 3LG"
    And and the contents should contain "|1000000000000001||||||11 EMRAL RISE|DOTHILL|TELFORD|TF1 3LG"
    And and the contents should contain "|1000000000000008||||||18 EMRAL RISE|DOTHILL|TELFORD|TF1 3LG"
    And and the contents should contain "|1000000000000005||||||15 EMRAL RISE|DOTHILL|TELFORD|TF1 3LG"
    And and the contents should contain "|1000000000000010||||||20 EMRAL RISE|DOTHILL|TELFORD|TF1 3LG"
    And and the contents should contain "|1000000000000004||||||14 EMRAL RISE|DOTHILL|TELFORD|TF1 3LG"
    And and the contents should contain "|1000000000000007||||||17 EMRAL RISE|DOTHILL|TELFORD|TF1 3LG"
    And and the contents should contain "|1000000000000003||||||13 EMRAL RISE|DOTHILL|TELFORD|TF1 3LG"
    And and the contents should contain "|1000000000000006||||||16 EMRAL RISE|DOTHILL|TELFORD|TF1 3LG"

  @reminderLetter2File
  Scenario: Test action plan has created paper questionnaire file for printer
    Given after a delay of 90 seconds
    Then get the contents of the file from "/var/actionexporter-sftp/" where the filename begins "2RL1_1804"
    And the exit status should be 0
    When and each line should start with an iac
    And and the contents should contain "|1000000000000002||||||12 EMRAL RISE|DOTHILL|TELFORD|TF1 3LG"
    And and the contents should contain "|1000000000000009||||||19 EMRAL RISE|DOTHILL|TELFORD|TF1 3LG"
    And and the contents should contain "|1000000000000001||||||11 EMRAL RISE|DOTHILL|TELFORD|TF1 3LG"
    And and the contents should contain "|1000000000000008||||||18 EMRAL RISE|DOTHILL|TELFORD|TF1 3LG"
    And and the contents should contain "|1000000000000005||||||15 EMRAL RISE|DOTHILL|TELFORD|TF1 3LG"
    And and the contents should contain "|1000000000000010||||||20 EMRAL RISE|DOTHILL|TELFORD|TF1 3LG"
    And and the contents should contain "|1000000000000004||||||14 EMRAL RISE|DOTHILL|TELFORD|TF1 3LG"
    And and the contents should contain "|1000000000000007||||||17 EMRAL RISE|DOTHILL|TELFORD|TF1 3LG"
    And and the contents should contain "|1000000000000003||||||13 EMRAL RISE|DOTHILL|TELFORD|TF1 3LG"
    And and the contents should contain "|1000000000000006||||||16 EMRAL RISE|DOTHILL|TELFORD|TF1 3LG"

  @reminderLetter3File
  Scenario: Test action plan has created paper questionnaire file for printer
    Given after a delay of 90 seconds
    Then get the contents of the file from "/var/actionexporter-sftp/" where the filename begins "3RL1_2604"
    And the exit status should be 0
    When and each line should start with an iac
    And and the contents should contain "|1000000000000002||||||12 EMRAL RISE|DOTHILL|TELFORD|TF1 3LG"
    And and the contents should contain "|1000000000000009||||||19 EMRAL RISE|DOTHILL|TELFORD|TF1 3LG"
    And and the contents should contain "|1000000000000001||||||11 EMRAL RISE|DOTHILL|TELFORD|TF1 3LG"
    And and the contents should contain "|1000000000000008||||||18 EMRAL RISE|DOTHILL|TELFORD|TF1 3LG"
    And and the contents should contain "|1000000000000005||||||15 EMRAL RISE|DOTHILL|TELFORD|TF1 3LG"
    And and the contents should contain "|1000000000000010||||||20 EMRAL RISE|DOTHILL|TELFORD|TF1 3LG"
    And and the contents should contain "|1000000000000004||||||14 EMRAL RISE|DOTHILL|TELFORD|TF1 3LG"
    And and the contents should contain "|1000000000000007||||||17 EMRAL RISE|DOTHILL|TELFORD|TF1 3LG"
    And and the contents should contain "|1000000000000003||||||13 EMRAL RISE|DOTHILL|TELFORD|TF1 3LG"
    And and the contents should contain "|1000000000000006||||||16 EMRAL RISE|DOTHILL|TELFORD|TF1 3LG"

  @reminderLettersUI
  Scenario: Confirmed the UI reflects the online response receipt
    Given the "Test" user has logged in using "Chrome"
    Then the user gets the addresses for postcode "TF13LG"
    And selects case for address "11 EMRAL RISE"
    And the case state should be "ACTIONABLE"
    And navigates to the cases page for case "1"
    Then the case event description should contain "Print reminder letter 1 (English)"
    And the case event description should contain "Print reminder letter 2 (English)"
    And the case event description should contain "Print reminder letter 3 (English)"
    And the user logs out
