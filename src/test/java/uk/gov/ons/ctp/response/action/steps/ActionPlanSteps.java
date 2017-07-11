package uk.gov.ons.ctp.response.action.steps;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import java.util.Properties;

import cucumber.api.java.en.When;
import uk.gov.ons.ctp.response.action.util.ActionPlanResponseAware;

/**
 * Created by Stephen Goddard on 29/4/16.
 */
public class ActionPlanSteps {

  private final ActionPlanResponseAware responseAware;

  /**
   * Constructor
   *
   * @param actionPlanResponseAware case frame end point runner
   */
  public ActionPlanSteps(ActionPlanResponseAware actionPlanResponseAware) {
    this.responseAware = actionPlanResponseAware;
  }

  /**
   * Test get request for /actionplans
   *
   * @throws Throwable pass the exception
   */
  @When("^I make the GET call to the actionservice actionplans endpoint$")
  public void i_make_the_GET_call_to_the_actionservice_actionplans_endpoint() throws Throwable {
    responseAware.invokeActionPlansEndpoint();
  }

  /**
   * Test post request for /actionplans
   *
   * @param postValues values to be posted using JSON
   * @throws Throwable pass the exception
   */
  @When("^I make the POST call to the actionservice actionplans endpoint$")
  public void i_make_the_POST_call_to_the_actionservice_actionplans_endpoint(List<String> postValues) throws Throwable {
    Properties properties = new Properties();
    properties.put("surveyId", postValues.get(0));
    properties.put("name", postValues.get(1));
    properties.put("description", postValues.get(2));
    properties.put("createdBy", postValues.get(3));

    responseAware.invokePostActionPlansEndpoint(properties);
  }

  /**
   * Test get request for /actionplans/{actionPlanId}
   *
   * @param actionPlanId action plan id
   * @throws Throwable pass the exception
   */
  @When("^I make the GET call to the actionservice actionplans endpoint for specified actionPlanId \"(.*?)\"$")
  public void i_make_the_GET_call_to_the_actionservice_actionplans_endpoint_for_specified_actionPlanId(
      String actionPlanId) throws Throwable {
    responseAware.invokeActionPlanIdEndpoint(actionPlanId);
  }

  /**
   * Test put request for /actionplans/{actionPlanId}
   *
   * @param putValues values to be posted using JSON
   * @throws Throwable pass the exception
   */
  @When("^I make the PUT call to the actionservice actionplans endpoint for specified actionPlanId$")
  public void i_make_the_PUT_call_to_the_actionservice_actionplans_endpoint_for_specified_actionPlanId(
      List<String> putValues) throws Throwable {
    Properties properties = new Properties();
    String description = putValues.get(1);
    String lastRunDateTime = putValues.get(2);

    if (description != null && description.length() > 0) {
      properties.put("description", description);
    }
    if (lastRunDateTime != null && lastRunDateTime.length() > 0) {
      SimpleDateFormat sdfDate = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss");
      String strDate = sdfDate.format(new Date());
      properties.put("lastRunDateTime", strDate);
    }

    responseAware.invokePutActionPlanIdEndpoint(putValues.get(0), properties);
  }

  /**
   * Test put request for /actionplans/{actionPlanId}
   *
   * @param actionPlanId action plan id
   * @throws Throwable pass the exception
   */
  @When("^I make the PUT call to the actionservice actionplans endpoint for specified actionPlanId \"(.*?)\" with "
      + "invalid input$")
  public void
    i_make_the_PUT_call_to_the_actionservice_actionplans_endpoint_for_specified_actionPlanId_with_invalid_input(
      String actionPlanId) throws Throwable {
    Properties properties = new Properties();
    properties.put("input", "invalid input value");

    responseAware.invokePutActionPlanIdEndpoint(actionPlanId, properties);
  }
}
