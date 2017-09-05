package uk.gov.ons.ctp.ui.rm.ro.steps;

import cucumber.api.java.en.Given;
import cucumber.api.java.en.Then;
import cucumber.api.java.en.When;
import uk.gov.ons.ctp.ui.rm.ro.util.UIResponseAware;

/**
 * Created by Stephen Goddard on 01/08/17.
 */
public class UiTestSteps {
  private final UIResponseAware responseAware;

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
  
  @Then("^the user looks at the events table to see the event \"(.*?)\" appears$")
  public void the_user_looks_at_the_events_table_to_check_the_event_appears(String event) throws Throwable {
	  responseAware.checkCaseEventsForCase(event);
  }
  
  @When("^the user navigates to the reports page and selects \"(.*?)\" reports$")
  public void the_user_navigates_to_the_reports_page_and_selects_reports(String report) throws Throwable {
    responseAware.invokeReportSelection(report);
  }
  
  @When("^the user goes to view the most recent report$")
  public void the_user_goes_to_view_the_most_recent_report() throws Throwable {
    responseAware.viewReport();
  }
  
  @Then("^checks case event for column name \"(.*?)\" with value \"(.*?)\"$")
  public void checks_case_event_for_column_name_with_value(String field, String value) throws Throwable {
    responseAware.viewCaseEvents(field, value);
  }
  
  @Then("^checks sample unit for column name \"(.*?)\" with value \"(.*?)\"$")
  public void checks_sample_unit_for_column_name_with_value(String field, String value) throws Throwable {
    responseAware.viewSampleUnit(field, value);
  }
  
  @Then("^checks print volume for column name \"(.*?)\" with value \"(.*?)\"$")
  public void checks_print_volume_for_column_name_with_value(String field, String value) throws Throwable {
    responseAware.viewPrintVolume(field, value);
  }
  
  @Then("^checks action status for column name \"(.*?)\" with value \"(.*?)\"$")
  public void checks_action_status_for_column_name_with_value(String field, String value) throws Throwable {
    responseAware.viewActionStatus(field, value);
  }
  
  @Then("^checks values of column number \"(.*?)\" against value \"(.*?)\" and should appear \"(.*?)\" times$")
  public void checks_values_of_column_number_against_value (int column, String value, int number) throws Throwable {
    responseAware.checksColumnValues(column, value, number);
  }
}
