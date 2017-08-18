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
  
  @When("^the user navigates to the reports page and selects \"(.*?)\" reports$")
  public void the_user_navigates_to_the_reports_page_and_selects_reports(String report) throws Throwable {
    responseAware.invokeReportSelection(report);
  }
}
