package uk.gov.ons.ctp.ui.rm.ro.pom;

import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindBy;
import org.openqa.selenium.support.PageFactory;

/**
 * Created by Stephen Goddard on 09/10/17.
 *
 */
public class HomePOM {
  @FindBy(id = "sampleunitref")
  private WebElement serachbox;

  @FindBy(className = "btn--search")
  private WebElement submit;

  @FindBy(linkText = "Reports")
  private WebElement reportsTab;

  /**
   * Constructor
   *
   * @param webDriver Selenium web driver
   */
  public HomePOM(WebDriver webDriver) {
    PageFactory.initElements(webDriver, this);
  }

  /**
   * Clear searchbox field
   */
  public void clearSearch() {
    serachbox.clear();
  }

  /**
   * Add search to searchbox field
   *
   * @param strRuRef string to be inserted into field
   */
  public void setSearch(String strRuRef) {
    serachbox.sendKeys(strRuRef);
  }

  /**
   * Send sumbit event on form
   */
  public void submitSearch() {
    submit.click();
  }

  /**
   * submit a reporting unit search
   *
   * @param ruRef string to be inserted into field
   */
  public void ruRefSearch(String ruRef) {
    clearSearch();
    setSearch(ruRef);
    submitSearch();
  }

  /**
   * Click on reports tab
   */
  public void selectReportTab() {
    reportsTab.click();
  }
}
