package uk.gov.ons.ctp.response.casesvc.util;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;
import java.util.Properties;

import org.apache.http.auth.AuthenticationException;

import com.jayway.jsonpath.JsonPath;

import uk.gov.ons.ctp.response.common.util.PostgresResponseAware;
import uk.gov.ons.ctp.response.iacsvc.util.IacsvcResponseAware;
import uk.gov.ons.ctp.util.HTTPResponseAware;
import uk.gov.ons.ctp.util.World;

/**
 * Created by Stephen Goddard on 04/05/16.
 */
public class CaseResponseAware {
  private static final String WHERE_SQL = "SELECT %s FROM %s WHERE %s;";
  
  private static final String REPEAT_EVENT_SQL = //"SELECT %s FROM %s WHERE %s;";
  "select id, caseservice.partyid from casesvc.case caseservice inner join collectionexercise.sampleunit sample on caseservice.partyid = sample.partyid where sample.sampleunitref = '%s'";
  
  private static final String GET_CASEGROUP_URL = "/casegroups/%s";
  private static final String GET_CASE_CASEGROUP_URL = "/cases/casegroupid/%s";
  private static final String GET_IAC_URL = "/cases/iac/%s%s";
  private static final String GET_CASEID_URL = "/cases/%s%s";
  private static final String GET_PARTYID_URL = "/cases/partyid/%s%s";
  private static final String GET_EVENTS_URL = "/cases/%s/events";
  private static final String POST_EVENTS_URL = "/cases/%s/events";
  private static final String GET_CATEGORIES_URL = "/categories";
  private static final String GET_CATEGORY_NAME_URL = "/categories/name/%s";
  private static final String INFO_URL = "/info";
  private static final String USERNAME = "cuc.collect.username";
  private static final String PASSWORD = "cuc.collect.password";
  private static final String SERVICE = "casesvc";
  private World world;
  private HTTPResponseAware responseAware;
  private final PostgresResponseAware postgresResponseAware;


  /**
   * Constructor - also gets singleton of http request runner.
   *
   * @param newWorld class with application and environment properties
   * @param dbResponseAware DB runner
   */
  public CaseResponseAware(final World newWorld, final PostgresResponseAware dbResponseAware) {
    this.world = newWorld;
    this.responseAware = HTTPResponseAware.getInstance();
    responseAware.enableBasicAuth(world.getProperty(USERNAME), world.getProperty(PASSWORD));
    this.postgresResponseAware = dbResponseAware;
  }

  /**
   * Get body of response from run end point.
   *
   * @return String value of body
   * @throws Throwable pass the exception
   */
  public String getBody() {
    return responseAware.getBody();
  }

  /**
   * @caseresponse Service - /casegroup/{casegroupid} get end points.
   *
   * @param caseGroupId for case group
   * @throws IOException IO exception
   * @throws AuthenticationException authentication exception
   */
  public void invokeCasegroupIdEndpoint(String caseGroupId) throws IOException, AuthenticationException {
    if (caseGroupId == null || caseGroupId.length() == 0) {
      caseGroupId = postgresResponseAware.getFieldFromRecord("id", "casesvc.casegroup");
    }

    final String url = String.format(GET_CASEGROUP_URL, caseGroupId);
    responseAware.invokeGet(world.getUrl(url, SERVICE));
  }

  /**
   * @caseresponse Service - /cases/casegroupid/{casegroupid} get end points.
   *
   * @param caseGroupId case group id
   * @throws IOException IO exception
   * @throws AuthenticationException authentication exception
   */
  public void invokeCasesCasegroupEndpoint(String caseGroupId) throws IOException, AuthenticationException {
    if (caseGroupId == null || caseGroupId.length() == 0) {
      caseGroupId = postgresResponseAware.getFieldFromRecord("id", "casesvc.casegroup");
    }

    final String url = String.format(GET_CASE_CASEGROUP_URL, caseGroupId);
    responseAware.invokeGet(world.getUrl(url, SERVICE));
  }

