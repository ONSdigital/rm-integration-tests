package uk.gov.ons.ctp.ui.rm.ro.steps;


import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertTrue;

import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.List;

import cucumber.api.java.en.Given;
import cucumber.api.java.en.Then;
import cucumber.api.java.en.When;
import uk.gov.ons.ctp.ui.rm.ro.util.UIResponseAware;

/**
 * Created by Stephen Goddard on 01/08/17.
 */
public class UiTestSteps {
  private final UIResponseAware responseAware;

  
  String caseRefRetrieved;
  /**
   * Constructor
   *
   * @param uiResponseAware ui runner
   */
  public UiTestSteps(UIResponseAware uiResponseAware) {
    this.responseAware = uiResponseAware;
  }

  @Given("^the \"(.*?)\" user has logged in using \"(.*?)\"$")
  public void the_user_has_logged_in_using(String user, String browser) throws Throwable {
    responseAware.invokeUILogin(user, browser);
  }

  @Then("^the user logs out$")
  public void the_user_logs_out() throws Throwable {
    responseAware.invokeLogout();
    responseAware.closeWebDriver();
  }

  @When("^the user searches for case ref \"(.*?)\"$")
  public void the_user_searches_for_case_ref(String reportUnit) throws Throwable {
	  responseAware.searchReportingUnit(reportUnit);
  }
  
  @When("^the user searches for case ref from case report$")
  public void the_user_searches_for_case_ref_from_case_report() throws Throwable {
	  responseAware.searchReportingUnit(caseRefRetrieved);
  }
  
  @When("^the user looks at the events table to see the event \"(.*?)\" appears in column (\\d+)$")
  public void the_user_looks_at_the_events_table_to_check_the_event_appears_in_column(String event, int column) throws Throwable {
	  String result = responseAware.checkCaseEventsForCase(event, column);
	  assertEquals(result, event);
  }
  
  @When("^the user navigates to the reports page and selects \"(.*?)\" reports$")
  public void the_user_navigates_to_the_reports_page_and_selects_reports(String report) throws Throwable {
    responseAware.invokeReportSelection(report);
  }
  
  @When("^the user goes to view the most recent report$")
  public void the_user_goes_to_view_the_most_recent_report() throws Throwable {
    responseAware.viewReport();
  }
  
  @When("^checks value for column (\\d+) and row (\\d+) with value \"(.*?)\"$")
  public void checks_action_status_for_column_name_with_value(int column, int row, String value )throws Throwable{
	  String reportValue = responseAware.checksSpeficValueFromReport(column, row);
	  assertEquals(value,reportValue);
	  
  }
  
  @Then("^checks values of column number (\\d+) against value \"(.*?)\" and should appear (\\d+) times$")
  public void checks_values_of_column_number_against_value_and_should_appear_times(int column, String value, int number) throws Throwable {
    int count = responseAware.checksColumnValues(column, value);
    assertEquals(count,number);
  }
  
  @Then("^checks values of column number (\\d+) against value \"(.*?)\" and should appear (\\d+) times and returns sample ref$")
  public void checks_values_of_column_number_against_value_and_should_appear_times_and_returns_sample_ref(int column, String value, int number) throws Throwable {
	    List<String> result = responseAware.checksColumnValuesReturnsSampleRef(column, value);
	    caseRefRetrieved = result.get(0);
	    assertEquals(result.get(1), value);
  }

  
  /**
   * Verifies the heading appears on the table
   *
   * @param heading to be found in table headings
   * @throws Throwable pass the exception
   */
  @When("^the table should contain the headings \"(.*?)\"")
  public void the_table_should_contain_the_headings(String heading) throws Throwable {
    List<String> result = responseAware.invokeGetReportHeadings();
    assertTrue("Heading not found: " + result, result.contains(heading));
  }

  /**
   * Verifies the empty table message is displayed
   *
   * @param msg to be found on page
   * @throws Throwable pass the exception
   */
  @When("^the report emtpty message is displayed \"(.*?)\"$")
  public void the_report_emtpty_message_is_displayed(String msg) throws Throwable {
    String result = responseAware.invokeGetReportMessage();
    assertTrue("Message not found: " + result, result.equals(msg));
  }

  /**
   * Verifies the value for a row entry is as expected
   *
   * @param rowName item in table to found
   * @param value to be used to verify result
   * @throws Throwable pass the exception
   */
  @Then("^the table should contain \"(.*?)\" with the value of \"(.*?)\"$")
  public void the_table_should_contain_with_the_value_of(String rowName, String value) throws Throwable {
    String result = responseAware.invokeGetValueForRowname(rowName);
    assertTrue("Value found is invalid: " + result, result.equals(value));
  }

  /**
   * Check that report for specified date exists
   *
   * @throws Throwable pass the exception
   */
  @When("^the report for todays date should be present$")
  public void the_report_for_todays_date_should_be_present() throws Throwable {
    String reportDate = responseAware.invokeGetReportDate();
    Date today = Calendar.getInstance().getTime();
    SimpleDateFormat sdf = new SimpleDateFormat("EEEE, dd MMM yyyy");
    assertTrue("Report date doesn't match", reportDate.startsWith(sdf.format(today)));
  }

  /**
   * Validates the report types
   *
   * @param type report type
   * @throws Throwable pass the exception
   */
  @Then("^validates the report types shown \"(.*?)\"$")
  public void validates_the_report_types_shown(String type) throws Throwable {
    List<String> result = responseAware.invokeValidateOnReportTypes();
    assertTrue("Invalid Report type found: " + result, result.contains(type));
  }

  /**
   * Validates the report types count
   *
   * @param size of report types
   * @throws Throwable pass the exception
   */
  @Then("^the number of report types found is (\\d+)$")
  public void the_number_of_report_types_found_is(int size) throws Throwable {
    int result = responseAware.invokeGetReportTypeCount();
    assertTrue("Report type Count not valid: " + result, result == size);
  }

  /**
   * Navigates to the page for link
   *
   * @param link to click
   * @throws Throwable pass the exception
   */
  @When("^the user navigates to the \"(.*?)\" page$")
  public void the_user_navigates_to_the_page(String link) throws Throwable {
    responseAware.invokeclickReportLink(link);
  }

  /**
   * Verifies correct message is displayed
   *
   * @param msg to be validated
   * @throws Throwable pass the exception
   */
  @Then("^the user gets the verification message \"(.*?)\"")
  public void the_user_gets_the_verification_message(String msg) throws Throwable {
    String result = responseAware.invokeGetReportsMessage();
    assertTrue("Report message not valid: " + result, result.equals(msg));
  }

  /**
   * Click the view report link to navigate to the report details
   *
   * @throws Throwable pass the exception
   */
  @When("^the user navigates to the report details page$")
  public void the_user_navigates_to_the_report_details_page() throws Throwable {
    responseAware.invokeClickReportViewLink();
  }
  
}
