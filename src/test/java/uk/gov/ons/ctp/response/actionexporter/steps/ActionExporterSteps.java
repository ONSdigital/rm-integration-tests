package uk.gov.ons.ctp.response.actionexporter.steps;

import java.io.File;
import java.io.FileInputStream;
import java.util.List;
import java.util.Properties;
import java.util.UUID;

import org.apache.commons.compress.utils.IOUtils;
import org.springframework.mock.web.MockMultipartFile;
import org.springframework.web.multipart.MultipartFile;

import cucumber.api.java.en.Given;
import cucumber.api.java.en.When;
import uk.gov.ons.ctp.response.actionexporter.util.ActionExporterResponseAware;
import uk.gov.ons.ctp.util.World;

/**
 * Created by Edward Stevens on 12/07/17.
 */
public class ActionExporterSteps {
  private final ActionExporterResponseAware responseAware;
  private static final String FTL_LOCATION_KEY = "cuc.collect.actionexp.ftl.location";

  private final World world;

  /**
   * Constructor
   *
   * @param actionExporterResponseAware action exporter frame end point runner
   * @param newWorld new world property
   */
  public ActionExporterSteps(ActionExporterResponseAware actionExporterResponseAware, World newWorld) {
    this.responseAware = actionExporterResponseAware;
    this.world = newWorld;
  }

  /**
   * Test get request for /actionrequests for actionexporter
   *
   * @throws Throwable pass the exception
   */
  @When("^I make the GET call to the actionexporter endpoint for all action requests$")
  public void I_make_the_GET_call_to_the_actionexporter_endpoint_for_all_action_requests()
          throws Throwable {
    responseAware.invokeActionExporterAllActionRequestsEndpoint();
  }

  /**
   * Test get request for /actionrequests/{actionId} for actionexporter
   *
   * @param actionId the id of the action to be called
   * @throws Throwable pass the exception
   */
  @When("^I make the GET call to the actionexporter endpoint for the action id \"(.*?)\"$")
  public void I_make_the_GET_call_to_the_actionexporter_endpoint_for_the_action_id(UUID actionId)
      throws Throwable {
    responseAware.invokeActionExporterEndpoint(actionId);
  }

  /**
   * Test post request for /actionplans/{actionPlanId}/jobs
   *
   * @param postValues values to be posted using JSON
   * @throws Throwable pass the exception
   */
  @When("^I make the POST call to the actionexporter actionrequests endpoint for actionrequest with specific id$")
  public void i_make_the_POST_call_to_the_actionexporter_actionrequests_endpoint_for_actionrequest_with_specific_id(
          List<String> postValues) throws Throwable {
    Properties properties = new Properties();
    properties.put("createdBy", postValues.get(1));

    responseAware.invokeExecuteActionExporterEndpoints(postValues.get(0), properties);
  }

  /**
   * Test get request for /templates for actionexporter
   *
   * @throws Throwable pass the exception
   */
  @When("^I make the GET call to the actionexporter template endpoint for all templates$")
  public void I_make_the_GET_call_to_the_actionexporter_template_endpoint_for_all_templates()
          throws Throwable {
    responseAware.invokeActionExporterTemplatesAllEndpoint();
  }

  /**
   * Test get request for /templates/{templateName} for actionexporter
   *
   * @param templateName the name of the template to be retrieved
   * @throws Throwable pass the exception
   */
  @When("^I make the GET call to the actionexporter template endpoint for the template name \"(.*?)\"$")
  public void I_make_the_GET_call_to_the_actionexporter_template_endpoint_for_the_template_name(String templateName)
          throws Throwable {
    responseAware.invokeActionExporterTemplateEndpoint(templateName);
  }

  /**
   * Test post request for /templates/{templateName}
   *
   * @param template name of template to post
   * @throws Throwable pass the exception
   */
  @Given("^I make the POST call to the actionexporter template endpoint for template with specific name \"(.*?)\"$")
  public void i_make_the_POST_call_to_the_actionexporter_template_endpoint_for_template_with_specific_name(
        String template) throws Throwable {
    File file = new File(world.getProperty(FTL_LOCATION_KEY) + template + ".ftl");
    FileInputStream input = new FileInputStream(file);
    MultipartFile multipartFile = new MockMultipartFile(template, file.getName(),
        "text/plain", IOUtils.toByteArray(input));

    responseAware.invokePostActionExporterTemplateEndpoint(template, multipartFile);
  }

