package uk.gov.ons.ctp.ui.rm.ro.util;

import java.util.List;

import uk.gov.ons.ctp.ui.rm.ro.pom.ReportsPom;
import uk.gov.ons.ctp.ui.rm.ro.pom.SearchReportUnitPom;
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

  /**
   *
   * @param reportRef to look up
   */
  public void searchReportingUnit(String reportRef) {

    SearchReportUnitPom search = new SearchReportUnitPom(getWebDriver());
    search.setReportRef(reportRef);
    search.submitReportRef();
  }

  /**
   *
   * @param event to look up
   * @param column to look in
   * @return value from case event
   */
  public String checkCaseEventsForCase(String event, int column) {
    SearchReportUnitPom search = new SearchReportUnitPom(getWebDriver());
    return search.checkCaseEvent(event, column);
  }
  /**
   *
   * @param reportType to look at
   */
  public void invokeReportSelection(String reportType) {
    invokeNavigateToPage(getWorld().getUrl(REPORTS_URL, SERVICE));

    ReportsPom reports = new ReportsPom(getWebDriver());
    reports.selectReportType(reportType);
  }
  /**
   * views a report
   */
  public void viewReport() {
    ReportsPom reports = new ReportsPom(getWebDriver());
    reports.selectReport();
  }
  /**
   *
   * @param column to look in
   * @param row to look in
   * @return value from within the column and row
   */
  public String checksSpeficValueFromReport(int column, int row) {
    ReportsPom reports = new ReportsPom(getWebDriver());
    return reports.checksSpeficValueFromReport(column, row);
  }
  /**
   *
   * @param column to look in
   * @param value to look ups
   * @return value within columns
   */
  public int checksColumnValues(int column, String value) {
    ReportsPom reports = new ReportsPom(getWebDriver());
    return reports.checksColumnValues(column, value);
  }
  /**
  *
  * @param column to look in
  * @param value to look ups
  * @return value within columns
  */
 public int checksColumnValuesContains(int column, String value) {
   ReportsPom reports = new ReportsPom(getWebDriver());
   return reports.checksColumnValuesContains(column, value);
 }
  /**
   *
   * @param column to look in
   * @param value to look for
   * @return value within columns and a case ref
   */
  public  List<String> checksColumnValuesReturnsSampleRef(int column, String value) {
    ReportsPom reports = new ReportsPom(getWebDriver());
    return reports.checksColumnValuesReturnsSampleRef(column, value);
  }

  /**
   * Click report type
   *
   * @param link to click
   */
  public void invokeclickReportLink(String link) {
    ReportsPom viewReports = new ReportsPom(getWebDriver());
    viewReports.selectReportType(link);
  }
}
