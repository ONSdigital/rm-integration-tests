package uk.gov.ons.ctp.response.casesvc.steps;

import cucumber.api.java.en.When;
import uk.gov.ons.ctp.response.casesvc.util.ReportResponseAware;

/**
 * Created by Kieran Wardle on 09/02/17.
 */
public class ReportSteps {
  private final ReportResponseAware responseAware;

  /**
   * Constructor
   *
   * @param reportResponseAware report frame end point runner
   */
  public ReportSteps(ReportResponseAware reportResponseAware) {
    this.responseAware = reportResponseAware;
  }

  /**
   * Test get request for /reports/types for casesvc
   *
   * @throws Throwable pass the exception
   */
  @When("^I make the GET call to the casesvc Report endpoint$")
  public void i_make_the_GET_call_to_the_casesvs_report_endpoint()
      throws Throwable {
    responseAware.invokeReportEndpoint();
  }

  /**
   * Test get request for /reports/types/{reportType} for casesvc
   *
   * @param reportType report type to get list of reports for
   * @throws Throwable pass the exception
   */
  @When("^I make the GET call to the casesvc Report List endpoint for report type \"(.*?)\"$")
  public void i_make_the_GET_call_to_the_casesvs_report_list_endpoint_for_report__type(String reportType)
      throws Throwable {
    responseAware.invokeReportListEndpoint(reportType);
  }

  /**
   * Test get request for /reports/{reportId} for casesvc
   *
   * @param reportType report type to get list of reports for
   * @throws Throwable pass the exception
   */
  @When("^I make the GET call to the casesvc Report Content endpoint for the report of report type \"(.*?)\"$")
  public void make_the_GET_call_to_the_casesvs_report_Content_endpoint_for_the_report_of_report__type(String reportType)
      throws Throwable {
    responseAware.invokeReportContentEndpoint(reportType);
  }
}
