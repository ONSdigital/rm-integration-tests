package uk.gov.ons.ctp.ui.util.ro.pom;

import java.util.List;

import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindBy;
import org.openqa.selenium.support.PageFactory;
import org.openqa.selenium.support.ui.Select;

/**
 * Created by Stephen Goddard on 21/03/17.
 */
public class CreateEventResponseOperation {
  @FindBy(id = "eventtext")
  private WebElement eventDesc;

  @FindBy(id = "customertitle")
  private WebElement titleDropdown;

  @FindBy(id = "customerforename")
  private WebElement forename;

  @FindBy(id = "customersurname")
  private WebElement surname;

  @FindBy(id = "customercontact")
  private WebElement customerContact;

  @FindBy(id = "eventcategory")
  private WebElement categoryDropdown;

  @FindBy(xpath = "//input[@type='submit']")
  private WebElement createEventButton;

  /**
   * Constructor
   *
   * @param webDriver Selenium web driver
   */
  public CreateEventResponseOperation(WebDriver webDriver) {
    PageFactory.initElements(webDriver, this);
  }

  /**
   * Add description to description text box
   *
   * @param description text
   */
  public void setEventDesc(String description) {
    eventDesc.sendKeys(description);
  }

  /**
   * Select item from title drop down
   *
   * @param title text
   */
  public void setTitleDropdown(String title) {
    final Select selectBox = new Select(titleDropdown);
    selectBox.selectByVisibleText(title);
  }

  /**
   * Add forename to forename text box
   *
   * @param forenameStr text
   */
  public void setForename(String forenameStr) {
    forename.sendKeys(forenameStr);
  }

  /**
   * Add surname to surname text box
   *
   * @param surnameStr text
   */
  public void setSurname(String surnameStr) {
    surname.sendKeys(surnameStr);
  }

  /**
   * Add customer contact to contact text box
   *
   * @param contact text
   */
  public void setCustomerContact(String contact) {
    customerContact.sendKeys(contact);
  }

  /**
   * Select item from category drop down
   *
   * @param category text
   */
  public void setCategory(String category) {
    final Select selectBox = new Select(categoryDropdown);
    selectBox.selectByVisibleText(category);
  }

  /**
   * Send sumbit to create event
   */
  public void clickCreateEventButton() {
    createEventButton.click();
  }

  /**
   * Complete create event form and submit
   *
   * @param formContent data to complete form
   */
  public void completeAndSubmitCreateEventForm(List<String> formContent) {
    setEventDesc(formContent.get(1));
    setTitleDropdown(formContent.get(2));
    setForename(formContent.get(3));
    setSurname(formContent.get(4));
    setCustomerContact(formContent.get(5));
    setCategory(formContent.get(0));

    clickCreateEventButton();
  }
}
