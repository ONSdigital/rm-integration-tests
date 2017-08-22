package uk.gov.ons.ctp.response.iacsvc.util;

import java.io.IOException;
import java.util.Properties;

import org.apache.http.auth.AuthenticationException;

import uk.gov.ons.ctp.response.common.util.PostgresResponseAware;
import uk.gov.ons.ctp.util.HTTPResponseAware;
//import uk.gov.ons.ctp.util.PostgresResponseAware;
import uk.gov.ons.ctp.util.World;

/**
 * Created by Stephen Goddard on 04/10/16.
 */
public class IacsvcResponseAware {
  private static final String POST_IAC_URL = "/iacs";
  private static final String GET_IAC_URL = "/iacs/%s";
  private static final String PUT_IAC_URL = "/iacs/%s";
  private static final String INFO_URL = "/info";
  private static final String SERVICE = "iacsvc";

  private World world;
  private HTTPResponseAware responseAware;
  private final PostgresResponseAware postgresResponseAware;

  /**
   * Constructor - also gets singleton of http request runner.
   *
   * @param newWorld class with application and environment properties
   * @param dbResponseAware DB runner
   */
  public IacsvcResponseAware(final World newWorld, PostgresResponseAware dbResponseAware) {
    this.world = newWorld;
    this.responseAware = HTTPResponseAware.getInstance();
    this.postgresResponseAware = dbResponseAware;
  }

  /**
   * @iac Service - /iacs post endoints.
   *
   * @param properties to construct JSON from
   * @throws IOException IO exception
   * @throws AuthenticationException authentication exception
   */
  public void invokePostIacEndpoint(Properties properties) throws IOException, AuthenticationException {
    final String url = POST_IAC_URL;
    responseAware.enableBasicAuth(world.getProperty("cuc.collect.iacsvc.username"),
        world.getProperty("cuc.collect.iacsvc.password"));
    responseAware.invokeJsonPost(world.getUrl(url, SERVICE), properties);
  }

  /**
   * @iac Service - /iacs/{iac} get endoints.
   *
   * @param testIac code to get details for
   * @throws IOException IO exception
   * @throws AuthenticationException authentication exception
   */
  public void invokeGetIacEndpoint(String testIac) throws IOException, AuthenticationException {
    if (testIac == null || testIac.length() == 0) {
      testIac = "";//world.getIdFromDB("iac", "casesvc.case", "1", postgresResponseAware);
    }

    final String url = String.format(GET_IAC_URL, testIac);
    responseAware.enableBasicAuth(world.getProperty("cuc.collect.iacsvc.username"),
        world.getProperty("cuc.collect.iacsvc.password"));
    responseAware.invokeGet(world.getUrl(url, SERVICE));
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
    if (testIac == null || testIac.length() == 0) {
      testIac = "";//world.getIdFromDB("iac", "casesvc.case", "1", postgresResponseAware);
    }

    final String url = String.format(PUT_IAC_URL, testIac);
    responseAware.enableBasicAuth(world.getProperty("cuc.collect.iacsvc.username"),
        world.getProperty("cuc.collect.iacsvc.password"));
    responseAware.invokeJsonPut(world.getUrl(url, SERVICE), properties);
  }

  /**
   * Test post request for /info response
   * @throws IOException pass the exception
   * @throws AuthenticationException pass the exception
   */
  public void invokeInfoEndpoint() throws IOException, AuthenticationException {
    responseAware.invokeGet(world.getUrl(INFO_URL, SERVICE));
  }
}
