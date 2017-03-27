package uk.gov.ons.ctp.ui.util.reports.pom;

import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindBy;
import org.openqa.selenium.support.PageFactory;

import uk.gov.ons.ctp.ui.util.TableHelper;

/**
 * Created by Stephen Goddard on 27/03/17.
 */
public class DetailsReports {
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
  public DetailsReports(WebDriver webDriver) {
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
  public WebElement getReportstable() {
    return reportstable;
  }

  /**
   * Get report date from reports table
   *
   * @return displayed report date
   */
  public String getReportDateFromTable() {
    return helper.extractValueFromTable(getReportstable(), 1, 1);
  }
}
