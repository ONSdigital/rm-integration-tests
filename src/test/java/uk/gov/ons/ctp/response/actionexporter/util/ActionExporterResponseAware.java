package uk.gov.ons.ctp.response.actionexporter.util;

import org.apache.http.auth.AuthenticationException;
import org.springframework.web.multipart.MultipartFile;

import uk.gov.ons.ctp.response.common.util.PostgresResponseAware;
import uk.gov.ons.ctp.util.HTTPResponseAware;
import uk.gov.ons.ctp.util.World;

import java.io.IOException;
import java.util.Properties;
import java.util.UUID;

/**
 * Created by Stephen Goddard on 03/05/16.
 */
public class ActionExporterResponseAware {

  private static final String GET_ACTION_REQUESTS_ALL_URL = "/actionrequests";
  private static final String GET_ACTION_REQUESTS_URL = "/actionrequests/%s";
  private static final String POST_ACTION_REQUESTS_URL = "/actionrequests/%s";
  private static final String GET_TEMPLATES_ALL_URL = "/templates";
  private static final String GET_TEMPLATES_URL = "/templates/%s";
  private static final String POST_TEMPLATE_URL = "/templates/%s";
  private static final String GET_TEMPLATE_MAPPINGS_ALL_URL = "/templatemappings";
  private static final String GET_TEMPLATE_MAPPINGS_URL = "/templatemappings/%s";
  private static final String POST_TEMPLATE_MAPPINGS_URL = "/templatemappings";
  private static final String GET_REPORTS_URL = "/reports/types";
  private static final String GET_REPORT_TYPE_URL = "/reports/types/%s";
  private static final String GET_REPORT_URL = "/reports/%s";
  private static final String INFO_URL = "/info";
  private static final String USERNAME = "cuc.collect.username";
  private static final String PASSWORD = "cuc.collect.password";
  private static final String SERVICE = "actionexp";
  private World world;
  private HTTPResponseAware responseAware;
  private final PostgresResponseAware postgresResponseAware;

  /**
   * Constructor - also gets singleton of http request runner
   *
   * @param newWorld class with application and environment properties
   * @param dbResponseAware DB runner
   */
  public ActionExporterResponseAware(final World newWorld, final PostgresResponseAware dbResponseAware) {
    this.world = newWorld;
    this.responseAware = HTTPResponseAware.getInstance();
    responseAware.enableBasicAuth(world.getProperty(USERNAME), world.getProperty(PASSWORD));
    this.postgresResponseAware = dbResponseAware;
  }

  /**
   *
   * Action Exporter Endpoints.
   */
  /**
   * /actionrequests get endpoints for actionexporter
   *
   * @throws IOException IO exception
   * @throws AuthenticationException authentication exception
   */
  public void invokeActionExporterAllActionRequestsEndpoint() throws IOException, AuthenticationException {
    responseAware.invokeGet(world.getUrl(GET_ACTION_REQUESTS_ALL_URL, SERVICE));
  }

  /**
   * /actionrequests/{actionId} get endpoints for actionexporter
   *
   * @param actionId the Id to be checked for
   * @throws IOException IO exception
   * @throws AuthenticationException authentication exception
   */
  public void invokeActionExporterEndpoint(UUID actionId) throws IOException, AuthenticationException {
    final String url = String.format(GET_ACTION_REQUESTS_URL, actionId);
    responseAware.invokeGet(world.getUrl(url, SERVICE));
  }

  /**
   * /actionrequests/{actionId} post endpoints.
   *
   * @param actionId action id
   * @param properties for JSON payload
   * @throws IOException IO exception
   * @throws AuthenticationException authentication exception
   */
  public void invokeExecuteActionExporterEndpoints(String actionId, Properties properties)
          throws IOException, AuthenticationException {
    final String url = String.format(POST_ACTION_REQUESTS_URL, actionId);
    responseAware.invokeJsonPost(world.getUrl(url, SERVICE), properties);
  }

