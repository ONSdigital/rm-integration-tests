package uk.gov.ons.ctp.management.ui.util;

import java.util.List;

import uk.gov.ons.ctp.management.ui.util.reports.pom.ReportDetailsReports;
import uk.gov.ons.ctp.management.ui.util.reports.pom.ReportListReports;
import uk.gov.ons.ctp.management.ui.util.reports.pom.ViewReports;
import uk.gov.ons.ctp.util.World;

/**
 * Created  Chris Hardman on 18/08/17
 */
public class ReportsUIResponseAware extends SeleniumAware {

  /**
   * Constructor
   *
   * @param newWorld class with application and environment properties
   */
  public ReportsUIResponseAware(final World newWorld) {
    super(newWorld);
  }

  /**
   * Gets the report types from the reports table
   *
   * @return List of report Types
   */
  public List<String> invokeValidateOnReportTypes() {
    ViewReports viewReports = new ViewReports(getWebDriver());
    return viewReports.getReportTypes();
  }

  /**
   * Gets the count of report types from the reports table
   *
   * @return count of report types
   */
  public int invokeGetReportTypeCount() {
    ViewReports viewReports = new ViewReports(getWebDriver());
    return viewReports.getReportTypeCount();
  }

  /**
   * Click report type
   *
   * @param link to click
   */
  public void invokeclickReportLink(String link) {
    ViewReports viewReports = new ViewReports(getWebDriver());
    viewReports.clickReportLink(link);
  }

  /**
   * Get report message
   *
   * @return String message
   */
  public String invokeGetReportsMessage() {
    ReportListReports reportListReports = new ReportListReports(getWebDriver());
    return reportListReports.getReportsMsg();
  }

  /**
  * Extract report date from UI and return value
  *
  * @return report date
  */
  public String invokeGetReportDate() {
    ReportListReports reportListReports = new ReportListReports(getWebDriver());
    return reportListReports.getReportDateFromTable();
  }

  /**
   * Click the view report link to navigate to the report details
   */
  public void invokeClickReportViewLink() {
    ReportListReports reportListReports = new ReportListReports(getWebDriver());
    reportListReports.clickReportView();
  }

  /**
   * Get the headings appear for the current report
   *
   * @return List of headings
   */
  public List<String> invokeGetReportHeadings() {
    ReportDetailsReports reportDetailsReports = new ReportDetailsReports(getWebDriver());
    return reportDetailsReports.getReportTableHeadings();
  }

  /**
   * Get the report message
   *
   * @return String message
   */
  public String invokeGetReportMessage() {
    ReportDetailsReports reportDetailsReports = new ReportDetailsReports(getWebDriver());
    return reportDetailsReports.getReportMessage();
  }

  /**
   * Get the value for the specified row
   *
   * @param rowName to get value for
   * @return String for the row value
   */
  public String invokeGetValueForRowname(String rowName) {
    ReportDetailsReports reportDetailsReports = new ReportDetailsReports(getWebDriver());
    return reportDetailsReports.getValueForRowname(rowName);
  }
}
