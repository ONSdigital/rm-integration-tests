package uk.gov.ons.ctp.response.actionexporter.util;

import java.io.IOException;

import org.apache.http.auth.AuthenticationException;

import com.jayway.jsonpath.JsonPath;

import net.minidev.json.JSONArray;
import uk.gov.ons.ctp.util.HTTPResponseAware;
import uk.gov.ons.ctp.util.World;

/**
 * Created by Kieran Wardle on 09/02/17.
 */
public class ReportResponseAwareAE {

  private World world;
  private HTTPResponseAware responseAware;

  /**
   * Constructor - also gets singleton of http request runner.
   *
   * @param newWorld class with application and environment properties
   */
  public ReportResponseAwareAE(final World newWorld) {
    this.world = newWorld;
    this.responseAware = HTTPResponseAware.getInstance();
  }

  /**
   * /reports/types get endpoints for actionexporter
   *
   * @throws IOException IO exception
   * @throws AuthenticationException authentication exception
   */
  public void invokeReportEndpoint() throws IOException, AuthenticationException {
    final String url = "/reports/types";
    responseAware.invokeGet(world.getActionExporterEndpoint(url));
  }

  /**
   * /reports/types/{reportType} get endpoints for actionexporter
   *
   * @param reportType report type to get list of reports for
   * @throws IOException IO exception
   * @throws AuthenticationException authentication exception
   */
  public void invokeReportListEndpoint(String reportType) throws IOException, AuthenticationException {
    final String url = String.format("/reports/types/%s", reportType);
    responseAware.invokeGet(world.getActionExporterEndpoint(url));
  }

  /**
   * /reports/{reportId} get endpoints for actionexporter
   *
   * @param reportType report type to get list of reports for
   * @throws IOException IO exception
   * @throws AuthenticationException authentication exception
   */
  public void invokeReportContentEndpoint(String reportType) throws IOException, AuthenticationException {
    String url = String.format("/reports/types/%s", reportType);
    responseAware.invokeGet(world.getActionExporterEndpoint(url));
    JSONArray jsonArray = (JSONArray) JsonPath.read(responseAware.getBody(), "$");
    String arrayString = jsonArray.toJSONString();
    String[] split =  arrayString.split(":");
    String reportId = split[5].substring(0, split[5].length() - 2);
    url = String.format("/reports/%s", reportId);
    responseAware.invokeGet(world.getActionExporterEndpoint(url));
  }

  /**
   * /actionrequests/{actionId} get endpoints for actionexporter
   *
   * @param actionId the Id to be checked for
   * @throws IOException IO exception
   * @throws AuthenticationException authentication exception
   */
  public void invokeActionExporterEndpoint(String actionId) throws IOException, AuthenticationException {
    final String url = String.format("/actionrequests/%s", actionId);
    responseAware.invokeGet(world.getActionExporterEndpoint(url));
  }
}
