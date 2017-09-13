package uk.gov.ons.ctp.response.action.steps;

//import java.util.ArrayList;
import java.util.List;
import java.util.Properties;

import cucumber.api.java.en.Given;
import cucumber.api.java.en.When;
import uk.gov.ons.ctp.response.action.util.ActionResponseAware;

/**
 * Created by Stephen Goddard on 29/4/16.
 */
public class ActionSteps {
  private final ActionResponseAware responseAware;

  /**
   * Constructor
   *
   * @param actionResponseAware case frame end point runner
   */
  public ActionSteps(ActionResponseAware actionResponseAware) {
    this.responseAware = actionResponseAware;
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
   *
   * @throws Throwable pass the exception
   */
  @Given("^I make the GET call to the actionservice actions endpoint for caseId$")
  public void i_make_the_GET_call_to_the_actionservice_actions_endpoint_for_caseId() throws Throwable {
    responseAware.invokeActionsCaseIdEndpoint(null);
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

  
  
  @Given("^I make the PUT call to the actionservice actions endpoint for caseId$")
  public void i_make_the_PUT_call_to_the_actionservice_actions_endpoint_for_caseId(List<String> putValues) throws Throwable {
    Properties properties = new Properties();
    String caseId = putValues.get(0);

    properties.put("situation", putValues.get(1));
    properties.put("outcome", putValues.get(2));
    
    responseAware.invokePutActionsCaseIdEndpoint(caseId, properties);
  }
  


  
  /**
  * Test get request for /actions/{actionId}
  *
  * @throws Throwable pass the exception
  */
  @When("^I make the GET call to the actionservice actions endpoint for actionId$")
  public void i_make_the_GET_call_to_the_actionservice_actions_endpoint_for_actionId() throws Throwable {
    responseAware.invokeActionsIdEndpoint(null);
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


  @When("^I make the POST call to the actionservice actions endpoint$")
  public void i_make_the_POST_call_to_the_actionservice_actions_endpoint(List<String> postValues) throws Throwable {
    Properties properties = new Properties();
//    properties.put("caseId", postValues.get(0));
    properties.put("actionTypeName", postValues.get(1));
    properties.put("createdBy", postValues.get(2));
    properties.put("priority", postValues.get(3));
//    
//    responseAware.invokePutActionsCaseIdEndpoint(caseId, properties);
    responseAware.invokePostActionsEndpoint(postValues.get(0), properties);
  }

  @When("^I make the POST call to the actionservice actions endpoint with invalid input$")
  public void i_make_the_POST_call_to_the_actionservice_actions_endpoint_with_invalid_input() throws Throwable {
    Properties properties = new Properties();
//    String caseId = putValues.get(0);

    properties.put("invalid", "input");
//    properties.put("outcome", putValues.get(2));
    
    responseAware.invokePostActionsEndpoint(null, properties);
//    List<String> properties = new ArrayList<String>();
//    i_make_the_POST_call_to_the_actionservice_actions_endpoint(List<String> postValues)
  }
  


  /**
   * Test put request for /actions/{actionid}
   *
   * @param putValues values to be posted using JSON
   * @throws Throwable pass the exception
   */
  @Given("^I make the PUT call to the actionservice actions endpoint by actionId$")
  public void i_make_the_PUT_call_to_the_actionservice_actions_endpoint_by_actionId(List<String> putValues) throws Throwable {
    Properties properties = new Properties();
    properties.put("situation", putValues.get(1));
    properties.put("priority", putValues.get(2));
    responseAware.invokePutActionsEndpoint(putValues.get(0), properties);
  }

  /**
   * Test put request for /actions/{actionid}
   *
   * @param actionId to be put
   * @throws Throwable pass the exception
   */
  @Given("^I make the PUT call to the actionservice actions endpoint by actionId with invalid input \"(.*?)\"$")
  public void i_make_the_PUT_call_to_the_actionservice_actions_endpoint_by_actionId_with_invalid_input(String actionId) throws Throwable {
    Properties properties = new Properties();
    properties.put("invalid", "input");
    responseAware.invokePutActionsEndpoint(actionId, properties);
  }
  
  
  
  /**
   * Test post request for /actions
   *
   * @param postValues values to be posted using JSON
   * @throws Throwable pass the exception
   */
  @When("^I make the PUT call to the actionservice feedback endpoint$")
  public void i_make_the_PUT_call_to_the_actionservice_feedback_endpoint(List<String> postValues) throws Throwable {
    Properties properties = new Properties();
    String actionId = postValues.get(0);
    properties.put("situation", postValues.get(1));
    properties.put("outcome", postValues.get(2));

    responseAware.invokePutActionsActionIdFeedbackEndpoint(actionId, properties);
  }

  /**
   * Test put request for /actions/{actionId}/feedback
   *
   * @param actionId action id
   * @throws Throwable pass the exception
   */
  @When("^I make the PUT call to the actionservice actions feedback endpoint for actionId \"(.*?)\"$")
  public void i_make_the_PUT_call_to_the_actionservice_actions_feedback_endpoint_for_actionId(String actionId)
      throws Throwable {
    Properties properties = new Properties();
    properties.put("actionId", actionId);
    properties.put("situation", "CI Test Run");
    properties.put("outcome", "REQUEST_COMPLETED");

    responseAware.invokePutActionsActionIdFeedbackEndpoint(actionId, properties);
  }

  /**
   * Test invalid put request for /actions/{actionId}/feedback
   *
   * @throws Throwable pass the exception
   */
  @When("^I make the PUT call to the actionservice actions feedback endpoint with invalid input$")
  public void i_make_the_PUT_call_to_the_actionservice_actions_feedback_endpoint_with_invalid_input()
      throws Throwable {
    Properties properties = new Properties();
    properties.put("input", "invalid input value");

    responseAware.invokePutActionsActionIdFeedbackEndpoint(null, properties);
  }

  /**
   * Test post request for /info
   * @throws Throwable pass the exception
   */
  @Given("^I make the call to the actionservice endpoint for info")
  public void i_make_the_call_to_the_actionservice_endpoint_for_info() throws Throwable {
    responseAware.invokeInfoEndpoint();
  }
}
