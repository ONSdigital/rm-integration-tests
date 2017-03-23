package uk.gov.ons.ctp.ui.util.ro.pom;

import org.openqa.selenium.By;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindBy;
import org.openqa.selenium.support.PageFactory;

import uk.gov.ons.ctp.ui.util.TableHelper;

/**
 * Created by Stephen Goddard on 20/03/17.
 */
public class CasesResponseOperation {
  private TableHelper helper = new TableHelper();
  private WebDriver driver;

  @FindBy(className = "primary")
  private WebElement addressTable;

  @FindBy(className = "secondary")
  private WebElement casesTable;

  /**
   * Constructor
   *
   * @param webDriver Selenium web driver
   */
  public CasesResponseOperation(WebDriver webDriver) {
    driver = webDriver;
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
   * Get cases table from page
   *
   * @return WebElement for address table
   */
  public WebElement getCasesTable() {
    return casesTable;
  }

  /**
   * Click on case link
   *
   * @param caseId link text to be found
   */
  public void clickOnCaseLink(String caseId) {
    getCasesTable().findElement(By.linkText(caseId)).click();
  }

  /**
   * Get case state from cases table
   *
   * @param caseId string case id
   * @return case state
   */
  public String getCaseStateForCase(String caseId) {
    WebElement row = helper.navigateToTableRowBySearch(getCasesTable(), caseId);
    return row.findElements(By.tagName("td")).get(1).getText();
  }

  /**
   * Get the number of tables on page
   *
   * @return number of tables
   */
  public int getNumberTablesOnPage() {
    return driver.findElements(By.tagName("table")).size();
  }

  /**
   * get question set from case table
   *
   * @return question set
   */
  public String getCaseQuestionSet() {
    return helper.extractValueFromTable(getCasesTable(), 1, 4);
  }

  /**
   * get address type from address table
   *
   * @return address type
   */
  public String getAddressType() {
    return helper.extractValueFromTable(getAddressTable(), 1, 9);
  }
}
