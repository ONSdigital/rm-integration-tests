package uk.gov.ons.ctp.ui.rm.ro.util;

import java.util.List;

import org.openqa.selenium.WebElement;

import uk.gov.ons.ctp.management.ui.util.TableHelper;
import uk.gov.ons.ctp.management.ui.util.reports.pom.ReportDetailsReports;
import uk.gov.ons.ctp.management.ui.util.reports.pom.ReportListReports;
import uk.gov.ons.ctp.management.ui.util.reports.pom.ViewReports;
import uk.gov.ons.ctp.ui.rm.ro.pom.ActionStatusPom;
import uk.gov.ons.ctp.ui.rm.ro.pom.CaseEventsPom;
import uk.gov.ons.ctp.ui.rm.ro.pom.PrintVolumesPom;
import uk.gov.ons.ctp.ui.rm.ro.pom.ReportsPom;
import uk.gov.ons.ctp.ui.rm.ro.pom.SampleReportPom;
import uk.gov.ons.ctp.ui.rm.ro.pom.SearchReportUnitPom;
import uk.gov.ons.ctp.ui.rm.ro.pom.SignInPom;
import uk.gov.ons.ctp.ui.util.SeleniumAware;
import uk.gov.ons.ctp.util.World;

/**
 * Created by Stephen Goddard on 24/05/16.
 * Edited by Chris Hardman on 17/11/16
 *
 */
public class UIResponseAware extends SeleniumAware {
  private static final String REPORTS_URL = "/reports";
  private static final String SERVICE = "ui";

  /**
   * Constructor
   *
   * @param newWorld class with application and environment properties
   */
  public UIResponseAware(final World newWorld) {
    super(newWorld);
  }

  public void searchReportingUnit (String reportRef){

    SearchReportUnitPom search = new SearchReportUnitPom(getWebDriver());
    search.setReportRef(reportRef);
    search.submitReportRef();
  }
  
  public String checkCaseEventsForCase (String event, int column){
	SearchReportUnitPom search = new SearchReportUnitPom(getWebDriver());
	return search.checkCaseEvent(event, column);
  }
  
  public void invokeReportSelection(String reportType) {
    invokeNavigateToPage(getWorld().getUrl(REPORTS_URL, SERVICE));

    ReportsPom reports = new ReportsPom(getWebDriver());
    reports.selectReportType(reportType);
  }
  
  public void viewReport() {
    ReportsPom reports = new ReportsPom(getWebDriver());
    reports.selectReport();
  }
  
  public String checksSpeficValueFromReport(int column, int row) {
	  ReportsPom reports = new ReportsPom(getWebDriver());
	  return reports.checksSpeficValueFromReport(column,row);
  }
  
  public int checksColumnValues(int column, String value) {
	  ReportsPom reports = new ReportsPom(getWebDriver());
	  return reports.checksColumnValues(column, value);
  }
  
  public  List<String> checksColumnValuesReturnsSampleRef(int column, String value) {
	  ReportsPom reports = new ReportsPom(getWebDriver());
	  return reports.checksColumnValuesReturnsSampleRef(column, value);
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
