package uk.gov.ons.ctp.response.notify.util;

import java.io.IOException;
import java.util.Properties;

import org.apache.http.auth.AuthenticationException;

import uk.gov.ons.ctp.response.common.util.PostgresResponseAware;
import uk.gov.ons.ctp.util.HTTPResponseAware;
import uk.gov.ons.ctp.util.World;

/**
 * Created by Stephen Goddard on 21/09/17.
 */
public class NotifyResponseAware {
  private static final String INFO_URL = "/info";
  private static final String POST_TEXT_URL = "/texts/%s";
  private static final String POST_EMAIL_URL = "/emails/%s";
  private static final String GET_MESSAGE_URL = "/messages/%s";
  private static final String USERNAME = "cuc.collect.username";
  private static final String PASSWORD = "cuc.collect.password";
  private static final String NOTIFY_SMS_NUMBER = "cuc.collect.notify.phone.number";
  private static final String NOTIFY_EMAIL = "cuc.collect.notify.email";
  private static final String SERVICE = "notify";

  private World world;
  private HTTPResponseAware responseAware;
  private final PostgresResponseAware postgresResponseAware;

  /**
   * Constructor - also gets singleton of http request runner.
   *
   * @param newWorld class with application and environment properties
   * @param dbResponseAware DB runner
   */
  public NotifyResponseAware(final World newWorld, final PostgresResponseAware dbResponseAware) {
    this.world = newWorld;
    this.responseAware = HTTPResponseAware.getInstance();
    responseAware.enableBasicAuth(world.getProperty(USERNAME), world.getProperty(PASSWORD));
    this.postgresResponseAware = dbResponseAware;
  }

  /**
   * Test post request for /info response
   *
   * @throws IOException pass the exception
   * @throws AuthenticationException pass the exception
   */
  public void invokeInfoEndpoint() throws IOException, AuthenticationException {
    responseAware.invokeGet(world.getUrl(INFO_URL, SERVICE));
  }

  /**
   * Test post request for /info response
   *
   * @param templateId to added to url
   * @param properties to construct JSON from
   * @param incAddress indicates if address is to be added to json
   * @throws IOException pass the exception
   * @throws AuthenticationException pass the exception
   */
  public void invokePostTextEndpoint(String templateId, Properties properties, boolean incAddress)
      throws IOException, AuthenticationException {
    if (incAddress) {
      properties.put("phoneNumber", world.getProperty(NOTIFY_SMS_NUMBER));
    }

    final String url = String.format(POST_TEXT_URL, templateId);
    responseAware.invokeJsonPost(world.getUrl(url, SERVICE), properties);
  }

  /**
   * Test post request for /info response
   *
   * @param templateId to added to url
   * @param properties to construct JSON from
   * @param incAddress indicates if address is to be added to json
   * @throws IOException pass the exception
   * @throws AuthenticationException pass the exception
   */
  public void invokePostEmailEndpoint(String templateId, Properties properties, boolean incAddress)
      throws IOException, AuthenticationException {
    if (incAddress) {
      properties.put("emailAddress", world.getProperty(NOTIFY_EMAIL));
    }

    final String url = String.format(POST_EMAIL_URL, templateId);
    responseAware.invokeJsonPost(world.getUrl(url, SERVICE), properties);
  }

  /**
   * Test get request for /messages/{messageid}
   *
   * @param messageId to added to url
   * @throws IOException pass the exception
   * @throws AuthenticationException pass the exception
   */
  public void invokeGetMessagesEndpoint(String messageId) throws IOException, AuthenticationException {
    if (messageId == null || messageId.length() == 0) {
      messageId = postgresResponseAware.getFieldFromRecord("id", "notifygatewaysvc.message");
    }

    final String url = String.format(GET_MESSAGE_URL, messageId);
    responseAware.invokeGet(world.getUrl(url, SERVICE));
  }
}
