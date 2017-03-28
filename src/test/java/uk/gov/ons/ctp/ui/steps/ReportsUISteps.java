package uk.gov.ons.ctp.ui.steps;

import static org.junit.Assert.assertTrue;

import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.List;

import cucumber.api.java.en.Then;
import cucumber.api.java.en.When;

import uk.gov.ons.ctp.ui.util.ReportsUIResponseAware;

/**
 * Created by Stephen Goddard on 23/03/17.
 */
public class ReportsUISteps {
  private final ReportsUIResponseAware responseAware;

  /**
   * Constructor
   *
   * @param uiResponseAware ui runner
   */
  public ReportsUISteps(ReportsUIResponseAware uiResponseAware) {
    this.responseAware = uiResponseAware;
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
