package uk.gov.ons.ctp.ui.util.ro.pom;

import org.openqa.selenium.By;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.support.PageFactory;

/**
 * Created by Stephen Goddard on 23/03/17.
 */
public class ManageResponseOperation {
  private WebDriver driver;

  /**
   * Constructor
   *
   * @param webDriver Selenium web driver
   */
  public ManageResponseOperation(WebDriver webDriver) {
    driver = webDriver;
    PageFactory.initElements(webDriver, this);
  }

  /**
   * Click specified link in page
   *
   * @param linkText for link to be clicked
   */
  public void clickEscalationLink(String linkText) {
    driver.findElement(By.linkText(linkText)).click();
  }
}
