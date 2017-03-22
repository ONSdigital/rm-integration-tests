package uk.gov.ons.ctp.ui.util.ro.pom;

import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindBy;
import org.openqa.selenium.support.PageFactory;

/**
 * Created by Stephen Goddard on 22/03/17.
 */
public class PostcodeResponseOperation {
  @FindBy(className = "message")
  private WebElement loginMsg;

  @FindBy(xpath = "//*[@id=\"menu\"]/li[2]/a")
  private WebElement escalationManage;

  /**
   * Constructor
   *
   * @param webDriver Selenium web driver
   */
  public PostcodeResponseOperation(WebDriver webDriver) {
    PageFactory.initElements(webDriver, this);
  }

  /**
   * Get login message
   *
   * @return String message
   */
  public String getLoginMsg() {
    return loginMsg.getText();
  }

  /**
   * click on manage escalation link
   */
  public void clickManageEscalation() {
    escalationManage.click();
  }
}