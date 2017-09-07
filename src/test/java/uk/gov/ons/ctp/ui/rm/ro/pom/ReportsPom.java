package uk.gov.ons.ctp.ui.rm.ro.pom;

import static org.junit.Assert.assertEquals;

import java.util.List;

import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindBy;
import org.openqa.selenium.support.PageFactory;

import uk.gov.ons.ctp.management.ui.util.TableHelper;


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
  
  @FindBy(xpath = "//*[@id=\"main\"]/table")
  private WebElement reportTable;

  /**
   * Constructor
   *
   * @param webDriver Selenium web driver
   */
  public ReportsPom(WebDriver webDriver) {
    PageFactory.initElements(webDriver, this);
  }

  public void selectReportType(String reportType) {

    switch (reportType){
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

    }
  }
  
  public void selectReport() {
	  viewReport.click();
  }
  
  public void checksColumnValues(int column, String value, int number) {
    int count = 0;
    TableHelper table = new TableHelper();
    List<String> contents = table.extractColumnValuesFromTable(reportTable, column);
    for (int i = 0; i<contents.size(); i++){
	  if (contents.get(i).equals(value)){
	    count = count + 1;
	  }
    }
    assertEquals(count, number);
  }
}