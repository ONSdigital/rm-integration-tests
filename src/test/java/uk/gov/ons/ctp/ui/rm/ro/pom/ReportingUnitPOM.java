package uk.gov.ons.ctp.ui.rm.ro.pom;

import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindBy;
import org.openqa.selenium.support.PageFactory;

/**
 * Created by Stephen Goddard on 09/10/17.
 *
 */
public class ReportingUnitPOM {
  @FindBy(xpath = "//*[@id=\"yui-main\"]/div/dl/dd[1]")
  private WebElement ruRefernece;

  @FindBy(xpath = "//*[@id=\"yui-main\"]/div/dl/dd[2]/strong")
  private WebElement name;

  @FindBy(xpath = "//*[@id=\"yui-main\"]/div/dl/dd[3]")
  private WebElement tradingName;

  /**
   * Constructor
   *
   * @param webDriver Selenium web driver
   */
  public ReportingUnitPOM(WebDriver webDriver) {
    PageFactory.initElements(webDriver, this);
  }

  /**
   * Get reporting unit reference from page
   *
   * @return reporting unit reference
   */
  public String getRUReference() {
    return ruRefernece.getText();
  }

  /**
   * Get reporting company name from page
   *
   * @return company name
   */
  public String getName() {
    return name.getText();
  }

  /**
   * Get reporting trading name from page
   *
   * @return trading name
   */
  public String getTradingName() {
    return tradingName.getText();
  }
}
