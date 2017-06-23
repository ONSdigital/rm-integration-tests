package uk.gov.ons.ctp.response.casesvc.util;

import java.io.IOException;

import org.apache.http.auth.AuthenticationException;

import com.jayway.jsonpath.JsonPath;

import net.minidev.json.JSONArray;
import uk.gov.ons.ctp.util.HTTPResponseAware;
import uk.gov.ons.ctp.util.World;

/**
 * Created by Kieran Wardle on 09/02/17.
 */
public class ReportResponseAware {

  private World world;
  private HTTPResponseAware responseAware;

  /**
   * Constructor - also gets singleton of http request runner.
   *
   * @param newWorld class with application and environment properties
   */
  public ReportResponseAware(final World newWorld) {
    this.world = newWorld;
    this.responseAware = HTTPResponseAware.getInstance();
  }

  /**
   * /reports/types get endoints for casesvc
   *
   * @throws IOException IO exception
   * @throws AuthenticationException authentication exception
   */
  public void invokeReportEndpoint() throws IOException, AuthenticationException {
    final String url = "/reports/types";
//    responseAware.invokeGet(world.getCaseframeserviceEndpoint(url));
  }

  /**
   * /reports/types/{reportType} get endoints for casesvc
   *
   * @param reportType report type to get list of reports for
   * @throws IOException IO exception
   * @throws AuthenticationException authentication exception
   */
  public void invokeReportListEndpoint(String reportType) throws IOException, AuthenticationException {
    final String url = String.format("/reports/types/%s", reportType);
//    responseAware.invokeGet(world.getCaseframeserviceEndpoint(url));
  }

  /**
   * /reports/{reportId} get endoints for casesvc
   *
   * @param reportType report type to get list of reports for
   * @throws IOException IO exception
   * @throws AuthenticationException authentication exception
   */
  public void invokeReportContentEndpoint(String reportType) throws IOException, AuthenticationException {
    String url = String.format("/reports/types/%s", reportType);
//    responseAware.invokeGet(world.getCaseframeserviceEndpoint(url));
    JSONArray jsonArray = (JSONArray) JsonPath.read(responseAware.getBody(), "$");
    String arrayString = jsonArray.toJSONString();
    String[] split =  arrayString.split(":");
    String reportId = split[5].substring(0, split[5].length() - 2);
    url = String.format("/reports/%s", reportId);
//    responseAware.invokeGet(world.getCaseframeserviceEndpoint(url));
  }
}
