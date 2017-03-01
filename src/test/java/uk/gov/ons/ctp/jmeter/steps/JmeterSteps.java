package uk.gov.ons.ctp.jmeter.steps;

import static org.junit.Assert.assertTrue;

import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.Properties;

import cucumber.api.DataTable;
import cucumber.api.java.en.Given;
import cucumber.api.java.en.Then;
import cucumber.api.java.en.When;
import uk.gov.ons.ctp.util.JmeterResponseAware;

/**
 * Created by Stephen Goddard on 27/01/17.
 */
public class JmeterSteps {
  private static final int ONLINE_THREADS = 11;
  private static final int ONLINE_DURATION = 12;
  private static final int ONLINE_MIN_CASEREF = 13;
  private static final int ONLINE_MAX_CASEREF = 14;
  private static final int ONLINE_LT_CASEREF = 15;
  private static final int ONLINE_GT_CASEREF = 16;

  private static final int PAPER_THREADS = 21;
  private static final int PAPER_DURATION = 22;
  private static final int PAPER_MIN_CASEREF = 23;
  private static final int PAPER_MAX_CASEREF = 24;
  private static final int PAPER_APPEND_FILE = 27;
  private static final int PAPER_MIN_DELAY = 28;
  private static final int PAPER_MAX_DELAY = 29;

  private static final int EVENT_THREADS = 31;
  private static final int EVENT_DURATION = 32;
  private static final int EVENT_MIN_DELAY = 38;
  private static final int EVENT_MAX_DELAY = 39;

  private static final String REPORT_SUMMARY = "jmeter.reporters.Summariser";

  private final JmeterResponseAware responseAware;

  /**
   * Constructor
   *
   * @param jmeterResponseAware jmeter runner
   */
  public JmeterSteps(JmeterResponseAware jmeterResponseAware) {
    this.responseAware = jmeterResponseAware;
  }

  /**
   * Invoke Jmeter setup test plan to prepare environment
   *
   * @param threads number of threads to run
   * @param loops number of loops to run
   * @throws Throwable pass the exception
   */
  @Given("^I run test setup using jmeter with (\\d+) threads and looping (\\d+)$")
  public void i_run_test_setup_using_jmeter_with_threads_and_looping(String threads, String loops) throws Throwable {
    Properties jmeterProps = new Properties();
    jmeterProps.setProperty("threads", threads);
    jmeterProps.setProperty("loops", loops);

    responseAware.invokeEnvironmentSetupTestPlan(jmeterProps);
  }

  /**
   * Invoke Jmeter stability test plan
   *
   * @param data to be used to run test plan
   * @throws Throwable pass the exception
   */
  @Given("^I run stability plan using jmeter$")
  public void i_run_stability_plan_using_jmeter(DataTable data) throws Throwable {
    List<String> properties = data.asList(String.class);

    Properties jmeterProps = new Properties();
    jmeterProps.setProperty("onlineThreads", properties.get(ONLINE_THREADS));
    jmeterProps.setProperty("onlineDuration", properties.get(ONLINE_DURATION));
    jmeterProps.setProperty("onlineMinCase", properties.get(ONLINE_MIN_CASEREF));
    jmeterProps.setProperty("onlineMaxCase", properties.get(ONLINE_MAX_CASEREF));
    jmeterProps.setProperty("onlineLessThan", properties.get(ONLINE_LT_CASEREF));
    jmeterProps.setProperty("onlineGreaterThan", properties.get(ONLINE_GT_CASEREF));

    jmeterProps.setProperty("paperThreads", properties.get(PAPER_THREADS));
    jmeterProps.setProperty("paperDuration", properties.get(PAPER_DURATION));
    jmeterProps.setProperty("paperMinCase", properties.get(PAPER_MIN_CASEREF));
    jmeterProps.setProperty("paperMaxCase", properties.get(PAPER_MAX_CASEREF));
    jmeterProps.setProperty("appendToFile", properties.get(PAPER_APPEND_FILE));
    jmeterProps.setProperty("paperMinDelay", properties.get(PAPER_MIN_DELAY));
    jmeterProps.setProperty("paperMaxDelay", properties.get(PAPER_MAX_DELAY));

    jmeterProps.setProperty("eventsThreads", properties.get(EVENT_THREADS));
    jmeterProps.setProperty("eventsDuration", properties.get(EVENT_DURATION));
    jmeterProps.setProperty("eventsMinDelay", properties.get(EVENT_MIN_DELAY));
    jmeterProps.setProperty("eventsMaxDelay", properties.get(EVENT_MAX_DELAY));

    responseAware.invokeSimulatedResponsesTestPlan(jmeterProps);
  }

