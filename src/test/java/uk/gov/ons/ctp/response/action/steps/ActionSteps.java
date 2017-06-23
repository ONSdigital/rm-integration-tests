package uk.gov.ons.ctp.response.action.steps;

import java.util.ArrayList;
import java.util.List;
//import java.util.Properties;

import cucumber.api.java.en.Given;
import cucumber.api.java.en.When;
import uk.gov.ons.ctp.response.action.util.ActionResponseAware;
import uk.gov.ons.ctp.response.common.steps.PostgresSteps;
import uk.gov.ons.ctp.util.PostgresResponseAware;

/**
 * Created by Stephen Goddard on 29/4/16.
 */
public class ActionSteps {

  private final ActionResponseAware responseAware;
  private final PostgresResponseAware postgresResponseAware;

//  private String caseId;

  /**
   * Constructor
   *
   * @param actionResponseAware case frame end point runner
   * @param dbResponseAware DB runner
   */
  public ActionSteps(ActionResponseAware actionResponseAware, PostgresResponseAware dbResponseAware) {
    this.responseAware = actionResponseAware;
    this.postgresResponseAware = dbResponseAware;
  }

  /**
   * Test get request for /actions
   *
   * @param getValues optional filter values
   * @throws Throwable pass the exception
   */
  @When("^I make the GET call to the actionservice actions endpoint$")
  public void i_make_the_GET_call_to_the_actionservice_actions_endpoint(List<String> getValues) throws Throwable {
    StringBuffer filter = new StringBuffer();

    String actionType = getValues.get(0);
    String state = getValues.get(1);

    if (actionType != null && actionType.length() > 0) {
      filter.append("?actiontype=" + actionType);
    }
    if (state != null && state.length() > 0) {
      if (filter.length() > 0) {
        filter.append("&state=" + state);
      } else {
        filter.append("?state=" + state);
      }
    }
    responseAware.invokeActionsEndpoint(filter.toString());
  }

  /**
   * Test valid caseid for get request /actions/case/{caseId}
   * First gets a caseid from the DB to use in request
   *
   * @throws Throwable pass the exception
   */
  @Given("^I make the GET call to the actionservice actions endpoint for caseId$")
  public void i_make_the_GET_call_to_the_actionservice_actions_endpoint_for_caseId() throws Throwable {
    List<Object> result = new ArrayList<Object>();

    String sql = String.format(PostgresSteps.LIMIT_SQL, "caseid", "action.action", "1");
    result = (ArrayList<Object>) postgresResponseAware.dbSelect(sql);

    responseAware.invokeActionsCaseIdEndpoint(result.get(0).toString());
  }

  /**
   * Test get request for /actions/case/{caseId}
   *
   * @param caseId case id
   * @throws Throwable pass the exception
   */
  @When("^I make the GET call to the actionservice actions endpoint for caseId \"(.*?)\"$")
  public void i_make_the_GET_call_to_the_actionservice_actions_endpoint_for_caseId(String caseId) throws Throwable {
    responseAware.invokeActionsCaseIdEndpoint(caseId);
  }

  /**
  * Test get request for /actions/{actionId}
  *
  * @throws Throwable pass the exception
  */
  @When("^I make the GET call to the actionservice actions endpoint for actionId$")
  public void i_make_the_GET_call_to_the_actionservice_actions_endpoint_for_actionId() throws Throwable {
    List<Object> result = new ArrayList<Object>();

    String sql = String.format(PostgresSteps.LIMIT_SQL, "id", "action.action", "1");
    result = (ArrayList<Object>) postgresResponseAware.dbSelect(sql);

    responseAware.invokeActionsIdEndpoint(result.get(0).toString());
  }

