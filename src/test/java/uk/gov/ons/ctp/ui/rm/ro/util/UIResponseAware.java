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
   * Click report type
   *
   * @param link to click
   */
  public void invokeclickReportLink(String link) {
    ReportsPom viewReports = new ReportsPom(getWebDriver());
    viewReports.selectReportType(link);
  }
}
