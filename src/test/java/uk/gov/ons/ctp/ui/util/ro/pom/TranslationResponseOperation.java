package uk.gov.ons.ctp.ui.util.ro.pom;

import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindBy;
import org.openqa.selenium.support.PageFactory;
import org.openqa.selenium.support.ui.Select;

/**
 * Created by Stephen Goddard on 23/03/17.
 */
public class TranslationResponseOperation {

  @FindBy(css = "input[type='submit']")
  private WebElement createTranslationButton;

  @FindBy(id = "eventcategory")
  private WebElement translationDropdown;

  /**
   * Constructor
   *
   * @param webDriver Selenium web driver
   */
  public TranslationResponseOperation(WebDriver webDriver) {
    PageFactory.initElements(webDriver, this);
  }

  /**
   * Select item from category drop down
   *
   * @param category text
   */
  public void setCategory(String category) {
    final Select selectBox = new Select(translationDropdown);
    selectBox.selectByVisibleText(category);
  }

  /**
   * Send sumbit to create request for translation booklet
   */
  public void clickCreateEventButton() {
    createTranslationButton.click();
  }

  /**
   * complete and submit form to request translation booklet
   *
   * @param category text
   */
  public void completeAndSubmitTranslationRequest(String category) {
    setCategory(category);
    clickCreateEventButton();
  }
}
