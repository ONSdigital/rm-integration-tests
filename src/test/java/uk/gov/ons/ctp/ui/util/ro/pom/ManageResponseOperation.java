package uk.gov.ons.ctp.ui.util.ro.pom;

import org.openqa.selenium.By;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindBy;
import org.openqa.selenium.support.PageFactory;

public class ManageResponseOperation {
  private WebDriver driver;
  
//  @FindBy(linkText = "View escalated field complaint cases")
//  private WebElement escComplaintLink;
//
//  @FindBy(linkText = "View escalated field emergency cases")
//  private WebElement escEnergencyLink;

  /**
   * Constructor
   *
   * @param webDriver Selenium web driver
   */
  public ManageResponseOperation(WebDriver webDriver) {
    driver = webDriver;
    PageFactory.initElements(webDriver, this);
  }
  
  public void clickEscalationLink(String linkText) {
    driver.findElement(By.linkText(linkText)).click();
  }
}
