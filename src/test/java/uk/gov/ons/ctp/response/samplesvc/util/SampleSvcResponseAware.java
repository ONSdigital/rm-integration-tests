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
  }

  /**
   * Test post request for /samples/sampleunitrequests response
   *
   * @param properties to create json from
   * @throws IOException pass the exception
   * @throws AuthenticationException pass the exception
   */
  public void invokePostEndpoint(Properties properties) throws IOException, AuthenticationException {
    responseAware.invokeJsonPost(world.getSampleSvcUrl(POST_URL), properties);
  }
}
