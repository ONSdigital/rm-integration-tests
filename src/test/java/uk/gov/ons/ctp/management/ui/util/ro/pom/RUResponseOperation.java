package uk.gov.ons.ctp.management.ui.util.ro.pom;

import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindBy;
import org.openqa.selenium.support.PageFactory;

/**
 * Created by Stephen Goddard on 22/03/17.
 */
public class RUResponseOperation {
  @FindBy(className = "subhead")
  private WebElement loginMsg;

  @FindBy(xpath = "//*[@id=\"menu\"]/li[2]/a")
  private WebElement additionalFuctionLink;

  /**
   * Constructor
   *
   * @param webDriver Selenium web driver
   */
  public RUResponseOperation(WebDriver webDriver) {
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
   * click on additional functionality link. Currently escalations and reports
   */
  public void clickAdditionalFuctionLink() {
    additionalFuctionLink.click();
  }
}
