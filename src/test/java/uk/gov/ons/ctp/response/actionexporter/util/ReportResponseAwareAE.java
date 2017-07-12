package uk.gov.ons.ctp.response.actionexporter.util;

import com.jayway.jsonpath.JsonPath;
import net.minidev.json.JSONArray;
import org.apache.http.auth.AuthenticationException;
import uk.gov.ons.ctp.util.HTTPResponseAware;
import uk.gov.ons.ctp.util.World;

import java.io.IOException;

/**
 * Created by Kieran Wardle on 09/02/17.
 */
public class ReportResponseAwareAE {

  private static final String GET_REPORTS_URL = "/reports/%s";
  private static final String GET_REPORT_TYPES_ALL_URL = "/reports/types";
  private static final String GET_REPORT_TYPES_URL = "/reports/types/%s";
  private static final String SERVICE = "actionexp";
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
    responseAware.invokeGet(world.getUrl(GET_REPORT_TYPES_ALL_URL, SERVICE));
  }

  /**
   * /reports/types/{reportType} get endpoints for actionexporter
   *
   * @param reportType report type to get list of reports for
   * @throws IOException IO exception
   * @throws AuthenticationException authentication exception
   */
  public void invokeReportListEndpoint(String reportType) throws IOException, AuthenticationException {
    final String url = String.format(GET_REPORT_TYPES_URL, reportType);
    responseAware.invokeGet(world.getUrl(url, SERVICE));
  }

  /**
   * /reports/{reportId} get endpoints for actionexporter
   *
   * @param reportType report type to get list of reports for
   * @throws IOException IO exception
   * @throws AuthenticationException authentication exception
   */
  public void invokeReportContentEndpoint(String reportType) throws IOException, AuthenticationException {
    String url = String.format(GET_REPORT_TYPES_URL, reportType);
    responseAware.invokeGet(world.getUrl(url, SERVICE));
    JSONArray jsonArray = (JSONArray) JsonPath.read(responseAware.getBody(), "$");
    String arrayString = jsonArray.toJSONString();
    String[] split =  arrayString.split(":");
    String reportId = split[5].substring(0, split[5].length() - 2);
    url = String.format(GET_REPORTS_URL, reportId);
    responseAware.invokeGet(world.getUrl(url, SERVICE));
  }



}
