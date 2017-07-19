package uk.gov.ons.ctp.response.action.util;

import java.io.IOException;
import java.util.Properties;

import org.apache.http.auth.AuthenticationException;

import uk.gov.ons.ctp.util.HTTPResponseAware;
import uk.gov.ons.ctp.util.PostgresResponseAware;
import uk.gov.ons.ctp.util.World;

/**
 * Created by Stephen Goddard on 03/05/16.
 */
public class ActionPlanJobResponseAware {
  private World world;
  private HTTPResponseAware responseAware;
  private PostgresResponseAware postgresResponseAware;

  /**
   * Constructor - also gets singleton of http request runner
   *
   * @param newWorld class with application and environment properties
   * @param dbResponseAware DB runner
   */
  public ActionPlanJobResponseAware(final World newWorld, PostgresResponseAware dbResponseAware) {
    this.world = newWorld;
    this.responseAware = HTTPResponseAware.getInstance();
    this.postgresResponseAware = dbResponseAware;
  }

  /**
   * Action Plan Service Endpoints.
   */

  /**
   * @actionplanjob Service - /actionplans/jobs/{actionPlanJobId} get endpoints.
   *
   * @param actionPlanJobId action plan job id
   * @throws IOException IO exception
   * @throws AuthenticationException authentication exception
   */
  public void invokeActionPlanJobEndpoints(String actionPlanJobId) throws IOException, AuthenticationException {
    if (actionPlanJobId == null || actionPlanJobId.length() == 0) {
      actionPlanJobId = world.getIdFromDB("id", "action.actionplanjob", "1", postgresResponseAware);
    }
    final String url = String.format("/actionplans/jobs/%s", actionPlanJobId);
    responseAware.invokeGet(world.getUrl(url, "actionsvc"));
  }

  /**
   * @actionplanjob Service - /actionplans/{actionPlanId}/jobs get endpoints.
   *
   * @param actionPlanId action plan id
   * @throws IOException IO exception
   * @throws AuthenticationException authentication exception
   */
  public void invokeActionPlanJobListEndpoints(String actionPlanId) throws IOException, AuthenticationException {
    final String url = String.format("/actionplans/%s/jobs", actionPlanId);
    responseAware.invokeGet(world.getUrl(url, "actionsvc"));
  }

  /**
   * @actionplanjob Service - /actionplans/{actionPlanId}/jobs post endpoints.
   *
   * @param actionPlanId action plan id
   * @param properties for JSON payload
   * @throws IOException IO exception
   * @throws AuthenticationException authentication exception
   */
  public void invokeExecuteActionPlanJobEndpoints(String actionPlanId, Properties properties)
      throws IOException, AuthenticationException {
    if (actionPlanId == null || actionPlanId.length() == 0) {
      actionPlanId = world.getIdFromDB("id", "action.actionplanjob", "1", postgresResponseAware);
    }
    final String url = String.format("/actionplans/%s/jobs", actionPlanId);
    responseAware.invokeJsonPost(world.getUrl(url, "actionsvc"), properties);
  }

}
