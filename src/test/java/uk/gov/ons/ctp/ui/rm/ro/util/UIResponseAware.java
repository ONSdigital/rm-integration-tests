package uk.gov.ons.ctp.ui.rm.ro.util;

import uk.gov.ons.ctp.ui.rm.ro.pom.ReportsPom;
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

  public void invokeReportSelection(String reportType) {
    invokeNavigateToPage(getWorld().getUrl(REPORTS_URL, SERVICE));

    ReportsPom reports = new ReportsPom(getWebDriver());
    reports.SelectReportType(reportType);
  }
}
