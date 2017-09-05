package uk.gov.ons.ctp.ui.rm.ro.pom;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertTrue;

import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindBy;
import org.openqa.selenium.support.PageFactory;

public class PrintVolumesPom {

	
  @FindBy(xpath = "//*[@id=\"main\"]/table/tbody[1]/tr/td[1]")
  private WebElement fileName;

  @FindBy(xpath = "//*[@id=\"main\"]/table/tbody[1]/tr/td[2]")
  private WebElement rowCount;
  
  /**
   * Constructor
   *
   * @param webDriver Selenium web driver
   */
  public PrintVolumesPom(WebDriver webDriver) {
    PageFactory.initElements(webDriver, this);
  }
  
  public void checkFileName(String name) {	
    String retrivedFileName = fileName.getText();
    assertTrue(retrivedFileName.contains(name));
  }
  
  public void checkRowCount(String rows) {	
    String retrivedRows = rowCount.getText();
    assertEquals(rows, retrivedRows);
  }
}