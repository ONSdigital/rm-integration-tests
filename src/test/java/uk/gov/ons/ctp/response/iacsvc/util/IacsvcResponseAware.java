package uk.gov.ons.ctp.response.iacsvc.util;

import java.io.IOException;
import java.util.Properties;

import org.apache.http.auth.AuthenticationException;

import com.jayway.jsonpath.JsonPath;

import uk.gov.ons.ctp.util.HTTPResponseAware;
import uk.gov.ons.ctp.util.World;

/**
 * Created by Stephen Goddard on 04/10/16.
 */
public class IacsvcResponseAware {
  private World world;
  private HTTPResponseAware responseAware;

  private String iac = "";

  /**
   * Constructor - also gets singleton of http request runner.
   *
   * @param newWorld class with application and environment properties
   */
  public IacsvcResponseAware(final World newWorld) {
    this.world = newWorld;
    this.responseAware = HTTPResponseAware.getInstance();
  }

  /**
   * Get response body.
   *
   * @return body as string
   */
  public String getBody() {
    return responseAware.getBody();
  }

  /**
   * @iac Service - /iacs post endoints.
   *
   * @param properties to construct JSON from
   * @throws IOException IO exception
   * @throws AuthenticationException authentication exception
   */
  public void invokePostIacEndpoint(Properties properties) throws IOException, AuthenticationException {
    final String url = "/iacs";
    world.getIacsvcUrl(url);
    responseAware.enableBasicAuth(world.getProperty("cuc.collect.iacsvc.username"),
        world.getProperty("cuc.collect.iacsvc.password"));
    responseAware.invokeJsonPost(world.getIacsvcUrl(url), properties);
  }

  /**
   * @iac Service - /iacs/{iac} get endoints.
   *
   * @param testIac code to get details for
   * @throws IOException IO exception
   * @throws AuthenticationException authentication exception
   */
  public void invokeGetIacEndpoint(String testIac) throws IOException, AuthenticationException {
    final String url = String.format("/iacs/%s", testIac);
    responseAware.enableBasicAuth(world.getProperty("cuc.collect.iacsvc.username"),
        world.getProperty("cuc.collect.iacsvc.password"));
    responseAware.invokeGet(world.getIacsvcUrl(url));
  }

  /**
   * @iac Service - /iacs/{iac} put endoints.
   *
   * @param properties to construct JSON from
   * @param testIac code to get details for
   * @throws IOException IO exception
   * @throws AuthenticationException authentication exception
   */
  public void invokePutIacEndpoint(String testIac, Properties properties) throws IOException, AuthenticationException {
    final String url = String.format("/iacs/%s", testIac);
    responseAware.enableBasicAuth(world.getProperty("cuc.collect.iacsvc.username"),
        world.getProperty("cuc.collect.iacsvc.password"));
    responseAware.invokeJsonPut(world.getIacsvcUrl(url), properties);
  }

  /**
   * @iac Service - /iacs/{iac} put endoints. Where iac is not relevant as valid hard coded
   *
   * @param properties to construct JSON from
   * @throws IOException IO exception
   * @throws AuthenticationException authentication exception
   */
  public void invokePutIacEndpoint(Properties properties) throws IOException, AuthenticationException {
    final String url = String.format("/iacs/%s", "yxf4f87dhj73");
    responseAware.enableBasicAuth(world.getProperty("cuc.collect.iacsvc.username"),
        world.getProperty("cuc.collect.iacsvc.password"));
    responseAware.invokeJsonPut(world.getIacsvcUrl(url), properties);
  }

  /**
   * @iac Service - when iac is in response from case request return so it can be used if future calls to iacsvc
   *
   * @return String value of iac
   * @throws IOException IO exception
   * @throws AuthenticationException authentication exception
   */
  public String getIACFromPreviousResponse() throws IOException, AuthenticationException {
    if (iac == null || iac.length() == 0) {
      iac = JsonPath.read(responseAware.getBody(), "$.iac");
      iac = iac.replaceAll("\\s+", "");
    }

    return iac;
  }
}
