#Author: Christopher Hardman 24/2/17
#
# Keywords Summary : Run Jmeter to run through downloading of the MI reports
#
# Feature: List of scenarios: downlaod Mi reports
#
# Feature Tag: @downLoadMIReport
#              @reportMI
#
# Scenario Tags: @downloadMIReport
@downloadMIReport @reportMI
Feature: Report view contains correct data

  @downloadMIReport
  Scenario: Download MI report
    Then call the "casesvc.insert_helpline_report_into_report()" function
    Then after a delay of 20 seconds
    Given the user login as "Report" using "Chrome"
    Then gets MI reports download link for "HL_METRICS"
    Given I run MIReport jmeter with 1 threads and looping 1
	  When there are no reported errors in "./jmeter.log"
    Given get the contents of local file from "/tmp" where the filename begins "MI_Report.html"
    And the contents of the file should equal "./JMeter/test_files" where the filename begins "MI_Report_Test.html"
    Then remove file from "/tmp/RM_Report.html"
