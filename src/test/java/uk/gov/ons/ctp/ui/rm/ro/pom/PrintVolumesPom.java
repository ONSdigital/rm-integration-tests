package uk.gov.ons.ctp.ui.rm.ro.pom;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertTrue;

import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindBy;
import org.openqa.selenium.support.PageFactory;

public class PrintVolumesPom {
  
  /**
   * Constructor
   *
   * @param webDriver Selenium web driver
   */
  public PrintVolumesPom(WebDriver webDriver) {
    PageFactory.initElements(webDriver, this);
  }
}