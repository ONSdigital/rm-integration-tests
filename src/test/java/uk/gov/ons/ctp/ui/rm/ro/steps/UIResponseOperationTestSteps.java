package uk.gov.ons.ctp.ui.rm.ro.steps;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertTrue;

import cucumber.api.java.en.Then;
import cucumber.api.java.en.When;
import uk.gov.ons.ctp.ui.rm.ro.util.UIResponseOperationsResponseAware;

/**
 * Created by Stephen Goddard on 09/10/17.
 *
 */
public class UIResponseOperationTestSteps {
  private final UIResponseOperationsResponseAware responseAware;

  /**
   * Constructor
   *
   * @param uiResponseAware UI runner
   */
  public UIResponseOperationTestSteps(UIResponseOperationsResponseAware uiResponseAware) {
    this.responseAware = uiResponseAware;
  }

  /**
   * Navigate to the reporting unit page for reference
   *
   * @param ruRef reporting unit to navigate to
   * @throws Throwable error
   */
  @When("^the user navigtes to the reporting unit page using \"(.*?)\"$")
  public void the_user_navigtes_to_the_reporting_unit_page_using(String ruRef) throws Throwable {
    responseAware.navigateToRuRefPageForRef(ruRef);
  }

  /**
   * Test value of reporting unit from reporting unit page
   *
   * @param ruRef reporting unit to navigate to
   * @throws Throwable error
   */
  @Then("^the RU reference is \"(.*?)\"$")
  public void the_RU_reference_is(String ruRef) throws Throwable {
    String result = responseAware.getRUReference();
    assertEquals("RU reference does not match: " + result, ruRef, result);
  }

  /**
   * Test value of company name from reporting unit page
   *
   * @param name company name
   * @throws Throwable error
   */
  @Then("^the Name is \"(.*?)\"$")
  public void the_Name_is(String name) throws Throwable {
    String result = responseAware.getName();
    assertEquals("Name does not match: " + result, name, result);
  }

  /**
   * Test value of trading name from reporting unit page
   *
   * @param tradeName trading name
   * @throws Throwable error
   */
  @Then("^the Trading Name is \"(.*?)\"$")
  public void the_Trading_Name_is(String tradeName) throws Throwable {
    String result = responseAware.getTradingName();
    assertEquals("Trading name does not match: " + result, tradeName, result);
  }

  /**
   * Test value is found on the event table from reporting unit page
   *
   * @param eventValue event to be found
   * @throws Throwable error
   */
  @Then("^the event entry should be \"(.*?)\"$")
  public void the_event_entry_should_be(String eventValue) throws Throwable {
    boolean result = responseAware.isValueFoundInEventTable(eventValue);
    assertTrue("Value not found in event table: " + eventValue, result);
  }

  /**
   * Test value is found on the action table from reporting unit page
   *
   * @param actionValue action to be found
   * @throws Throwable error
   */
  @Then("^the action entry should be \"(.*?)\"$")
  public void the_action_entry_should_be(String actionValue) throws Throwable {
    boolean result = responseAware.isValueFoundInActionTable(actionValue);
    assertTrue("Value not found on table: " + actionValue, result);
  }

  @Then("^use pagination to see more events$")
  public void use_pagination_to_see_more_events() throws Throwable {
    responseAware.ruRefPaginateEvents();
  }
}
