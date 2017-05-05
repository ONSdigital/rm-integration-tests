package uk.gov.ons.ctp.response.samplesvc.util;

import java.io.IOException;
import java.util.Properties;

import org.apache.http.auth.AuthenticationException;
import org.apache.http.entity.ContentType;

import uk.gov.ons.ctp.util.HTTPResponseAware;
import uk.gov.ons.ctp.util.World;

/**
 * Created by Stephen Goddard on 11/4/17.
 */
public class SampleSvcResponseAware {
  private static final String POST_URL = "/samples/sampleunitrequests";
  private static final String BASE_URL = "/samples/%s/%s";
  private static final String PUT_BASE_URL = "/samples/%s";
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

//  /**
//   * Test get request for /samples/{surveyRef}/{startTimestamp} response
//   *
//   * @param surveyRef survey reference to get
//   * @param timeStamp start date time for sample
//   * @throws IOException pass the exception
//   * @throws AuthenticationException pass the exception
//   */
//  public void invokeGetSampleSvcEndpoint(String surveyRef, String timeStamp)
//      throws IOException, AuthenticationException {
//    final String url = String.format(BASE_URL, surveyRef, timeStamp);
//    responseAware.invokeGet(world.getSampleSvcUrl(url));
//  }

//  /**
//   * Test put request for /samples/{sampleid} response
//   *
//   * @param sampleId to update
//   *
//   * @throws IOException pass the exception
//   * @throws AuthenticationException pass the exception
//   */
//  public void invokePutSampleSvcEndpoint(String sampleId) throws IOException, AuthenticationException {
//    final String url = String.format(PUT_BASE_URL, sampleId);
//    responseAware.invokePut(world.getSampleSvcUrl(url), "", ContentType.APPLICATION_JSON);
//  }

  public void invokePostEndpoint(Properties properties) throws IOException, AuthenticationException {
    responseAware.invokeJsonPost(world.getSampleSvcUrl(POST_URL), properties);
  }
}
