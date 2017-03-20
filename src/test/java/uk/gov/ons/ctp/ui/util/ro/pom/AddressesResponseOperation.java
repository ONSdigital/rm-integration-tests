package uk.gov.ons.ctp.ui.util.ro.pom;

import org.openqa.selenium.By;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindBy;
import org.openqa.selenium.support.PageFactory;

import uk.gov.ons.ctp.ui.util.TableHelper;

/**
 * Created by Stephen Goddard on 17/03/17.
 */
public class AddressesResponseOperation {
  private TableHelper helper = new TableHelper();

  @FindBy(tagName = "table")
  private WebElement addressTable;

  @FindBy(className = "next_page")
  private WebElement nextPage;

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
