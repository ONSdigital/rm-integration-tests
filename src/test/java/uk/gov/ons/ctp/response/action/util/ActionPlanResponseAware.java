package uk.gov.ons.ctp.response.action.util;

import java.io.IOException;
import java.util.Properties;

import org.apache.http.auth.AuthenticationException;

import uk.gov.ons.ctp.util.HTTPResponseAware;
import uk.gov.ons.ctp.util.World;

/**
 * Created by Stephen Goddard on 03/05/16.
 */
public class ActionPlanResponseAware {
  private static final String POST_ACTIONSPLAN_URL = "/actionplans/%s/jobs";
  private static final String USERNAME = "cuc.collect.username";
  private static final String PASSWORD = "cuc.collect.password";

  private World world;
  private HTTPResponseAware responseAware;

  /**
   * Constructor - also gets singleton of http request runner
   *
   * @param newWorld class with application and environment properties
   */
  public ActionPlanResponseAware(final World newWorld) {
    this.world = newWorld;
    this.responseAware = HTTPResponseAware.getInstance();
    responseAware.enableBasicAuth(world.getProperty(USERNAME), world.getProperty(PASSWORD));
  }

  /**
   * Action Plan Service Endpoints.
   */

  /**
   * @actionplan Service - /actionplans get endpoints.
   *
   * @throws IOException IO exception
   * @throws AuthenticationException authentication exception
   */
  public void invokeActionPlansEndpoint() throws IOException, AuthenticationException {
    final String url = "/actionplans";
    responseAware.invokeGet(world.getUrl(url, "actionsvc"));
  }

  /**
   * @actionplan Service - /actionplans/{actionPlanId} get endpoints.
   *
   * @param actionPlanId action plan id
   * @throws IOException IO exception
   * @throws AuthenticationException authentication exception
   */
  public void invokeActionPlanIdEndpoint(String actionPlanId) throws IOException, AuthenticationException {
    final String url = String.format("/actionplans/%s", actionPlanId);
    responseAware.invokeGet(world.getUrl(url, "actionsvc"));
  }

  /**
   * @actionplan Service - /actionplans/{actionPlanId} put endpoints.
   *
   * @param properties values to be posted using JSON
   * @throws IOException IO exception
   * @throws AuthenticationException authentication exception
   */
  public void invokePutActionPlanIdEndpoint(Properties properties)
      throws IOException, AuthenticationException {
    final String url = String.format("/actionplans/%s", properties.remove("id"));
    responseAware.invokeJsonPut(world.getUrl(url, "actionsvc"), properties);
  }

  /**
   * @actionplan Service - /actionplans/{actionPlanId}/jobs put endpoints.
   *
   * @param actionPlanId action plan id
   * @param properties values to be posted using JSON
   * @throws IOException IO exception
   * @throws AuthenticationException authentication exception
   */
  public void invokePostActionPlanIdEndpoint(String actionPlanId, Properties properties)
      throws IOException, AuthenticationException {
    final String url = String.format(POST_ACTIONSPLAN_URL, actionPlanId);
    responseAware.invokeJsonPost(world.getUrl(url, "actionsvc"), properties);
  }
}