  /**
   * Test get request for /templatemappings for actionexporter
   *
   * @throws Throwable pass the exception
   */
  @When("^I make the GET call to the actionexporter template mapping endpoint for all template mappings$")
  public void I_make_the_GET_call_to_the_actionexporter_template_mapping_endpoint_for_all_template_mappings()
          throws Throwable {
    responseAware.invokeActionExporterTemplateMappingsAllEndpoint();
  }

  /**
   * Test get request for /templatemappings/{actionType} for actionexporter
   *
   * @param actionType the action type of the template to be retrieved
   * @throws Throwable pass the exception
   */
  @When("^I make the GET call to the actionexporter template mapping endpoint for the action type \"(.*?)\"$")
  public void I_make_the_GET_call_to_the_actionexporter_template_mapping_endpoint_for_the_action_type(String actionType)
          throws Throwable {
    responseAware.invokeActionExporterTemplateMappingsEndpoint(actionType);
  }

  /**
   * Test post request for /templatemappings/{actiontype}
   *
   * @param postValues to be in json
   * @throws Throwable pass the exception
   */
  @Given("^I make the POST call to the actionexporter template mapping endpoint$")
  public void i_make_the_POST_call_to_the_actionexporter_template_mapping_endpoint(List<String> postValues)
      throws Throwable {
    Properties properties = new Properties();
    properties.put("template", postValues.get(0));
    properties.put("fileNamePrefix", postValues.get(1));

    responseAware.invokePostActionExporterTemplateMappingsEndpoint("TEST", properties);
  }

  /**
   * Test post request for /templatemappings/{actiontype} with invalid input
   *
   * @throws Throwable pass the exception
   */
  @Given("^I make the POST call to the actionexporter template mapping endpoint for invalid input$")
  public void i_make_the_POST_call_to_the_actionexporter_template_mapping_endpoint_for_invalid_input()
      throws Throwable {
    Properties properties = new Properties();
    properties.put("invalid", "input");

    responseAware.invokePostActionExporterTemplateMappingsEndpoint("TEST", properties);
  }

  /**
   * Test post request for /info
   * @throws Throwable pass the exception
   */
  @Given("^I make the call to the actionexporter endpoint for info")
  public void i_make_the_call_to_the_actionexporter_endpoint_for_info() throws Throwable {
    responseAware.invokeInfoEndpoint();
  }

  /**
   * Test get request for /reports/types
   *
   * @throws Throwable pass the exception
   */
  @Given("^I make the GET call to the actionexporter reports endpoint for all types$")
  public void i_make_the_GET_call_to_the_actionexporter_reports_endpoint_for_all_types() throws Throwable {
    responseAware.invokeGetAllReportsEndpoint();
  }

  /**
   * Test get request for /reports/types/{reportTypes}
   *
   * @param reportType to be retrieved
   * @throws Throwable pass the exception
   */
  @Given("^I make the GET call to the actionexporter reports endpoint for type \"(.*?)\"$")
  public void i_make_the_GET_call_to_the_actionexporter_reports_endpoint_for_type(String reportType) throws Throwable {
    responseAware.invokeGetTypeReportsEndpoint(reportType);
  }

  /**
   * Test get request for /reports/{reportId}
   *
   * @throws Throwable pass the exception
   */
  @Given("^I make the GET call to the actionexporter reports endpoint for id$")
  public void i_make_the_GET_call_to_the_actionexporter_reports_endpoint_for_id() throws Throwable {
    responseAware.invokeGetReportsByIdEndpoint(null);
  }

  /**
   * Test get request for /reports/{reportId}
   *
   * @param reportId to be retrieved
   * @throws Throwable pass the exception
   */
  @Given("^I make the GET call to the actionexporter reports endpoint for id \"(.*?)\"$")
  public void i_make_the_GET_call_to_the_actionexporter_reports_endpoint_for_id(String reportId) throws Throwable {
    responseAware.invokeGetReportsByIdEndpoint(reportId);
  }
}
