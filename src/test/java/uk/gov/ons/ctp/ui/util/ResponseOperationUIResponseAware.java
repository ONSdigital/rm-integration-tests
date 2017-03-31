package uk.gov.ons.ctp.ui.util;

import java.util.List;

import uk.gov.ons.ctp.ui.util.ro.pom.AddressesResponseOperation;
import uk.gov.ons.ctp.ui.util.ro.pom.CasesResponseOperation;
import uk.gov.ons.ctp.ui.util.ro.pom.CreateEventResponseOperation;
import uk.gov.ons.ctp.ui.util.ro.pom.EscalatedCasesResponseOperation;
import uk.gov.ons.ctp.ui.util.ro.pom.EventsResponseOperation;
import uk.gov.ons.ctp.ui.util.ro.pom.ManageResponseOperation;
import uk.gov.ons.ctp.ui.util.ro.pom.PostcodeResponseOperation;
import uk.gov.ons.ctp.ui.util.ro.pom.TranslationResponseOperation;
import uk.gov.ons.ctp.util.World;

/**
 * Created by Stephen Goddard on 24/05/16.
 * Edited by Chris Hardman on 17/11/16
 *
 */
public class ResponseOperationUIResponseAware extends SeleniumAware {

  /**
   * Constructor
   *
   * @param newWorld class with application and environment properties
   */
  public ResponseOperationUIResponseAware(final World newWorld) {
    super(newWorld);
  }

  /**
   * Gets the user login message
   *
   * @return string login message
   */
  public String invokeGetUserLoginMessage() {
    PostcodeResponseOperation postcodeRO = new PostcodeResponseOperation(getWebDriver());
    return postcodeRO.getLoginMsg();
  }

  /**
   * Enter a postcode to page and enter
   *
   * @param postcode string representation of postcode
   */
  public void invokeUIPostcodeSelect(String postcode) {
    // Note postcode field not part of form HtmlUnit will not recognise element.
    // Skip entering postcode and go direct using URL.
    final String url = String.format("/postcodes/%s", postcode);
    invokeGoToPage(url);
  }

  /**
   * Get addresses found message
   *
   * @return String message
   */
  public String invokeGetAddressesFoundMessage() {
    AddressesResponseOperation addressesRO = new AddressesResponseOperation(getWebDriver());
    return addressesRO.getAddressMsg();
  }

  /**
   * Get no addresses found message
   *
   * @return String message
   */
  public String invokeGetNoAddressesFoundMessage() {
    AddressesResponseOperation addressesRO = new AddressesResponseOperation(getWebDriver());
    return addressesRO.getNoAddressMsg();
  }

  /**
   * Get invalid postcode message
   *
   * @return String message
   */
  public String invokeGetInvalidPostcodeMessage() {
    AddressesResponseOperation addressesRO = new AddressesResponseOperation(getWebDriver());
    return addressesRO.getInvalidPostcodeMsg();
  }

  /**
   * Select address from table and click view cases
   *
   * @param address string representation of address to find in table
   */
  public void invokeUIAddressSelect(String address) {
    AddressesResponseOperation addressesRO = new AddressesResponseOperation(getWebDriver());
    addressesRO.selectAddress(address);
  }

  /**
   * get question set from case table on case page
   *
   * @return question set
   */
  public String invokeGetCaseQuestionSet() {
    CasesResponseOperation casesRO = new CasesResponseOperation(getWebDriver());
    return casesRO.getCaseQuestionSet();
  }

  /**
   * get address type from address table on case page
   *
   * @return address type
   */
  public String invokeGetAddressType() {
    CasesResponseOperation casesRO = new CasesResponseOperation(getWebDriver());
    return casesRO.getAddressType();
  }

  /**
   * Select case id to load case page
   *
   * @param caseId string representation of case id to select
   */
  public void invokeUICasesPage(String caseId) {
    CasesResponseOperation casesRO = new CasesResponseOperation(getWebDriver());
    casesRO.clickOnCaseLink(caseId);
  }

  /**
   * Returns the number of tables on cases page
   *
   * @return number of tables
   */
  public int checkCasesCount() {
    CasesResponseOperation casesRO = new CasesResponseOperation(getWebDriver());
    return casesRO.getNumberTablesOnPage();
  }

  /**
   * Create a request for an individual form
   *
   * @param formContent List of content to fill in form
   */
  public void invokeUICreateIndividualRequest(List<String> formContent) {
    EventsResponseOperation eventsRO = new EventsResponseOperation(getWebDriver());
    eventsRO.clickIndividualForm();

    invokeUICompleteForm(formContent);
  }

  /**
   * Create a request for a replacement IAC
   *
   * @param formContent List of content to fill in form
   */
  public void invokeUICreateReplacementIACRequest(List<String> formContent) {
    EventsResponseOperation eventsRO = new EventsResponseOperation(getWebDriver());
    eventsRO.clickReplacementCodeForm();

    invokeUICompleteForm(formContent);
  }

