package uk.gov.ons.ctp.ui.rm.ro.pom;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.fail;

import java.util.ArrayList;
import java.util.List;

import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindBy;
import org.openqa.selenium.support.PageFactory;

import uk.gov.ons.ctp.management.ui.util.TableHelper;

public class SearchReportUnitPom {

  @FindBy(xpath = "//*[@id=\"search-form\"]/input[2]")
  private WebElement search;
  
  @FindBy(xpath = "//*[@id=\"sampleunitref\"]")
  private WebElement searchBar;
  
  @FindBy(xpath = "//*[@id=\"ft\"]/table[1]")
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
   * searchs case page for an event
   * 
   * @param event
   */
  public String checkCaseEvent(String event, int column) {
 
    TableHelper table = new TableHelper();
    List<String> contents = table.extractColumnValuesFromTable(eventsTable,column);
    for (int i = 0; i<contents.size(); i++){
    	if (contents.get(i).equals(event)){
    		return contents.get(i);
    	}
    }
    return " ";
  }
}
