package uk.gov.ons.ctp.ui.util.ro.pom;

import java.util.List;

import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindBy;
import org.openqa.selenium.support.PageFactory;

import uk.gov.ons.ctp.ui.util.TableHelper;

/**
 * Created by Stephen Goddard on 20/03/17.
 */
public class EventsResponseOperation {
  private TableHelper helper = new TableHelper();

  @FindBy(xpath = "//*[@id=\"breadcrumbs\"]/a[3]")
  private WebElement casesBreadcrumb;

  @FindBy(css = "input[type='submit'][value='Request Individual Form…']")
  private WebElement individualFormButton;

  @FindBy(css = "input[type='submit'][value='Request Replacement Access Code…']")
  private WebElement replacementCodeFormButton;

  @FindBy(css = "input[type='submit'][value='Request Paper Form…']")
  private WebElement paperFormButton;

  @FindBy(css = "input[type='submit'][value='Request Translation Booklet…']")
  private WebElement translateButton;

  @FindBy(className = "primary")
  private WebElement addressTable;

  @FindBy(css = "#yui-main > div > table.secondary")
  private WebElement questionnaireTable;

  @FindBy(css = "#ft > table:nth-child(3)")
  private WebElement eventsTable;

  @FindBy(css = "#ft > table:nth-child(5)")
  private WebElement actionsTable;

  @FindBy(css = "#events > form > input")
  private WebElement createEventButton;

  /**
   * Constructor
   *
   * @param webDriver Selenium web driver
   */
  public EventsResponseOperation(WebDriver webDriver) {
    PageFactory.initElements(webDriver, this);
  }

  /**
   * Click on breadcrumb to return to cases page
   */
  public void clickCasesBreadcrumb() {
    casesBreadcrumb.click();
  }

  /**
   * Click on translation booklet request button
   */
  public void clickIndividualForm() {
    individualFormButton.click();
  }

  /**
   * Click on translation booklet request button
   */
  public void clickReplacementCodeForm() {
    replacementCodeFormButton.click();
  }

  /**
   * Click on translation booklet request button
   */
  public void clickPaperForm() {
    paperFormButton.click();
  }

  /**
   * Click on translation booklet request button
   */
  public void clickTranslationBooklet() {
    translateButton.click();
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
   * Get questionnaire table from page
   *
   * @return WebElement for questionnaire table
   */
  public WebElement getQuestionnaireTable() {
    return questionnaireTable;
  }

  /**
   * Get response date from questionnaire table
   *
   * @return response date as string
   */
  public String getResponseDate() {
    return helper.extractValueFromTable(getQuestionnaireTable(), 1, 3);
  }

  /**
   * Get events table from page
   *
   * @return WebElement for events table
   */
  public WebElement getEventsTable() {
    return eventsTable;
  }

  /**
   * Get actions table from page
   *
   * @return WebElement for actions table
   */
  public WebElement getActionsTable() {
    return actionsTable;
  }

  /**
   * Get the most recent event description from event table
   *
   * @return Event description
   */
  public String getMostRecentEventDescription() {
    return helper.extractValueFromTable(getEventsTable(), 1, 5);
  }

  /**
   * Get the most recent event category from event table
   *
   * @return Event category
   */
  public String getMostRecentEventCategory() {
    return helper.extractValueFromTable(getEventsTable(), 1, 4);
  }

  /**
   * Get list of event category from event table
   *
   * @return Event category list
   */
  public List<String> getListEventCategory() {
    return helper.extractColumnValuesFromTable(getEventsTable(), 4);
  }

  /**
   * Get list of event description from event table
   *
   * @return Event description list
   */
  public List<String> getListEventDescription() {
    return helper.extractColumnValuesFromTable(getEventsTable(), 5);
  }

  /**
   * Click create event to take the user to the create event form
   */
  public void clickCreateEventButton() {
    createEventButton.click();
  }

  /**
   * Get action state from action table
   *
   * @return action state
   */
  public String getActionState() {
    return helper.extractValueFromTable(getActionsTable(), 1, 4);
  }

  /**
   * Is action table displayed
   *
   * @return action state
   */
  public boolean isActionTableDisplayed() {
    return getActionsTable().isDisplayed();
  }
}
