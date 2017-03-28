package uk.gov.ons.ctp.ui.util.reports.pom;

import java.util.List;

import org.openqa.selenium.By;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindBy;
import org.openqa.selenium.support.PageFactory;

import uk.gov.ons.ctp.ui.util.TableHelper;

/**
 * Created by Stephen Goddard on 28/03/17.
 */
public class ReportDetailsReports {
  private TableHelper helper = new TableHelper();

  @FindBy(className = "primary")
  private WebElement reportDetailsTable;

  @FindBy(css = "#yui-main > div > p")
  private WebElement reportEmptyMsg;

  /**
   * Constructor
   *
   * @param webDriver Selenium web driver
   */
  public ReportDetailsReports(WebDriver webDriver) {
    PageFactory.initElements(webDriver, this);
  }

  /**
   * Get report details table from page
   *
   * @return WebElement for report details table
   */
  public WebElement getReportDetailsTable() {
    return reportDetailsTable;
  }

  /**
   * Get the report details table heading
   *
   * @return List of headings
   */
  public List<String> getReportTableHeadings() {
    return helper.extractHeadingsFromTable(getReportDetailsTable());
  }

  /**
   * Get the report message
   *
   * @return String message
   */
  public String getReportMessage() {
    return reportEmptyMsg.getText();
  }

  /**
   * Get the value for the specified row
   *
   * @param rowName to get value for
   * @return String value
   */
  public String getValueForRowname(String rowName) {
    WebElement row = helper.navigateToTableRowBySearch(getReportDetailsTable(), rowName);
    return row.findElements(By.tagName("td")).get(1).getText();
  }
}