  /**
   * @caseresponse Service - /cases/iac/{iac}{parameters} get end points.
   *
   * @param iac code to get case for
   * @param parameters required to pass to as parameters
   * @throws IOException IO exception
   * @throws AuthenticationException authentication exception
   */
  public void invokeCaseIACEndpoint(String iac, String parameters) throws IOException, AuthenticationException {
    if (iac == null || iac.length() == 0) {
      iac = postgresResponseAware.getFieldFromRecord("iac", "casesvc.case");
    }

    final String url = String.format(GET_IAC_URL, iac, parameters);
    responseAware.invokeGet(world.getUrl(url, SERVICE));
  }

  /**
   * @caseresponse Service - /cases/{caseId}{parameters} get end points.
   *
   * @param caseId case id
   * @param parameters required to pass to as parameters
   * @throws IOException IO exception
   * @throws AuthenticationException authentication exception
   */
  public void invokeCasesEndpoint(String caseId, String parameters) throws IOException, AuthenticationException {
    if (caseId == null || caseId.length() == 0) {
      caseId = postgresResponseAware.getFieldFromRecord("id", "casesvc.case");
    }
    final String url = String.format(GET_CASEID_URL, caseId, parameters);
    responseAware.invokeGet(world.getUrl(url, SERVICE));
  }

  /**
   * @caseresponse Service - /cases/partyid/{partyid}{parameters} get end points.
   *
   * @param caseId case id
   * @param parameters required to pass to as parameters
   * @throws IOException IO exception
   * @throws AuthenticationException authentication exception
   */
  public void invokePartyEndpoint(String caseId, String parameters) throws IOException, AuthenticationException {
    if (caseId == null || caseId.length() == 0) {
      caseId = postgresResponseAware.getFieldFromRecord("partyid", "casesvc.case");
    }
    final String url = String.format(GET_PARTYID_URL, caseId, parameters);
    responseAware.invokeGet(world.getUrl(url, SERVICE));
  }

  /**
   * @caseresponse Service - /cases/{caseId}/events get end points.
   *
   * @param caseId case id
   * @throws IOException IO exception
   * @throws AuthenticationException authentication exception
   */
  public void invokeCasesEventsEndpoint(String caseId) throws IOException, AuthenticationException {
    if (caseId == null || caseId.length() == 0) {
      caseId = postgresResponseAware.getFieldFromRecord("id", "casesvc.case");
    }
    final String url = String.format(GET_EVENTS_URL, caseId);
    responseAware.invokeGet(world.getUrl(url, SERVICE));
  }

  /**
   * @caseresponse Service - /cases/{caseId}/events post end points.
   *
   * @param caseId case id
   * @param properties required to pass
   * @throws IOException IO exception
   * @throws AuthenticationException authentication exception
   */
  public void invokePostCasesEventsEndpoint(String caseId, Properties properties)
      throws IOException, AuthenticationException {
    if (caseId == null || caseId.length() == 0) {
      String sql = String.format(WHERE_SQL, "id, partyid", "casesvc.case", "casepk = 10");
      List<String> result = postgresResponseAware.getRecord(sql);
      caseId = result.get(0);
      properties.put("partyId", result.get(1));
    }

    final String url = String.format(POST_EVENTS_URL, caseId);
    responseAware.invokeJsonPost(world.getUrl(url, SERVICE), properties);
  }

  /**
   * @caseresponse Service - /cases/{caseId}/events post end points for BI.
   *
   * @param unitType sample unit type
   * @param properties required to pass
   * @throws IOException IO exception
   * @throws AuthenticationException authentication exception
   * @throws SQLException sql exception
   * @throws ClassNotFoundException class not found exception
   */
  public void invokePostCasesEventsEndpointForBI(String unitType, Properties properties)
      throws IOException, AuthenticationException, ClassNotFoundException, SQLException {
    String sql = String.format(WHERE_SQL, "id, partyid", "casesvc.case", "sampleunittype = 'BI'");
    List<String> result = postgresResponseAware.getRecord(sql);
    properties.put("partyId", result.get(1));

    final String url = String.format(POST_EVENTS_URL, result.get(0));
    responseAware.invokeJsonPost(world.getUrl(url, SERVICE), properties);
  }

