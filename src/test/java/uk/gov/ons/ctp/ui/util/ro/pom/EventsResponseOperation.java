package uk.gov.ons.ctp.ui.util.ro.pom;

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

  @FindBy(className = "primary")
  private WebElement addressTable;

  @FindBy(css = "#yui-main > div > table.secondary")
  private WebElement questionnaireTable;

  @FindBy(css = "#ft > table:nth-child(3)")
  private WebElement eventsTable;

  @FindBy(css = "#ft > table:nth-child(5)")
  private WebElement actionsTable;

  /**
   * Constructor
   *
   * @param webDriver Selenium web driver
   */
  public EventsResponseOperation(WebDriver webDriver) {
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
   * Get questionnaire table from page
   *
   * @return WebElement for questionnaire table
   */
  public WebElement getQuestionnaireTable() {
    return questionnaireTable;
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
}
