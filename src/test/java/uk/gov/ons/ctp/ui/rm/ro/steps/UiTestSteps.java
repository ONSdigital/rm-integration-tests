package uk.gov.ons.ctp.ui.rm.ro.steps;


import static org.junit.Assert.assertEquals;
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
}
