package uk.gov.ons.ctp.response.sdx.util;

//import java.io.File;
import java.io.IOException;
import java.util.List;
//import java.util.Properties;
import java.util.Properties;

import org.apache.http.auth.AuthenticationException;

import uk.gov.ons.ctp.response.common.util.PostgresResponseAware;
import uk.gov.ons.ctp.util.HTTPResponseAware;
import uk.gov.ons.ctp.util.World;

/**
 * Created by Stephen Goddard on 30/9/16.
 */
public class SdxGatewayResponseAware {
  private static final String LIMIT_SQL = "SELECT %s FROM %s WHERE %s LIMIT %s;";
  private static final String INFO_URL = "/info";
  private static final String POST_RECEIPTS = "/receipts";
  private static final String USERNAME = "cuc.collect.username";
  private static final String PASSWORD = "cuc.collect.password";
  private static final String SERVICE = "sdxgateway";

  private World world;
  private HTTPResponseAware responseAware;
  private final PostgresResponseAware postgresResponseAware;

  /**
   * Constructor - also gets singleton of http request runner.
   *
   * @param newWorld class with application and environment properties
   * @param dbResponseAware DB runner
   */
  public SdxGatewayResponseAware(final World newWorld, final PostgresResponseAware dbResponseAware) {
    this.world = newWorld;
    this.responseAware = HTTPResponseAware.getInstance();
    responseAware.enableBasicAuth(world.getProperty(USERNAME), world.getProperty(PASSWORD));
    this.postgresResponseAware = dbResponseAware;
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

  /**
   * sdx gateway - /questionnairereceipts post endpoint.
   *
   * @param properties to construct JSON from
   * @throws IOException IO exception
   * @throws AuthenticationException authentication exception
   */
  public void invokeSdxReceiptEndpoint(Properties properties) throws IOException, AuthenticationException {
    responseAware.invokeJsonPost(world.getUrl(POST_RECEIPTS, SERVICE), properties);
  }

  // Utils

  /**
   * Utility method to get case by case type.
   *
   * @param caseType to be use in where clause
   * @return List of String for retrieved cases
   * @throws IOException IO exception
   * @throws AuthenticationException authentication exception
   */
  public List<String> getCaseForType(String caseType) throws IOException, AuthenticationException {
    String sql = String.format(LIMIT_SQL, "id, caseref", "casesvc.case", "sampleunittype = '" + caseType + "'", "1");
    return postgresResponseAware.getRecord(sql);
  }
}