  /**
   * Check script response for errors
   *
   * @param logFile Jmeter log file where test summary is found
   * @throws Throwable pass the exception
   */
  @When("^there are no reported errors in \"(.*?)\"$")
  public void there_are_no_reported_errors_in(String logFile) throws Throwable {
    List<String> summary = getJmeterReportSummary(logFile, REPORT_SUMMARY);

    for (String line: summary) {
      assertTrue("Jmeter run includes errors: " + line, line.contains("Err:     0 (0.00%)"));
    }
  }

  /**
   * Check script response that the average time is below specified time
   *
   * @param aveTime average time in milliseconds test must be below
   * @param logFile Jmeter log file where test summary is found
   * @throws Throwable pass the exception
   */
  @Then("^the average time per request is (\\d+) in \"(.*?)\"$")
  public void the_average_time_per_request_is_in(int aveTime, String logFile) throws Throwable {
    List<String> summary = getJmeterReportSummary(logFile, REPORT_SUMMARY);

    for (String line: summary) {
      int average = getMillisecondsFromString(line, "Avg:", "Min:");
      assertTrue("Average time per request to high: " + average, average < aveTime);
    }
  }

  /**
   * Check script response that the minimum time is below specified time
   *
   * @param minTime minimum time in milliseconds test must be below
   * @param logFile Jmeter log file where test summary is found
   * @throws Throwable pass the exception
   */
  @Then("^the min time per request is (\\d+) in \"(.*?)\"$")
  public void the_min_time_per_request_is_in(int minTime, String logFile) throws Throwable {
    List<String> summary = getJmeterReportSummary(logFile, REPORT_SUMMARY);

    for (String line: summary) {
      int minimum = getMillisecondsFromString(line, "Min:", "Max:");
      assertTrue("Minimum time per request to high: " + minimum, minimum < minTime);
    }
  }

  /**
   * Check script response that the maximum time is below specified time
   *
   * @param maxTime maximum time in milliseconds test must be below
   * @param logFile Jmeter log file where test summary is found
   * @throws Throwable pass the exception
   */
  @Then("^the max time per request is (\\d+) in \"(.*?)\"$")
  public void the_max_time_per_request_is_in(int maxTime, String logFile) throws Throwable {
    List<String> summary = getJmeterReportSummary(logFile, REPORT_SUMMARY);

    for (String line: summary) {
      int maximum = getMillisecondsFromString(line, "Min:", "Max:");
      assertTrue("Maximum time per request to high: " + maximum, maximum < maxTime);
    }
  }

  /**
   * Extract summary report from file
   *
   * @param logFile Jmeter log file where test summary is found
   * @param reportSummariser string to identify summary lines from file
   * @return List of lines in file which make up summary
   */
  private List<String> getJmeterReportSummary(String logFile, String reportSummariser) {
    List<String> reportSummary = new ArrayList<String>();
    BufferedReader br = null;

    try {
      String lineStr;

      br = new BufferedReader(new FileReader(logFile));

      while ((lineStr = br.readLine()) != null) {
        if (lineStr.contains(reportSummariser)) {
          reportSummary.add(lineStr);
        }
      }
    } catch (IOException ioe) {
      System.out.println(ioe.getMessage());
    } finally {
      try {
        if (br != null) {
          br.close();
        }
      } catch (IOException ioex) {
        System.out.println(ioex.getMessage());
      }
    }

    return reportSummary;
  }

  /**
   * Extract milliseconds from jmeter summary report
   *
   * @param line string to extract milliseconds from
   * @param startStr string which marks the beginning of the milliseconds
   * @param endStr string which marks the end of the milliseconds
   * @return milliseconds as an integer
   */
  private int getMillisecondsFromString(String line, String startStr, String endStr) {
    int start = line.indexOf(startStr);
    int end = line.indexOf(endStr);
    String subLine = line.substring(start + 4, end);

    return Integer.parseInt(subLine.trim());
  }
}
