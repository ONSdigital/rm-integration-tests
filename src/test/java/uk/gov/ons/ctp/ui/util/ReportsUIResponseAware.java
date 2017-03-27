package uk.gov.ons.ctp.ui.util;

import java.util.List;

import uk.gov.ons.ctp.ui.util.reports.pom.ViewReports;
import uk.gov.ons.ctp.util.World;

/**
 * Created by Stephen Goddard on 23/03/17.
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
}