  /**
   * Create a request for a replacement paper form
   *
   * @param formContent List of content to fill in form
   */
  public void invokeUICreateReplacementPaperRequest(List<String> formContent) {
    EventsResponseOperation eventsRO = new EventsResponseOperation(getWebDriver());
    eventsRO.clickPaperForm();

    invokeUICompleteForm(formContent);
  }

  /**
   * Complete the form as per form content
   *
   * @param formContent List of content to fill in form
   */
  private void invokeUICompleteForm(List<String> formContent) {
    CreateEventResponseOperation createEventRO = new CreateEventResponseOperation(getWebDriver());
    createEventRO.completeAndSubmitIndiviualForm(formContent);
  }

  /**
   * Create a request for a translation booklet
   *
   * @param translation to request
   */
  public void invokeUICreateTranslationRequest(String translation) {
    EventsResponseOperation eventsRO = new EventsResponseOperation(getWebDriver());
    eventsRO.clickTranslationBooklet();

    TranslationResponseOperation translationRO = new TranslationResponseOperation(getWebDriver());
    translationRO.completeAndSubmitTranslationRequest(translation);
  }

  /**
   * Create an event and submit
   *
   * @param formContent List of content to fill in form
   */
  public void invokeUICreateCaseEvent(List<String> formContent) {
    EventsResponseOperation eventsRO = new EventsResponseOperation(getWebDriver());
    eventsRO.clickCreateEventButton();

    CreateEventResponseOperation createEventRO = new CreateEventResponseOperation(getWebDriver());
    createEventRO.completeAndSubmitCreateEventForm(formContent);
  }

  /**
   * Navigate back to the case screen for the current case
   */
  public void invokeUINavigateBackToCase() {
    EventsResponseOperation eventsRO = new EventsResponseOperation(getWebDriver());
    eventsRO.clickCasesBreadcrumb();
  }

  /**
   * Navigate to the escalated page
   *
   * @param type of escalation to navigate to
   */
  public void invokeUIEscalation(String type) {
    ManageResponseOperation manageRO = new ManageResponseOperation(getWebDriver());
    manageRO.clickEscalationLink(type);
  }

  /**
   * Navigate to the given page
   */
  public void invokeUIClickAdditionalFuctionLink() {
    PostcodeResponseOperation postcodeRO = new PostcodeResponseOperation(getWebDriver());
    postcodeRO.clickAdditionalFuctionLink();
  }

  /**
   * Navigate to specified page on UI
   *
   * @param url go to page on UI
   */
  public void invokeGoToPage(String url) {
    invokeNavigateToPage(getWorld().getUiUrl(url));
  }

  /**
   * Extract case state from UI  for specific case and return value
   *
   * @param caseId to search for
   * @return case state for case id
   */
  public String invokeCaseStateCheck(String caseId) {
    CasesResponseOperation casesRO = new CasesResponseOperation(getWebDriver());
    return casesRO.getCaseStateForCase(caseId);
  }

  /**
   * Extract case event category from UI and return value
   *
   * @return case event category on page
   */
  public String invokeCaseEventCategory() {
    EventsResponseOperation eventsRO = new EventsResponseOperation(getWebDriver());
    return eventsRO.getMostRecentEventCategory();
  }

  /**
   * Extract case events from UI and returns list
   *
   * @return case event list
   */
  public List<String> invokeCaseEventCategoryList() {
    EventsResponseOperation eventsRO = new EventsResponseOperation(getWebDriver());
    return eventsRO.getListEventCategory();
  }

  /**
   * Extract case action state from UI and return value
   *
   * @return action state
   */
  public String invokeCaseActionState() {
    EventsResponseOperation eventsRO = new EventsResponseOperation(getWebDriver());
    return eventsRO.getActionState();
  }

  /**
   * Extract case event description from UI and return value
   *
   * @return case event category on page
   */
  public String invokeCaseEventDescription() {
    EventsResponseOperation eventsRO = new EventsResponseOperation(getWebDriver());
    return eventsRO.getMostRecentEventDescription();
  }

  /**
   * Extract case event description from UI and return value
   *
   * @return case event category on page
   */
  public List<String> invokeCaseEventDescriptionList() {
    EventsResponseOperation eventsRO = new EventsResponseOperation(getWebDriver());
    return eventsRO.getListEventDescription();
  }

  /**
   * Check if case event history is displayed
   *
   * @return true if table is displayed
   */
  public boolean eventHistoryDisplayed() {
    EventsResponseOperation eventsRO = new EventsResponseOperation(getWebDriver());
    return eventsRO.isActionTableDisplayed();
  }

  /**
   * Check if response date has been displayed for questionnaire
   *
   * @return response date as string
   */
  public String checkResponseDateDisplayed() {
    EventsResponseOperation eventsRO = new EventsResponseOperation(getWebDriver());
    return eventsRO.getResponseDate();
  }

  /**
   * Check to see if the specified caseId link is in the table
   *
   * @param caseId to check for
   * @return boolean
   */
  public boolean isCaseLinkEmpty(String caseId) {
    EscalatedCasesResponseOperation escalatedcaseRO = new EscalatedCasesResponseOperation(getWebDriver());
    return escalatedcaseRO.caseLinkIsEmpty(caseId);
  }
}
