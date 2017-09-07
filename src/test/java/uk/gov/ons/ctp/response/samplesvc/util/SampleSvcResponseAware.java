package uk.gov.ons.ctp.response.samplesvc.util;

import java.io.IOException;
import java.util.Properties;

import org.apache.http.auth.AuthenticationException;

import uk.gov.ons.ctp.util.HTTPResponseAware;
import uk.gov.ons.ctp.util.World;

/**
 * Created by Stephen Goddard on 11/4/17.
 */
public class SampleSvcResponseAware {
  private static final String POST_URL = "/samples/sampleunitrequests";
  private static final String INFO_URL = "/info";
  private static final String USERNAME = "cuc.collect.username";
  private static final String PASSWORD = "cuc.collect.password";
  private static final String SERVICE = "samplesvc";
  private World world;
  private HTTPResponseAware responseAware;

  /**
   * Constructor - also gets singleton of http request runner.
   *
   * @param newWorld class with application and environment properties
   */
  public SampleSvcResponseAware(final World newWorld) {
    this.world = newWorld;
    this.responseAware = HTTPResponseAware.getInstance();
    responseAware.enableBasicAuth(world.getProperty(USERNAME), world.getProperty(PASSWORD));
  }

  /**
   * Test post request for /samples/sampleunitrequests response
   *
   * @param properties to create json from
   * @throws IOException pass the exception
   * @throws AuthenticationException pass the exception
   */
  public void invokePostEndpoint(Properties properties) throws IOException, AuthenticationException {
    responseAware.invokeJsonPost(world.getUrl(POST_URL, SERVICE), properties);
  }

  /**
   * Test get request for /info response
   *
   * @throws IOException pass the exception
   * @throws AuthenticationException pass the exception
   */
  public void invokeInfoEndpoint() throws IOException, AuthenticationException {
    responseAware.invokeGet(world.getUrl(INFO_URL, SERVICE));
  }
}
