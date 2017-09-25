package uk.gov.ons.ctp.ui.rm.ro.pom;

import java.util.ArrayList;
import java.util.List;

import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindBy;
import org.openqa.selenium.support.PageFactory;

import uk.gov.ons.ctp.ui.util.TableHelper;

/**
 * Created by Chris Hardman on the 21/09/2017
 */
public class ReportsPom {

  @FindBy(xpath = "//*[@id=\"main\"]/table/tbody/tr[1]/td/a")
  private WebElement actionReport;

  @FindBy(xpath = "//*[@id=\"main\"]/table/tbody/tr[2]/td/a")
  private WebElement caseReport;

  @FindBy(xpath = "//*[@id=\"main\"]/table/tbody/tr[3]/td/a")
  private WebElement collectionExcercise;

  @FindBy(xpath = "//*[@id=\"main\"]/table/tbody/tr[4]/td/a")
  private WebElement printVolumes;

  @FindBy(xpath = "//*[@id=\"main\"]/table/tbody/tr[5]/td/a")
  private WebElement responseReport;

  @FindBy(xpath = "//*[@id=\"main\"]/table/tbody/tr[6]/td/a")
  private WebElement sammpleUnit;

  @FindBy(xpath = "//*[@id=\"main\"]/table/tbody/tr[1]/td[2]/a")
  private WebElement viewReport;

  @FindBy(id = "main")
  private WebElement reportTable;

  /**
   * Constructor
   *
   * @param webDriver Selenium web driver
   */
  public ReportsPom(WebDriver webDriver) {
    PageFactory.initElements(webDriver, this);
  }
/**
 * Selects report of certain type
 *
 * @param reportType type of report
 */
  public void selectReportType(String reportType) {

    switch (reportType) {
    case "action":
      actionReport.click();
      break;
    case "case":
      caseReport.click();
      break;
    case "collection":
      collectionExcercise.click();
      break;
    case "print":
      printVolumes.click();
      break;
    case "response":
      responseReport.click();
      break;
    case "sample":
      sammpleUnit.click();
      break;
    default:
      break;
    }
  }
  /**
   * clicks on the report selected
   */
  public void selectReport() {
    viewReport.click();
  }

  /**
   * Checks the value of a column within a report returns the number of times that value appears within that column
   *
   * @param column looking at
   * @param value looking for
   *
   * @return count number of values found
   */
  public int checksColumnValues(int column, String value) {

    int count = 0;
    TableHelper table = new TableHelper();
    List<String> contents = table.extractColumnValuesFromTable(reportTable, column);
    for (int i = 0; i < contents.size(); i++) {
      if (contents.get(i).equals(value)) {
        count = count + 1;
      }
    }
    return count;
  }

  /**
   * Checks a value is contained within the column in a report returns the number of times that value appears within that column
   *
   * @param column looking at
   * @param value looking for
   *
   * @return count number of values found
   */
  public int checksColumnValuesContains(int column, String value) {

    int count = 0;
    TableHelper table = new TableHelper();
    List<String> contents = table.extractColumnValuesFromTable(reportTable, column);
    for (int i = 0; i < contents.size(); i++) {
      if (contents.get(i).contains(value)) {
        count = count + 1;
      }
    }
    return count;
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

  /**
   * checks the report for specific value then returns the case ref associated with that value.
   *
   * @param column looking at
   * @param value looking for
   * @return sample ref
   */
  public List<String> checksColumnValuesReturnsSampleRef(int column, String value) {

    List<String> results = new ArrayList<String>();

    int count = 0;
    TableHelper table = new TableHelper();
    List<String> contents = table.extractColumnValuesFromTable(reportTable, column);
    for (int i = 0; i < contents.size(); i++) {
      if (contents.get(i).equals(value)) {
        count = count + 1;
        results.add(table.extractValueFromTable(reportTable, i + 2, 0));
      }
    }
    results.add(Integer.toString(count));
    return results;
  }

}
