package uk.gov.ons.ctp.ui.rm.ro.pom;

import org.openqa.selenium.WebDriver;
import org.openqa.selenium.support.PageFactory;

public class ReportsPom {

  /**
   * Constructor
   *
   * @param webDriver Selenium web driver
   */
  public ReportsPom(WebDriver webDriver) {
    PageFactory.initElements(webDriver, this);
  }

  public void SelectReportType(String reportType) {
    System.out.println("Report selected for type: " + reportType);
  }
}
