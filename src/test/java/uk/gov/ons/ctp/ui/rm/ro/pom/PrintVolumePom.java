package uk.gov.ons.ctp.ui.rm.ro.pom;

import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindBy;
import org.openqa.selenium.support.PageFactory;

import uk.gov.ons.ctp.ui.util.TableHelper;

/**
 * Created by Chris Hardman on the 21/09/2017
 */
public class PrintVolumePom {
  @FindBy(id = "main")
  private WebElement reportTable;

  /**
   * Constructor
   *
   * @param webDriver Selenium web driver
   */
  public PrintVolumePom(WebDriver webDriver) {
    PageFactory.initElements(webDriver, this);
  }

  /**
   * Get the number of reports in the table
   *
   * @return number of reports
   */
  public int getNumberOfReports() {
    TableHelper table = new TableHelper();
    return table.extractNumberOfRowsFromTable(reportTable);
  }

  /**
   * Get table
   *
   * @return table as web element
   */
  public WebElement getTable() {
    return reportTable;
  }

  /**
   * returns one value from a report
   *
   * @param column looking at
   * @param row looking at
   * @return value from table
   */
  public String checksSpeficValueFromReport(int column, int row) {
    TableHelper table = new TableHelper();
    return table.extractValueFromTable(reportTable, column, row);
  }
}
