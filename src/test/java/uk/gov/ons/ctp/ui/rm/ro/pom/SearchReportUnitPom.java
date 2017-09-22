package uk.gov.ons.ctp.ui.rm.ro.pom;

import java.util.List;

import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindBy;
import org.openqa.selenium.support.PageFactory;

import uk.gov.ons.ctp.ui.util.TableHelper;

/**
 * Created by Chris Hardman on the 21/09/2017
 */
public class SearchReportUnitPom {

  @FindBy(xpath = "//*[@id=\"search-form\"]/input[2]")
  private WebElement search;

  @FindBy(xpath = "//*[@id=\"sampleunitref\"]")
  private WebElement searchBar;

  @FindBy(xpath = "//*[@id=\"ft\"]/table[1]/tbody")
  private WebElement eventsTable;

  /**
   * Constructor
   *
   * @param webDriver Selenium web driver
   */
  public SearchReportUnitPom(WebDriver webDriver) {
    PageFactory.initElements(webDriver, this);
  }

  /**
   * Add RUref to search field
   *
   * @param ruRef string to be inserted into field
   */
  public void setReportRef(String ruRef) {
    searchBar.sendKeys(ruRef);
  }

  /**
   * Send sumbit event on form
   */
  public void submitReportRef() {
    search.click();
  }

  /**
   * searchs for an event with the case page
   * @param event being looked for
   * @param column looking in
   * @return value from case event table
   */
  public String checkCaseEvent(String event, int column) {

    TableHelper table = new TableHelper();
    List<String> contents = table.extractColumnValuesFromTable(eventsTable, column);
    for (int i = 0; i < contents.size(); i++) {
      if (contents.get(i).equals(event)) {
        return contents.get(i);
      }
    }
    return " ";
  }
}
