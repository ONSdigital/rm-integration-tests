package uk.gov.ons.ctp.ui.util.reports.pom;

import java.util.List;

import org.openqa.selenium.By;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindBy;
import org.openqa.selenium.support.PageFactory;

import uk.gov.ons.ctp.ui.util.TableHelper;

/**
 * Created by Stephen Goddard on 27/03/17.
 */
public class ViewReports {
  private TableHelper helper = new TableHelper();

  @FindBy(className = "primary")
  private WebElement reportstable;

  /**
   * Constructor
   *
   * @param webDriver Selenium web driver
   */
  public ViewReports(WebDriver webDriver) {
    PageFactory.initElements(webDriver, this);
  }

  /**
   * Get reports table from page
   *
   * @return WebElement for reports table
   */
  public WebElement getReportsTable() {
    return reportstable;
  }

  /**
   * Get report types from the reports table
   *
   * @return List of report types
   */
  public List<String> getReportTypes() {
    return helper.extractColumnValuesFromTable(getReportsTable(), 1);
  }

  /**
   * Get report types count from the reports table
   *
   * @return report types count
   */
  public int getReportTypeCount() {
    return helper.extractColumnValuesFromTable(getReportsTable(), 1).size();
  }

  /**
   * Click report type from on reports table
   *
   * @param reportLink link to click
   */
  public void clickReportLink(String reportLink) {
    getReportsTable().findElement(By.linkText(reportLink)).click();
  }
}