  /**
  * Test get request for /actions/{actionId}
  *
  * @param actionId action id
  * @throws Throwable pass the exception
  */
  @When("^I make the GET call to the actionservice actions endpoint for actionId \"(.*?)\"$")
  public void i_make_the_GET_call_to_the_actionservice_actions_endpoint_for_actionId(String actionId) throws Throwable {
    responseAware.invokeActionsIdEndpoint(actionId);
  }

//  /**
//   * Test post request for /actions
//   *
//   * @param postValues values to be posted using JSON
//   * @throws Throwable pass the exception
//   */
//  @When("^I make the POST call to the actionservice actions endpoint$")
//  public void i_make_the_POST_call_to_the_actionservice_actions_endpoint(List<String> postValues) throws Throwable {
//    Properties properties = new Properties();
//    properties.put("caseId", postValues.get(0));
//    properties.put("actionTypeName", postValues.get(1));
//    properties.put("priority", postValues.get(2));
//    properties.put("createdBy", postValues.get(3));
//
//    responseAware.invokePostActionsEndpoint(properties);
//  }

//  /**
//   * Test invalid post request for /actions
//   *
//   * @throws Throwable pass the exception
//   */
//  @When("^I make the POST call to the actionservice actions endpoint with invalid input$")
//  public void i_make_the_POST_call_to_the_actionservice_actions_endpoint_with_invalid_input() throws Throwable {
//    Properties properties = new Properties();
//    properties.put("input", "invalid input value");
//
//    responseAware.invokePostActionsEndpoint(properties);
//  }

//  /**
//   * Test put request for /actions/{actionId}/feedback
//   *
//   * @param actionId action id
//   * @throws Throwable pass the exception
//   */
//  @When("^I make the PUT call to the actionservice actions feedback endpoint for actionId \"(.*?)\"$")
//  public void i_make_the_PUT_call_to_the_actionservice_actions_feedback_endpoint_for_actionId(String actionId)
//      throws Throwable {
//    Properties properties = new Properties();
//    properties.put("actionId", actionId);
//    properties.put("situation", "CI Test Run");
//    properties.put("outcome", "REQUEST_COMPLETED");
//
//    responseAware.invokePutActionsActionIdFeedbackEndpoint(actionId, properties);
//  }

//  /**
//   * Test invalid put request for /actions/{actionId}/feedback
//   *
//   * @param actionId action id
//   * @throws Throwable pass the exception
//   */
//  @When("^I make the PUT call to the actionservice actions feedback endpoint with invalid input \"(.*?)\"$")
//  public void i_make_the_PUT_call_to_the_actionservice_actions_feedback_endpoint_with_invalid_input(String actionId)
//      throws Throwable {
//    Properties properties = new Properties();
//    properties.put("input", "invalid input value");
//
//    responseAware.invokePutActionsActionIdFeedbackEndpoint(actionId, properties);
//  }



//  /**
//   * Test put request for /actions/{actionId}
//   *
//   * @param putValues values to be posted using JSON
//   * @throws Throwable pass the exception
//   */
//  @When("^I make the PUT call to the actionservice actions endpoint for actionId$")
//  public void i_make_the_PUT_call_to_the_actionservice_actions_endpoint_for_actionId(List<String> putValues)
//      throws Throwable {
//    Properties properties = new Properties();
//    properties.put("priority", putValues.get(1));
//    properties.put("situation", putValues.get(2));
//
//    responseAware.invokePutActionsIdEndpoint(putValues.get(0), properties);
//  }

//  /**
//   * Test invalid put request for /actions/{actionId}
//   *
//   * @param actionId action id
//   * @throws Throwable pass the exception
//   */
//  @When("^I make the PUT call to the actionservice actions endpoint for actionId \"(.*?)\" with invalid input$")
//  public void i_make_the_PUT_call_to_the_actionservice_actions_endpoint_for_actionId_with_invalid_input
//  (String actionId)
//      throws Throwable {
//    Properties properties = new Properties();
//    properties.put("input", "invalid input value");
//
//    responseAware.invokePutActionsIdEndpoint(actionId, properties);
//  }



//  /**
//   * Test put request for /actions/case/{caseId}/cancel
//   *
//   * @param caseId case id
//   * @throws Throwable pass the exception
//   */
//  @When("^I make the PUT call to the actionservice cancel actions endpoint for caseId \"(.*?)\"$")
//  public void i_make_the_PUT_call_to_the_actionservice_cancel_actions_endpoint_for_caseId(String caseId)
//      throws Throwable {
//    responseAware.invokePutActionsCancelEndpoint(caseId);
//  }

}
