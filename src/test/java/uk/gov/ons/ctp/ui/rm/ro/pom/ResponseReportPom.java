package uk.gov.ons.ctp.ui.rm.ro.pom;

import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindBy;
import org.openqa.selenium.support.PageFactory;

public class ResponseReportPom {
	  @FindBy(xpath = "//*[@id=\"main\"]/table/tbody/tr[1]/td[2]/a")
	  private WebElement responseReport;
	  
	  /**
	   * Constructor
	   *
	   * @param webDriver Selenium web driver
	   */
	  public ResponseReportPom(WebDriver webDriver) {
	    PageFactory.initElements(webDriver, this);
	  }
	 
}