  public void invokePostCasesEventsEndpointRepeated(int repeat, String ruRef, Properties properties)
      throws IOException, AuthenticationException, ClassNotFoundException, SQLException {
    System.out.println("Get sample unit ref: " + ruRef);
    
    String sql = String.format(REPEAT_EVENT_SQL, ruRef);
    List<String> result = postgresResponseAware.getRecord(sql);
    properties.put("partyId", result.get(1));
    
    for (int c = 1; c <= repeat; c++) {
      System.out.println(c + " Create event...");
      final String url = String.format(POST_EVENTS_URL, result.get(0));
      responseAware.invokeJsonPost(world.getUrl(url, SERVICE), properties);
    }
  }

  /**
   * @caseresponse Service - /categories get end points.
   * @throws IOException IO exception
   * @throws AuthenticationException authentication exception
   */
  public void invokeCategoriesEndpoint() throws IOException, AuthenticationException {
    responseAware.invokeGet(world.getUrl(GET_CATEGORIES_URL, SERVICE));
  }

  /**
   * @caseresponse Service - /categories/name/{categoryName} get end points.
   *
   * @param categoryName category id
   * @throws IOException IO exception
   * @throws AuthenticationException authentication exception
   */
  public void invokeCategoriesEndpoint(String categoryName) throws IOException, AuthenticationException {
    final String url = String.format(GET_CATEGORY_NAME_URL, categoryName);
    responseAware.invokeGet(world.getUrl(url, SERVICE));
  }

  /**
   * Test post request for /info response
   * @throws IOException pass the exception
   * @throws AuthenticationException pass the exception
   */
  public void invokeInfoEndpoint() throws IOException, AuthenticationException {
    responseAware.invokeGet(world.getUrl(INFO_URL, SERVICE));
  }


  // Journey Methods

  /**
   * @caseresponse Get new case using - /cases/{caseId}{parameters} get end point. Get caseId from DB first.
   *
   * @param params URL parameters
   * @throws IOException IO exception
   * @throws AuthenticationException authentication exception
   */
  public void invokeCasesEndpointForNewUnknownCase(String params) throws IOException, AuthenticationException {
    String sql = String.format(WHERE_SQL, "id", "casesvc.case", "sampleunittype = 'BI' and casepk = 501");
    List<String> result = postgresResponseAware.getRecord(sql);
    invokeCasesEndpoint(result.get(0).toString(), params);
  }

  /**
   * @iac Service - /iacs/{iac} get endoints. Get iac from previous call to get caseid.
   *
   * @throws IOException IO exception
   * @throws AuthenticationException authentication exception
   */
  public void invokeGetIACEndpointForCase() throws IOException, AuthenticationException {
    String testCaseid = JsonPath.read(responseAware.getBody(), "$." + "caseId");
    String sql = String.format(WHERE_SQL, "iac", "casesvc.case", "id = '" + testCaseid + "'");
    List<String> result = postgresResponseAware.getRecord(sql);

    IacsvcResponseAware iacService = new IacsvcResponseAware(world, postgresResponseAware);
    iacService.invokeGetIacEndpoint(result.get(0));
  }

  /**
   * @caseresponse Get new case using - /cases/partyid/{partyid}{parameters} Get partyId from DB first.
   *
   * @throws IOException IO exception
   * @throws AuthenticationException authentication exception
   */
  public void invokeCasesEndpointForNewCaseParty() throws IOException, AuthenticationException {
    String sql = String.format(WHERE_SQL, "partyid", "casesvc.case", "sampleunittype = 'BI' and casepk = 501");
    List<String> result = postgresResponseAware.getRecord(sql);
    invokePartyEndpoint(result.get(0).toString(), "");
  }
}
