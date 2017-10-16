package uk.gov.ons.ctp.response.notify.steps;

import java.util.List;
import java.util.Properties;

import cucumber.api.java.en.Given;
import uk.gov.ons.ctp.response.notify.util.NotifyResponseAware;

/**
 * Created by Stephen Goddard on 21/09/17.
 */
public class NotifySteps {
  private final NotifyResponseAware responseAware;

  /**
   * Constructor
   *
   * @param notifyResponseAware notify gateway end point runner
   */
  public NotifySteps(NotifyResponseAware notifyResponseAware) {
    this.responseAware = notifyResponseAware;
  }

  /* End point steps */

  /**
   * Test get request for /info
   *
   * @throws Throwable pass the exception
   */
  @Given("^I make get call to the notify gateway endpoint for info$")
  public void i_make_get_call_to_the_notify_gateway_endpoint_for_info() throws Throwable {
    responseAware.invokeInfoEndpoint();
  }

  /**
   * Test post request for /texts/{templateid}
   *
   * @param postValues to be in json
   * @throws Throwable pass the exception
   */
  @Given("^I make post call to the notify gateway endpoint for texts$")
  public void i_make_post_call_to_the_notify_gateway_endpoint_for_texts(List<String> postValues) throws Throwable {
    Properties properties = new Properties();

    if (postValues.get(0).length() != 0 && postValues.get(0) != null) {
      Properties prop = new Properties();
      prop.put("iac", postValues.get(0));
      properties.put("personalisation", prop);
    }
    if (postValues.get(1).length() != 0 && postValues.get(1) != null) {
      properties.put("reference", postValues.get(1));
    }
    responseAware.invokePostTextEndpoint("f3778220-f877-4a3d-80ed-e8fa7d104563", properties, true);
  }

  /**
   * Test post request for /texts/{templateid}
   *
   * @throws Throwable pass the exception
   */
  @Given("^I make post call to the notify gateway endpoint for texts with invalid input$")
  public void i_make_post_call_to_the_notify_gateway_endpoint_for_texts_with_invalid_input() throws Throwable {
    Properties properties = new Properties();
    properties.put("invalid", "input");
    responseAware.invokePostTextEndpoint("de0da3c1-2cad-421a-bddd-054ef374c6ab", properties, false);
  }

  /**
   * Test post request for /emails/{templateid}
   *
   * @param postValues to be in json
   * @throws Throwable pass the exception
   */
  @Given("^I make post call to the notify gateway endpoint for emails$")
  public void i_make_post_call_to_the_notify_gateway_endpoint_for_emails(List<String> postValues) throws Throwable {
    Properties properties = new Properties();

    if (postValues.get(0).length() != 0 && postValues.get(0) != null) {
      Properties prop = new Properties();
      prop.put("iac", postValues.get(0));
      properties.put("personalisation", prop);
    }
    if (postValues.get(1).length() != 0 && postValues.get(1) != null) {
      properties.put("reference", postValues.get(1));
    }
    responseAware.invokePostEmailEndpoint("290b93f2-04c2-413d-8f9b-93841e684e90", properties, true);
  }

  /**
   * Test post request for /emails/{templateid}
   *
   * @throws Throwable pass the exception
   */
  @Given("^I make post call to the notify gateway endpoint for emails with invalid input$")
  public void i_make_post_call_to_the_notify_gateway_endpoint_for_emails_with_invalid_input() throws Throwable {
    Properties properties = new Properties();
    properties.put("invalid", "input");
    responseAware.invokePostEmailEndpoint("de0da3c1-2cad-421a-bddd-054ef374c6ab", properties, false);
  }

  /**
   * Test get request for /messages/{messageid}
   *
   * @throws Throwable pass the exception
   */
  @Given("^I make get call to the notify gateway endpoint$")
  public void i_make_get_call_to_the_notify_gateway_endpoint() throws Throwable {
    responseAware.invokeGetMessagesEndpoint(null);
  }

  /**
   * Test get request for /messages/{messageid}
   *
   * @param messageId to added to url
   * @throws Throwable pass the exception
   */
  @Given("^I make get call to the notify gateway endpoint by message id \"(.*?)\"$")
  public void i_make_get_call_to_the_notify_gateway_endpoint_by_message_id(String messageId) throws Throwable {
    responseAware.invokeGetMessagesEndpoint(messageId);
  }
}
