package uk.gov.ons.ctp.response.actionexporter.util;

import com.jayway.jsonpath.JsonPath;
import net.minidev.json.JSONArray;
import org.apache.http.auth.AuthenticationException;
import org.springframework.web.multipart.MultipartFile;
import uk.gov.ons.ctp.util.HTTPResponseAware;
import uk.gov.ons.ctp.util.World;

import java.io.IOException;
import java.util.Properties;
import java.util.UUID;

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
    responseAware.invokeGet(world.getUrl(url, "actionexp"));
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
    responseAware.invokeGet(world.getUrl(url, "actionexp"));
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
    responseAware.invokeGet(world.getUrl(url, "actionexp"));
    JSONArray jsonArray = (JSONArray) JsonPath.read(responseAware.getBody(), "$");
    String arrayString = jsonArray.toJSONString();
    String[] split =  arrayString.split(":");
    String reportId = split[5].substring(0, split[5].length() - 2);
    url = String.format("/reports/%s", reportId);
    responseAware.invokeGet(world.getUrl(url, "actionexp"));
  }

  /**
   * /actionrequests get endpoints for actionexporter
   *
   * @throws IOException IO exception
   * @throws AuthenticationException authentication exception
   */
  public void invokeActionExporterAllActionRequestsEndpoint() throws IOException, AuthenticationException {
    responseAware.invokeGet(world.getUrl("/actionrequests", "actionexp"));
  }

  /**
   * /templates get endpoints for actionexporter
   *
   * @throws IOException IO exception
   * @throws AuthenticationException authentication exception
   */
  public void invokeActionExporterAllTemplatesEndpoint() throws IOException, AuthenticationException {
    responseAware.invokeGet(world.getUrl("/templates", "actionexp"));
  }

  /**
   * /actionrequests/{actionId} get endpoints for actionexporter
   *
   * @param actionId the Id to be checked for
   * @throws IOException IO exception
   * @throws AuthenticationException authentication exception
   */
  public void invokeActionExporterEndpoint(UUID actionId) throws IOException, AuthenticationException {
    final String url = String.format("/actionrequests/%s", actionId);
    responseAware.invokeGet(world.getUrl(url, "actionexp"));
  }

  /**
   * @actionexporter - /actionrequests/{actionId} post endpoints.
   *
   * @param actionId action id
   * @param properties for JSON payload
   * @throws IOException IO exception
   * @throws AuthenticationException authentication exception
   */
  public void invokeExecuteActionExporterEndpoints(String actionId, Properties properties)
          throws IOException, AuthenticationException {
    final String url = String.format("/actionrequests/%s", actionId);
    responseAware.invokeJsonPost(world.getActionExporterEndpoint(url), properties);
  }

  /**
   * /actionrequests/{actionId} get endpoints for actionexporter
   *
   * @param templateName the templateName to be checked for
   * @throws IOException IO exception
   * @throws AuthenticationException authentication exception
   */
  public void invokeActionExporterTemplateEndpoint(String templateName) throws IOException, AuthenticationException {
    final String url = String.format("/templates/%s", templateName);
    responseAware.invokeGet(world.getUrl(url, "actionexp"));
  }

  /**
   * /templates/{templateName} post endpoint.
   *
   * @param templateName template name
   * @param file to be sent to ActionExporter Template Endpoint
   * @throws IOException IO exception
   * @throws AuthenticationException authentication exception
   */
  public void invokeTemplateEndpoint(String templateName, MultipartFile file) throws IOException, AuthenticationException {
    final String url = String.format("/templates/%s", templateName);
    responseAware.invokeMultipartFilePost(world.getActionExporterEndpoint(url), file);
  }

  /**
   * /templatemappings get endpoint for actionexporter
   *
   * @throws IOException IO exception
   * @throws AuthenticationException authentication exception
   */
  public void invokeActionExporterAllTemplateMappingEndpoint() throws IOException, AuthenticationException {
    responseAware.invokeGet(world.getUrl("/templatemappings", "actionexp"));
  }

  /**
   * /templatemappings/{actionType} get endpoint for actionexporter
   *
   * @param actionType the action type to be checked for
   * @throws IOException IO exception
   * @throws AuthenticationException authentication exception
   */
  public void invokeActionExporterTemplateMappingEndpoint(String actionType) throws IOException, AuthenticationException {
    final String url = String.format("/templatemappings/%s", actionType);
    responseAware.invokeGet(world.getUrl(url, "actionexp"));
  }

  /**
   * /templatemappings post endpoint.
   *
   * @param file to be sent to ActionExporter Template Mappings Endpoint
   * @throws IOException IO exception
   * @throws AuthenticationException authentication exception
   */
  public void invokeTemplateMappingsEndpoint(MultipartFile file) throws IOException, AuthenticationException {
    final String url = "/templatemappings";
    responseAware.invokeMultipartFilePost(world.getActionExporterEndpoint(url), file);
  }

}
