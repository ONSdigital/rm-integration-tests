package uk.gov.ons.ctp.ui.rm.ro.pom;


import static org.junit.Assert.assertEquals;

import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindBy;
import org.openqa.selenium.support.PageFactory;


public class CaseEventsPom {


  /**
   * Constructor
   *
   * @param webDriver Selenium web driver
   */
  public CaseEventsPom(WebDriver webDriver) {
    PageFactory.initElements(webDriver, this);
  }	 
}

