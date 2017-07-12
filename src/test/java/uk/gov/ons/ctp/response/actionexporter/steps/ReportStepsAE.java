package uk.gov.ons.ctp.response.actionexporter.steps;

import cucumber.api.java.en.When;
import uk.gov.ons.ctp.response.actionexporter.util.ReportResponseAwareAE;

/**
 * Created by Kieran Wardle on 09/02/17.
 */
public class ReportStepsAE {
  private final ReportResponseAwareAE responseAware;
  private static final String FTL_LOCATION_KEY = "cuc.collect.actionexp.ftl.location";

  /**
   * Constructor
   *
   * @param reportResponseAware report frame end point runner
   *
   */
  public ReportStepsAE(ReportResponseAwareAE reportResponseAware) {
    this.responseAware = reportResponseAware;
  }

  /**
   * Test get request for /reports/types for actionexporter
   *
   * @throws Throwable pass the exception
   */
  @When("^I make the GET call to the actionexporter Report endpoint$")
  public void i_make_the_GET_call_to_the_actionexporter_report_endpoint()
      throws Throwable {
    responseAware.invokeReportEndpoint();
  }

  /**
   * Test get request for /reports/types/{reportType} for actionexporter
   *
   * @param reportType report type to get list of reports for
   * @throws Throwable pass the exception
   */
  @When("^I make the GET call to the actionexporter Report List endpoint for report type \"(.*?)\"$")
  public void i_make_the_GET_call_to_the_actionexporter_report_List_endpoint_for_report_type(String reportType)
      throws Throwable {
    responseAware.invokeReportListEndpoint(reportType);
  }

  /**
   * Test get request for /reports/{reportId} for actionexporter
   *
   * @param reportType report type to get list of reports for
   * @throws Throwable pass the exception
   */
  @When("^I make the GET call to the actionexporter Report Content endpoint for the report of type \"(.*?)\"$")
  public void make_the_GET_call_to_the_actionexporter_report_Content_endpoint_for_the_report_of_type(String reportType)
      throws Throwable {
    responseAware.invokeReportContentEndpoint(reportType);
  }

}
