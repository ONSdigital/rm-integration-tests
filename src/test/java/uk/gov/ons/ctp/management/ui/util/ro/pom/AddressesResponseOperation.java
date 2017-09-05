package uk.gov.ons.ctp.management.ui.util.ro.pom;

import org.openqa.selenium.By;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindBy;
import org.openqa.selenium.support.PageFactory;

import uk.gov.ons.ctp.management.ui.util.TableHelper;

/**
 * Created by Stephen Goddard on 17/03/17.
 */
public class AddressesResponseOperation {
  private TableHelper helper = new TableHelper();

  @FindBy(tagName = "table")
  private WebElement addressTable;

  @FindBy(className = "next_page")
  private WebElement nextPage;

  @FindBy(className = "subhead")
  private WebElement addressMsg;

  @FindBy(id = "information")
  private WebElement noAddressMsg;

  @FindBy(className = "message")
  private WebElement invalidPostcodeMsg;

  private WebElement row;

  /**
   * Constructor
   *
   * @param webDriver Selenium web driver
   */
  public AddressesResponseOperation(WebDriver webDriver) {
    PageFactory.initElements(webDriver, this);
  }

  /**
   * Get address table from page
   *
   * @return WebElement for address table
   */
  public WebElement getAddressTable() {
    return addressTable;
  }

  /**
   * Click on next page to get next table of addresses
   */
  public void clickNextPage() {
    nextPage.click();
  }

  /**
   * Get address message
   *
   * @return String message
   */
  public String getAddressMsg() {
    return addressMsg.getText();
  }

  /**
   * Get no address message
   *
   * @return String message
   */
  public String getNoAddressMsg() {
    return noAddressMsg.getText();
  }

  /**
   * Get invalid postcode message
   *
   * @return String message
   */
  public String getInvalidPostcodeMsg() {
    try {
      return invalidPostcodeMsg.getText();
    } catch (Exception e) {
      return "";
    }
  }

  /**
   * Click on view cases for selected of addresses
   */
  private void clickViewCases() {
    row.findElement(By.linkText("View Cases")).click();
  }

  /**
   * Select address from table and click view cases
   *
   * @param address to be found and to view cases for
   */
  public void selectAddress(String address) {
    row = helper.navigateToTableRowBySearch(getAddressTable(), address);

    if (row == null) {
      while (nextPage != null) {
        clickNextPage();
        row = helper.navigateToTableRowBySearch(getAddressTable(), address);
        if (row != null) {
          break;
        }
      }
    }
    clickViewCases();
  }
}
