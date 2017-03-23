package uk.gov.ons.ctp.ui.util.ro.pom;

import java.util.List;

import org.openqa.selenium.By;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindBy;
import org.openqa.selenium.support.PageFactory;
import org.openqa.selenium.support.ui.Select;

import uk.gov.ons.ctp.ui.util.TableHelper;

/**
 * Created by Stephen Goddard on 21/03/17.
 */
public class CreateEventResponseOperation {
  private TableHelper helper = new TableHelper();

  @FindBy(className = "secondary")
  private WebElement responseModeTable;
  
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

  @FindBy(id = "phonenumber")
  private WebElement phoneNumber;

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
  
  public WebElement getResponseModeTable() {
    return responseModeTable;
  }

  public void setResponseMode(String mode, String langauge) {
    if (langauge.equals("English")) {
      WebElement row = helper.navigateToTableRowBySearch(getResponseModeTable(), langauge);
      row.findElement(By.id("regular")).click();
    } else if (langauge.equals("Welsh")) {
      WebElement row = helper.navigateToTableRowBySearch(getResponseModeTable(), langauge);
      row.findElement(By.id("regular")).click();
    } else {
      WebElement row = helper.navigateToTableRowBySearch(getResponseModeTable(), mode);
      row.findElement(By.id("regular")).click();
    }
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
   * Add customer contact to contact text box
   *
   * @param contact text
   */
  public void setPhoneNumber(String number) {
    phoneNumber.sendKeys(number);
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

  /**
   * Complete form and submit
   * Used for: Individual Form Request
   *           Replacement Access Code Request
   *           Paper Form Request
   *
   * @param formContent data to complete form
   */
  public void completeAndSubmitIndiviualForm(List<String> formContent) {
    setResponseMode(formContent.get(0), formContent.get(0));
    setTitleDropdown(formContent.get(1));
    setForename(formContent.get(2));
    setSurname(formContent.get(3));
    setPhoneNumber(formContent.get(5));

    clickCreateEventButton();
  }
}
