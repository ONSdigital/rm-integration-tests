package uk.gov.ons.ctp.response.notify.steps;

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
   * @throws Throwable pass the exception
   */
  @Given("^I make post call to the notify gateway endpoint for texts with invalid input$")
  public void i_make_post_call_to_the_notify_gateway_endpoint_for_texts_with_invalid_input() throws Throwable {
    Properties properties = new Properties();
    properties.put("invalid", "input");
    responseAware.invokePostTextEndpoint("de0da3c1-2cad-421a-bddd-054ef374c6ab", properties);
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
    responseAware.invokePostEmailEndpoint("de0da3c1-2cad-421a-bddd-054ef374c6ab", properties);
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
