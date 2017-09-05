package uk.gov.ons.ctp.ui.rm.ro.pom;

import static org.junit.Assert.assertEquals;

import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindBy;
import org.openqa.selenium.support.PageFactory;

public class SampleReportPom {
	  @FindBy(xpath = "//*[@id=\"main\"]/table/tbody[1]/tr/td[2]")
	  private WebElement sampleUnit;
	  
	  /**
	   * Constructor
	   *
	   * @param webDriver Selenium web driver
	   */
	  public SampleReportPom(WebDriver webDriver) {
	    PageFactory.initElements(webDriver, this);
	  }
	  
	  public void checkFormType(String sampleInit) {	
	    String retrivedCaseCreated = sampleUnit.getText();
	    assertEquals(sampleInit, retrivedCaseCreated);
	  }
}