  /**
   * /templates get endpoints for actionexporter
   *
   * @throws IOException IO exception
   * @throws AuthenticationException authentication exception
   */
  public void invokeActionExporterTemplatesAllEndpoint() throws IOException, AuthenticationException {
    responseAware.invokeGet(world.getUrl(GET_TEMPLATES_ALL_URL, SERVICE));
  }


  /**
   * /templates/{templateName} get endpoints for actionexporter
   *
   * @param templateName the templateName to be checked for
   * @throws IOException IO exception
   * @throws AuthenticationException authentication exception
   */
  public void invokeActionExporterTemplateEndpoint(String templateName) throws IOException, AuthenticationException {
    final String url = String.format(GET_TEMPLATES_URL, templateName);
    responseAware.invokeGet(world.getUrl(url, SERVICE));
  }

  /**
   * /templates/{templateName} post endpoint.
   *
   * @param templateName template name
   * @param file to be sent to ActionExporter Template Endpoint
   * @throws IOException IO exception
   * @throws AuthenticationException authentication exception
   */
  public void invokePostActionExporterTemplateEndpoint(String templateName, MultipartFile file) throws IOException,
          AuthenticationException {
    final String url = String.format(POST_TEMPLATE_URL, templateName);
    responseAware.invokeMultipartFilePost(world.getUrl(url, SERVICE), file);
  }

  /**
   * /templatemappings get endpoint for actionexporter
   *
   * @throws IOException IO exception
   * @throws AuthenticationException authentication exception
   */
  public void invokeActionExporterTemplateMappingsAllEndpoint() throws IOException, AuthenticationException {
    responseAware.invokeGet(world.getUrl(GET_TEMPLATE_MAPPINGS_ALL_URL, SERVICE));
  }

  /**
   * /templatemappings/{actionType} get endpoint for actionexporter
   *
   * @param actionType the action type to be checked for
   * @throws IOException IO exception
   * @throws AuthenticationException authentication exception
   */
  public void invokeActionExporterTemplateMappingsEndpoint(String actionType) throws IOException,
          AuthenticationException {
    final String url = String.format(GET_TEMPLATE_MAPPINGS_URL, actionType);
    responseAware.invokeGet(world.getUrl(url, SERVICE));
  }

  /**
   * /templatemappings post endpoint.
   *
   * @param file to be sent to ActionExporter Template Mappings Endpoint
   * @throws IOException IO exception
   * @throws AuthenticationException authentication exception
   */
  public void invokePostActionExporterTemplateMappingsEndpoint(MultipartFile file) throws IOException,
          AuthenticationException {
    responseAware.invokeMultipartFilePost(world.getUrl(POST_TEMPLATE_MAPPINGS_URL, SERVICE), file);
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

  /**
   * Test get request for /reports/types
   *
   * @throws IOException pass the exception
   * @throws AuthenticationException pass the exception
   */
  public void invokeGetAllReportsEndpoint() throws IOException, AuthenticationException {
    responseAware.invokeGet(world.getUrl(GET_REPORTS_URL, SERVICE));
  }

  /**
   * Test get request for /reports/types/{reportTypes}
   *
   * @param reportType to be retrieved
   * @throws IOException pass the exception
   * @throws AuthenticationException pass the exception
   */
  public void invokeGetTypeReportsEndpoint(String reportType) throws IOException, AuthenticationException {
    final String url = String.format(GET_REPORT_TYPE_URL, reportType);
    responseAware.invokeGet(world.getUrl(url, SERVICE));
  }

  /**
   * Test get request for /reports/{reportId}
   *
   * @param reportId to be retrieved
   * @throws IOException pass the exception
   * @throws AuthenticationException pass the exception
   */
  public void invokeGetReportsByIdEndpoint(String reportId) throws IOException, AuthenticationException {
    if (reportId == null || reportId.length() == 0) {
      reportId = postgresResponseAware.getFieldFromRecord("id", "actionexporter.report");
    }
    final String url = String.format(GET_REPORT_URL, reportId);
    responseAware.invokeGet(world.getUrl(url, SERVICE));
  }
}
