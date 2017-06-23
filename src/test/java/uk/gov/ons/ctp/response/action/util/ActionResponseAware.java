package uk.gov.ons.ctp.response.action.util;

import java.io.IOException;
import java.util.Properties;

import org.apache.http.auth.AuthenticationException;
import org.apache.http.entity.ContentType;

import uk.gov.ons.ctp.util.HTTPResponseAware;
import uk.gov.ons.ctp.util.World;

/**
 * Created by Stephen Goddard on 03/05/16.
 */
public class ActionResponseAware {

  private World world;
  private HTTPResponseAware responseAware;

  /**
   * Constructor - also gets singleton of http request runner
   *
   * @param newWorld class with application and environment properties
   */
  public ActionResponseAware(final World newWorld) {
    this.world = newWorld;
    this.responseAware = HTTPResponseAware.getInstance();
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
    final String url = String.format("/actions%s", filter);
    responseAware.invokeGet(world.getActionServiceEndpoint(url));
  }

//  public String invokeActionsEndpointReturnCaseId(String filter) throws IOException, AuthenticationException {
//    final String url = String.format("/actions%s", filter);
//    responseAware.invokeGet(world.getActionServiceEndpoint(url));
//
//    String id = getIdFromString(responseAware.getBody(), "caseId\":", 9);
//
//    return id;
//  }

//  private String getIdFromString(String body, String startStr, int offset) {
//    int start = body.indexOf(startStr);
//    String tempStr = body.substring(start + offset);
//
//    int end = tempStr.indexOf("\"");
//    String id = tempStr.substring(0, end);
//
//    return id;
//  }

  /**
   * @action Service - /actions post endpoints.
   *
   * @param properties values to be posted using JSON
   * @throws IOException IO exception
   * @throws AuthenticationException authentication exception
   */
  public void invokePostActionsEndpoint(Properties properties) throws IOException, AuthenticationException {
    final String url = "/actions";
    responseAware.invokeJsonPost(world.getActionServiceEndpoint(url), properties);
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
    final String url = String.format("/actions/%s/feedback", actionId);
    responseAware.invokeJsonPut(world.getActionServiceEndpoint(url), properties);
  }

  /**
   * @action Service - /actions/{actionId} get endpoints.
   *
   * @param actionId action id
   * @throws IOException IO exception
   * @throws AuthenticationException authentication exception
   */
  public void invokeActionsIdEndpoint(String actionId) throws IOException, AuthenticationException {
    final String url = String.format("/actions/%s", actionId);
    responseAware.invokeGet(world.getActionServiceEndpoint(url));
  }

  /**
   * @action Service - /actions/{actionId} put endpoints.
   *
   * @param actionId action id
   * @param properties values to be posted using JSON
   * @throws IOException IO exception
   * @throws AuthenticationException authentication exception
   */
  public void invokePutActionsIdEndpoint(String actionId, Properties properties)
      throws IOException, AuthenticationException {
    final String url = String.format("/actions/%s", actionId);
    responseAware.invokeJsonPut(world.getActionServiceEndpoint(url), properties);
  }

  /**
   * @action Service - /actions/case/{caseId} get endpoints.
   *
   * @param caseId case id
   * @throws IOException IO exception
   * @throws AuthenticationException authentication exception
   */
  public void invokeActionsCaseIdEndpoint(String caseId) throws IOException, AuthenticationException {
    final String url = String.format("/actions/case/%s", caseId);
    responseAware.invokeGet(world.getActionServiceEndpoint(url));
  }

  /**
   * @action Service - /actions/case/{caseId}/cancel put endpoints.
   *
   * @param caseId case id
   * @throws IOException IO exception
   * @throws AuthenticationException authentication exception
   */
  public void invokePutActionsCancelEndpoint(String caseId) throws IOException, AuthenticationException {
    final String url = String.format("/actions/case/%s/cancel", caseId);
    responseAware.invokePut(world.getActionServiceEndpoint(url), "", ContentType.APPLICATION_JSON);
  }
}
