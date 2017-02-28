package uk.gov.ons.ctp.response.action.steps;

import java.util.List;
import java.util.Properties;

import cucumber.api.java.en.When;
import uk.gov.ons.ctp.response.action.util.ActionPlanJobResponseAware;

/**
 * Created by Stephen Goddard on 03/05/16.
 */
public class ActionPlanJobSteps {
  private final ActionPlanJobResponseAware responseAware;

  /**
   * Constructor
   *
   * @param actionPlanJobResponseAware case frame end point runner
   */
  public ActionPlanJobSteps(ActionPlanJobResponseAware actionPlanJobResponseAware) {
    this.responseAware = actionPlanJobResponseAware;
  }

  /**
   * Test get request for /actionplans/jobs/{actionPlanJobId}
   *
   * @param actionPlanJobId action plan job id
   * @throws Throwable pass the exception
   */
  @When("^I make the GET call to the actionservice actionplans endpoint for specific plan job \"(.*?)\"$")
  public void i_make_the_GET_call_to_the_actionservice_actionplans_endpoint_for_specific_plan_job(
      String actionPlanJobId) throws Throwable {
    responseAware.invokeActionPlanJobEndpoints(actionPlanJobId);
  }

  /**
   * Test get request for /actionplans/{actionPlanId}/jobs
   *
   * @param actionPlanId action plan id
   * @throws Throwable pass the exception
   */
  @When("^I make the GET call to the actionservice actionplans endpoint for jobs with specific plan \"(.*?)\"$")
  public void i_make_the_GET_call_to_the_actionservice_actionplans_endpoint_for_jobs_with_specific_plan(
      String actionPlanId) throws Throwable {
    responseAware.invokeActionPlanJobListEndpoints(actionPlanId);
  }

  /**
   * Test post request for /actionplans/{actionPlanId}/jobs
   *
   * @param postValues values to be posted using JSON
   * @throws Throwable pass the exception
   */
  @When("^I make the POST call to the actionservice actionplans endpoint for jobs with specific plan$")
  public void i_make_the_POST_call_to_the_actionservice_actionplans_endpoint_for_jobs_with_specific_plan(
      List<String> postValues) throws Throwable {
    Properties properties = new Properties();
    properties.put("createdBy", postValues.get(1));

    responseAware.invokeExecuteActionPlanJobEndpoints(postValues.get(0), properties);
  }

  /**
   * Test invalid post request for /actionplans/{actionPlanId}/jobs
   *
   * @param actionPlanId action plan id
   * @throws Throwable pass the exception
   */
  @When("^I make the POST call to the actionservice actionplans endpoint for jobs with specific plan \"(.*?)\" with "
      + "invalid input$")
  public void
      i_make_the_POST_call_to_the_actionservice_actionplans_endpoint_for_jobs_with_specific_plan_with_invalid_input(
      String actionPlanId) throws Throwable {
    Properties properties = new Properties();
    properties.put("input", "invalid input value");

    responseAware.invokeExecuteActionPlanJobEndpoints(actionPlanId, properties);
  }
}
