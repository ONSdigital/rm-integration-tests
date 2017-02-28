package uk.gov.ons.ctp.respondenthomeui.steps;

import static org.junit.Assert.assertEquals;

import cucumber.api.java.en.Given;
import cucumber.api.java.en.Then;
import cucumber.api.java.en.When;
import uk.gov.ons.ctp.respondenthomeui.util.RespondentHomeUiResponseAware;

/**
 * Created by Edward Stevens on 17/11/16.
 */
public class RespondentHomeUiSteps {

  private RespondentHomeUiResponseAware responseAware;

  /**
   * Constructor
   *
   * @param respondentHomeUiResponseAware ui runner
   */
  public RespondentHomeUiSteps(RespondentHomeUiResponseAware respondentHomeUiResponseAware) {
    this.responseAware = respondentHomeUiResponseAware;
  }

  /**
   * Creates WebDriver and navigates to correct page
   *
   * @param browser defines browser in which to run tests
   *
   */
  @Given("^user navigates to RespondentHome using \"([^\"]*)\"$")
  public void user_navigates_to_respondent_home(String browser) {
    responseAware.invokeInitialNavigation(browser);
  }

  /**
   * Enters IAC (valid or invalid)
   *
   * @param iac1 is IAC (valid or invalid)
   * @param iac2 is IAC (valid or invalid)
   * @param iac3 is IAC (valid or invalid)
   */
  @When("^I enter IAC1 as \"([^\"]*)\" and IAC2 as \"([^\"]*)\" and IAC3 as \"([^\"]*)\"$")
  public void i_enter_iac1_as_and_iac2_as_and_iac3_as(String iac1, String iac2, String iac3) {
    responseAware.invokeIACEntry(iac1, iac2, iac3);
  }

  /**
   * Enters invalid IAC consecutively until limit is reached
   *
   * @throws InterruptedException pass the exception
   * @param iac1 is IAC (valid or invalid)
   * @param iac2 is IAC (valid or invalid)
   * @param iac3 is IAC (valid or invalid)
   */
  @When("^I enter multiple IAC as \"([^\"]*)\" \"([^\"]*)\" \"([^\"]*)\"$")
  public void i_enter_multiple_iac_as(String iac1, String iac2, String iac3) throws InterruptedException {
    responseAware.invokeMultipleIACEntry(iac1, iac2, iac3);
  }

  /**
   * Checks that IAC was invalid and correct action has occurred
   *
   * @throws InterruptedException pass the exception
   * @param status expected responseCode status
   */
  @Then("^result of verification should be \"([^\"]*)\"$")
  public void verification_should_be_unsuccessful(String status) throws InterruptedException {
    responseAware.responseCodeCheck();
    assertEquals(status, responseAware.responseCodeAssertCheck());
  }

  /**
   * Checks that IAC was invalid and authentication limit has been reached
   *
   * @throws InterruptedException pass the exception
   */
  @Then("^authentication limit should be reached$")
  public void authentication_limit_should_be_reached() throws InterruptedException {
    responseAware.responseCodeCheck();
  }

}
