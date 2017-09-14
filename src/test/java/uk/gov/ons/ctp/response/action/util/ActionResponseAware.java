package uk.gov.ons.ctp.response.action.util;

import java.io.IOException;
import java.util.Properties;

import org.apache.http.auth.AuthenticationException;

import uk.gov.ons.ctp.response.common.util.PostgresResponseAware;
import uk.gov.ons.ctp.util.HTTPResponseAware;
import uk.gov.ons.ctp.util.World;

/**
 * Created by Stephen Goddard on 03/05/16.
 */
public class ActionResponseAware {
  private static final String GET_ACTIONS_FILTER_URL = "/actions%s";
  private static final String PUT_FEEDBACK_FILTER_URL = "/actions/%s/feedback";
  private static final String GET_ACTIONS_ACTIONID_URL = "/actions/%s";
  private static final String GET_ACTIONS_CASEID_URL = "/actions/case/%s";
  private static final String PUT_ACTIONS_CASEID_URL = "/actions/caseid/%s";
  private static final String POST_ACTIONS_URL = "/actions";
  private static final String PUT_ACTIONS_ACTIONID_URL = "/actions/%s";
  private static final String INFO_URL = "/info";
  private static final String USERNAME = "cuc.collect.username";
  private static final String PASSWORD = "cuc.collect.password";
  private static final String SERVICE = "actionsvc";

  private World world;
  private HTTPResponseAware responseAware;
  private PostgresResponseAware postgresResponseAware;

  /**
   * Constructor - also gets singleton of http request runner
   *
   * @param newWorld class with application and environment properties
   * @param dbResponseAware DB runner
   */
  public ActionResponseAware(final World newWorld, final PostgresResponseAware dbResponseAware) {
    this.world = newWorld;
    this.responseAware = HTTPResponseAware.getInstance();
    responseAware.enableBasicAuth(world.getProperty(USERNAME), world.getProperty(PASSWORD));
    this.postgresResponseAware = dbResponseAware;
  }

  /**
   *
   * Action Service Endpoints.
   */

  /**
   * @action Service - /actions get endpoints.
   *
   * @param filter optional filter value
   * @throws IOException IO exception
   * @throws AuthenticationException authentication exception
   */
  public void invokeActionsEndpoint(String filter) throws IOException, AuthenticationException {
    final String url = String.format(GET_ACTIONS_FILTER_URL, filter);
    responseAware.invokeGet(world.getUrl(url, SERVICE));
  }

  /**
   * @action Service - /actions/{actionId}/feedback post endpoints.
   *
   * @param actionId for action to have feedback added
   * @param properties values to be posted using JSON
   * @throws IOException IO exception
   * @throws AuthenticationException authentication exception
   */
  public void invokePutActionsActionIdFeedbackEndpoint(String actionId, Properties properties)
      throws IOException, AuthenticationException {
    if (actionId == null || actionId.length() == 0) {
      actionId = postgresResponseAware.getFieldFromRecord("id", "action.action");
      properties.put("id", actionId);
    }

    final String url = String.format(PUT_FEEDBACK_FILTER_URL, actionId);
    responseAware.invokeJsonPut(world.getUrl(url, SERVICE), properties);
  }

  /**
   * @action Service - /actions/{actionId} get endpoints.
   *
   * @param actionId action id
   * @throws IOException IO exception
   * @throws AuthenticationException authentication exception
   */
  public void invokeActionsIdEndpoint(String actionId) throws IOException, AuthenticationException {
    if (actionId == null || actionId.length() == 0) {
      actionId = postgresResponseAware.getFieldFromRecord("id", "action.action");
    }

    final String url = String.format(GET_ACTIONS_ACTIONID_URL, actionId);
    responseAware.invokeGet(world.getUrl(url, SERVICE));
  }

  /**
   * @action Service - /actions/case/{caseId} get endpoints.
   *
   * @param caseId case id
   * @throws IOException IO exception
   * @throws AuthenticationException authentication exception
   */
  public void invokeActionsCaseIdEndpoint(String caseId) throws IOException, AuthenticationException {
    if (caseId == null || caseId.length() == 0) {
      caseId = postgresResponseAware.getFieldFromRecord("caseid", "action.action");
    }

    final String url = String.format(GET_ACTIONS_CASEID_URL, caseId);
    responseAware.invokeGet(world.getUrl(url, "actionsvc"));
  }

  /**
   * @action Service - /actions/case/{caseId} put endpoints.
   *
   * @param caseId case id
   * @param properties values to be put using JSON
   * @throws IOException IO exception
   * @throws AuthenticationException authentication exception
   */
  public void invokePutActionsCaseIdEndpoint(String caseId, Properties properties)
      throws IOException, AuthenticationException {
    if (caseId == null || caseId.length() == 0) {
      caseId = postgresResponseAware.getFieldFromRecord("caseid", "action.action");
    }
    final String url = String.format(PUT_ACTIONS_CASEID_URL, caseId);
    responseAware.invokeJsonPut(world.getUrl(url, "actionsvc"), properties);
  }

  /**
   * @action Service - /actions post endpoints.
   *
   * @param caseId to post
   * @param properties values to be posted using JSON
   * @throws IOException IO exception
   * @throws AuthenticationException authentication exception
   */
  public void invokePostActionsEndpoint(String caseId, Properties properties)
      throws IOException, AuthenticationException {
    if (caseId == null || caseId.length() == 0) {
      caseId = postgresResponseAware.getFieldFromRecord("caseid", "action.action");
    }
    properties.put("caseId", caseId);
    responseAware.invokeJsonPost(world.getUrl(POST_ACTIONS_URL, "actionsvc"), properties);
  }

  /**
   * @action Service - /actions/{actionid} put endpoints.
   *
   * @param actionId to be put
   * @param properties values to be posted using JSON
   * @throws IOException IO exception
   * @throws AuthenticationException authentication exception
   */
  public void invokePutActionsEndpoint(String actionId, Properties properties)
      throws IOException, AuthenticationException {
    if (actionId == null || actionId.length() == 0) {
      actionId = postgresResponseAware.getFieldFromRecord("id", "action.action");
    }
    final String url = String.format(PUT_ACTIONS_ACTIONID_URL, actionId);
    responseAware.invokeJsonPut(world.getUrl(url, SERVICE), properties);
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
}
