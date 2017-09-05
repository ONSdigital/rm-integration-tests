package uk.gov.ons.ctp.management.ui.util.reports.pom;

import org.openqa.selenium.By;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindBy;
import org.openqa.selenium.support.PageFactory;

import uk.gov.ons.ctp.management.ui.util.TableHelper;

/**
 * Created by Stephen Goddard on 27/03/17.
 */
public class ReportListReports {
  private TableHelper helper = new TableHelper();

  @FindBy(id = "information")
  private WebElement reportsMsg;

  @FindBy(className = "primary")
  private WebElement reportstable;


  /**
   * Constructor
   *
   * @param webDriver Selenium web driver
   */
  public ReportListReports(WebDriver webDriver) {
    PageFactory.initElements(webDriver, this);
  }

  /**
   * Get reports message
   *
   * @return String message
   */
  public String getReportsMsg() {
    return reportsMsg.getText();
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
   * Get report date from reports table
   *
   * @return displayed report date
   */
  public String getReportDateFromTable() {
    return helper.extractValueFromTable(getReportsTable(), 1, 1);
  }

  /**
   * click the view report details
   */
  public void clickReportView() {
    getReportsTable().findElement(By.linkText("View")).click();
  }
}
