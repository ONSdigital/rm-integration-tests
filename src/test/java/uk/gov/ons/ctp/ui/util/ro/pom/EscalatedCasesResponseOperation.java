package uk.gov.ons.ctp.ui.util.ro.pom;

import org.openqa.selenium.By;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindBy;
import org.openqa.selenium.support.PageFactory;

/**
 * Created by Stephen Goddard on 24/03/17.
 */
public class EscalatedCasesResponseOperation {
  @FindBy(className = "secondary")
  private WebElement caseTable;

  /**
   * Constructor
   *
   * @param webDriver Selenium web driver
   */
  public EscalatedCasesResponseOperation(WebDriver webDriver) {
    PageFactory.initElements(webDriver, this);
  }

  /**
   * Get cases table from page
   *
   * @return WebElement for cases table
   */
  public WebElement getcasetable() {
    return caseTable;
  }

  /**
   * Test if case id exists as a link on the cases table
   *
   * @param linkText to find
   * @return boolean true if empty
   */
  public boolean caseLinkIsEmpty(String linkText) {
    return getcasetable().findElements(By.linkText(linkText)).isEmpty();
  }
}
