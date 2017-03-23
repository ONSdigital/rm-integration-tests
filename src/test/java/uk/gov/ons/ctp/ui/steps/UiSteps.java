package uk.gov.ons.ctp.ui.steps;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertFalse;
import static org.junit.Assert.assertTrue;

import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.List;

import org.openqa.selenium.By;
import org.openqa.selenium.WebElement;

import cucumber.api.DataTable;
import cucumber.api.java.en.Given;
import cucumber.api.java.en.Then;
import cucumber.api.java.en.When;
import uk.gov.ons.ctp.ui.util.UiResponseAware;

/**
 * Created by Stephen Goddard on 24/05/16.
 * Edited by Chris Hardman on 18/11/16
 */
public class UiSteps {
  private final UiResponseAware responseAware;

  /**
   * Constructor
   *
   * @param uiResponseAware ui runner
   */
  public UiSteps(UiResponseAware uiResponseAware) {
    this.responseAware = uiResponseAware;
  }

  /**
   * Login to UI
   *
   * @param user string representation of the user
   * @param browser string representation of the browser
   * @throws Throwable pass the exception
   */
  @Given("^the \"(.*?)\" user has logged in using \"(.*?)\"$")
  public void the_user_has_logged_in_using(String user, String browser) throws Throwable {
    responseAware.invokeUILogin(user, browser);
  }

  /**
   * Gets message from the welcome page after login to check correct permissions
   *
   * @param user type of user
   * @throws Throwable pass the exception
   */
  @Then("^permissions should be verified for user \"(.*?)\"$")
  public void permissions_should_be_verified_for_user(String user) throws Throwable {
    boolean result = false;
    String msg = responseAware.invokeGetUserLoginMessage();

    if (msg.equals("Welcome back Collect CSO User.") && user.equals("cso")) {
      result = true;
    } else if (msg.equals("Welcome back General Escalate.") && user.equals("general")) {
      result = true;
    } else if (msg.equals("Welcome back Field Escalate.") && user.equals("field")) {
      result = true;
    } else if (msg.equals("Welcome back Collect Reports user.") && user.equals("report")) {
      result = true;
    } else if (msg.equals("You could not be signed in. Did you enter the correct credentials?")
        && user.equals("error")) {
      result = true;
    }

    assertTrue("Login message '" + msg + "' does not match user: " + user, result);
  }

  /**
   * Get addresses for postcode
   *
   * @param postcode to be used
   * @throws Throwable pass the exception
   */
  @When("^the user gets the addresses for postcode \"(.*?)\"$")
  public void the_user_gets_the_addresses_for_postcode(String postcode) throws Throwable {
    responseAware.invokeUIPostcodeSelect(postcode);
  }

  /**
   * Get address from table
   *
   * @param address to be used
   * @throws Throwable pass the exception
   */
  @When("^selects case for address \"(.*?)\"$")
  public void selects_case_for_address(String address) throws Throwable {
    responseAware.invokeUIAddressSelect(address);
  }

  /**
   * Get addresses message from addresses page
   *
   * @param found string for expected result
   * @throws Throwable pass the exception
   */
  @Then("^the user gets the verification for found addresses \"(.*?)\"")
  public void the_user_gets_the_verification_for_found_addresses(String found) throws Throwable {
    boolean result = false;
    String msg = "";

    if (Boolean.parseBoolean(found)) {
      msg = responseAware.invokeGetAddressesFoundMessage();
      result = msg.equals("Click to view cases for an address.");
    } else {
      msg = responseAware.invokeGetNoAddressesFoundMessage();
      result = msg.equals("There are no addresses for this postcode.");
    }

    assertTrue("Expected address message does not match result: " + msg, result);
  }


  /**
   * Get addresses for postcode
   *
   * @param data to validate and search for
   */
//  @Then("^reviews and validates information \"(.*?)\"")
//  public void reviews_and_validates_information(String data) {
//    assertTrue(responseAware.invokeUICaseInformationVerification(data));
//  }

  /**
   * Navigate to cases page for case id
   *
   * @param caseId to be used
   * @throws Throwable pass the exception
   */
  @When("^navigates to the cases page for case \"(.*?)\"$")
  public void navigates_to_the_cases_page_for_case(String caseId) throws Throwable {
    responseAware.invokeUICasesPage(caseId);
  }

  /**
   * Navigate to the given page
   *
   * @param page to be navigated to
   * @throws Throwable pass the exception
   */
//  @When("^navigates to the \"(.*?)\" page")
//  public void navigates_to_the_page(String page) throws Throwable {
//    responseAware.invokeUIReportsPage(page);
//  }

  /**
   * The table contains the elements
   *
   * @param firstElement the first element to check for in the table
   * @param secondElement the second element to check for in the table
   * @param columnOne the first column to check for in the table
   * @param columnTwo the second column to check for in the table
   * @throws Throwable pass the exception
   */
//  @When("^the first row of the table should contain the values \"(.*?)\" and \"(.*?)\" in columns (\\d+) and (\\d+)$")
//  public void the_first_row_of_the_table_should_contain_the_values_and(
//      String firstElement, String secondElement, int columnOne, int  columnTwo) throws Throwable {
//    assertEquals(responseAware.invokeCheckReportContents(columnOne), firstElement);
//    assertEquals(responseAware.invokeCheckReportContents(columnTwo), secondElement);
//  }

  /**
   * The table headings contain the text
   *
   * @param firstHeading the first heading in the table
   * @param secondHeading the second heading in the table
   * @throws Throwable pass the exception
   */
//  @When("^the table should contain the headings \"(.*?)\" and \"(.*?)\"")
//  public void the_table_should_contain_the_headings_and(String firstHeading, String secondHeading) throws Throwable {
//    assertTrue(responseAware.invokeCheckReportHeadings(firstHeading, secondHeading));
//  }

  /**
   * Check that an error message is displayed
   *
   * @throws Throwable pass the exception
   */
//  @When("^an error message appears on screen")
//  public void an_error_message_appears_on_screen() throws Throwable {
//    assertFalse(responseAware.invokeUIReportsCheckError("information"));
//  }

  /**
   * Check that an error message is not displayed
   *
   * @throws Throwable pass the exception
   */
//  @When("^there is no error message")
//  public void there_is_no_error_message() throws Throwable {
//    assertTrue(responseAware.invokeUIReportsCheckError("information"));
//  }

  /**
   * Check that the error message is correct
   *
   * @param expectedError the error message expected
   * @throws Throwable pass the exception
   */
//  @When("^the error message is \"(.*?)\"$")
//  public void the_error_message_is(String expectedError) throws Throwable {
//    assertTrue(responseAware.invokeReportErrorCheck(expectedError));
//  }

  /**
   * Check that report for specified date exists
   *
   * @throws Throwable pass the exception
   */
//  @When("^the report for todays date should be present$")
//  public void the_report_for_todays_date_should_be_present() throws Throwable {
//    String date = responseAware.invokeReportDateCheck();
//    Date today = Calendar.getInstance().getTime();
//    SimpleDateFormat sdf = new SimpleDateFormat("EEEE, dd MMM yyyy");
//    assertTrue("Report date doesn't match", date.startsWith(sdf.format(today)));
//  }

  /**
   * Validates the report types
   *
   * @throws Throwable pass the exception
   */
//  @Then("validates the report types shown to the user$")
//  public void validates_the_report_types_shown_to_the_user() throws Throwable {
//    assertTrue(responseAware.invokeValidateOnReportTypes());
//  }

  /**
   * Confirm cases are associated with an address
   */
  @When("^check cases are associated with address$")
  public void check_cases_are_associated_with_address() {
    int result = responseAware.checkCasesCount();
    
    assertTrue("No cases found for address", result == 2);
  }

  /**
   * Confirm no cases are associated with an address
   */
  @When("^check no cases are associated with address$")
  public void check_no_cases_are_associated_with_address() {
    int result = responseAware.checkCasesCount();
    
    assertTrue("Cases found for address", result == 1);
  }

  /**
   * Create case event with provided content
   *
   * @param content to be used to fill in form
   * @throws Throwable pass the exception
   */
  @When("^the user creates a new event for$")
  public void the_user_creates_a_new_event_for(DataTable content) throws Throwable {
    List<String> formContent = content.asList(String.class);
    responseAware.invokeUICreateCaseEvent(formContent);
  }

  /**
   * Navigate back to the cases page from events page
   *
   * @throws Throwable pass the exception
   */
  @When("^the user navigates back to the cases page$")
  public void the_user_navigates_back_to_the_cases_page() throws Throwable {
    responseAware.invokeUINavigateBackToCase();
  }

  /**
   * Navigate to the escalated page on UI
   *
   * @param ecalatedType type of escalation to be navigated to
   * @throws Throwable pass the exception
   */
  @When("^navigates to the escalated page \"(.*?)\"$")
  public void navigates_to_the_escalated_page(String ecalatedType) throws Throwable {
    responseAware.invokeUIEscalation(ecalatedType);
  }

  /**
   * Create a request for an individual response
   *
   * @param content to be used to fill in form
   * @throws Throwable pass the exception
   */
  @When("^the user requests an individual request for$")
  public void the_user_requests_an_individual_request_for(DataTable content) throws Throwable {
    List<String> formContent = content.asList(String.class);
    responseAware.invokeUICreateIndividualRequest(formContent);
  }

  /**
   * Create a request for a replacement paper form
   *
   * @param content to be used to fill in form
   * @throws Throwable pass the exception
   */
  @When("^the user requests a replacement paper form$")
  public void the_user_requests_a_replacement_paper_form(DataTable content) throws Throwable {
    List<String> formContent = content.asList(String.class);
    responseAware.invokeUICreateReplacementPaperRequest(formContent);
  }

  /**
   * Create a request for a replacement IAC
   *
   * @param content to be used to fill in form
   * @throws Throwable pass the exception
   */
  @When("^the user requests a replacement IAC$")
  public void the_user_requests_a_replacement_IAC(DataTable content) throws Throwable {
    List<String> formContent = content.asList(String.class);
    responseAware.invokeUICreateReplacementIACRequest(formContent);
  }

  /**
   * Create a request for a translation booklet
   *
   * @param language to be requested
   * @throws Throwable pass the exception
   */
  @When("^the user requests a translation booklet for \"(.*?)\"$")
  public void the_user_requests_a_translation_booklet_for(String language) throws Throwable {
    responseAware.invokeUICreateTranslationRequest(language);
  }

  /**
   * Navigate to the case page from the escalated complaints on UI
   *
   * @param caseId to be used
   * @throws Throwable pass the exception
   */
  @When("^selects case page for \"(.*?)\"$")
  public void selects_case_page_for(String caseId) throws Throwable {
    responseAware.invokeUIManagerCasePage(caseId);
  }

  /**
   * Test state of case for a specific case
   *
   * @param caseId case to be tested
   * @param state to be tested
   * @throws Throwable pass the exception
   */
  @Then("^the case state for \"(.*?)\" should be \"(.*?)\"$")
  public void the_case_state_for_should_be(String caseId, String state) throws Throwable {
    String caseState = responseAware.invokeCaseStateCheck(caseId);
    assertEquals("Status not as expected", state, caseState);
  }

  /**
   * Test event description
   *
   * @param description to be tested
   * @throws Throwable pass the exception
   */
  @Then("^the description should be \"(.*?)\"$")
  public void the_description_should_be(String description) throws Throwable {
    String uiDescription = responseAware.invokeDescriptionCheck();
    assertEquals("Description not as expected: " + uiDescription, uiDescription, description);
  }

  /**
   * Test case event category is as expected
   *
   * @param category value to be tested against
   * @throws Throwable pass the exception
   */
  @Then("^the case event category should be \"(.*?)\"$")
  public void the_case_event_category_should_be(String category) throws Throwable {
    String caseEventCat = responseAware.invokeCaseEventCategory();
    assertEquals("Event category not as expected: " + caseEventCat, category, caseEventCat);
  }

  /**
   * Test case event is in the table as expected
   *
   * @param category value to be tested against
   * @throws Throwable pass the exception
   */
  @Then("^the case event category should contain \"(.*?)\"$")
  public void the_case_event_category_should_contain(String category) throws Throwable {
    List<String> caseEvents = responseAware.invokeCaseEventCategoryList();
    assertTrue("Event category not found: " + caseEvents, caseEvents.contains(category));
  }

  /**
   * Test case action category are as expected
   *
   * @param category value to be tested against
   * @throws Throwable pass the exception
   */
  @Then("^the case action should be \"(.*?)\"$")
  public void the_case_action_should_be(String category) throws Throwable {
    String caseEventCat = responseAware.invokeCaseActionCategory();
    assertEquals("Case Action not as expected: " + caseEventCat, category, caseEventCat);
  }

  /**
   * Test case event description is as expected
   *
   * @param description value to be tested against
   * @throws Throwable pass the exception
   */
  @Then("^the case event description should be \"(.*?)\"$")
  public void the_case_event_description_should_be(String description) throws Throwable {
    String caseDescCat = responseAware.invokeCaseEventDescription();
    assertEquals("Event description not as expected: " + caseDescCat, description, caseDescCat);
  }

  /**
   * Test case event is not removed from the view list as expected
   *
   * @param caseId value to be tested against
   * @throws Throwable pass the exception
   */
  @When("^the case page for \"(.*?)\" is present")
  public void the_case_page_for_is_present(String caseId) throws Throwable {
    assertFalse(responseAware.checkCaseIdRemoved(caseId));
  }

  /**
   * Test case event is removed from the view list as expected
   *
   * @param caseId value to be tested against
   * @throws Throwable pass the exception
   */
  @When("^the case page for \"(.*?)\" is no longer present")
  public void the_case_page_for_is_no_longer_present(String caseId) throws Throwable {
    assertTrue(responseAware.checkCaseIdRemoved(caseId));
  }

  /**
   * Test case event description is as expected
   *
   * @param description value to be tested against
   * @throws Throwable pass the exception
   */
  @Then("^the case event description should contain \"(.*?)\"$")
  public void the_case_event_description_should_contain(String description) throws Throwable {
    List<String> caseDescList = responseAware.invokeCaseEventDescriptionList();
    assertTrue("Event description not found: " + caseDescList, caseDescList.contains(description));
  }

  /**
   * Test case event history category is visible
   */
  @Then("^event history should be visible$")
  public void event_history_should_be_visible() {
    responseAware.eventHistoryVisible();
  }

  /**
   * Test response has been submitted to case
   */
  @Then("^check if a response has been submitted$")
  public void check_if_a_response_has_been_submitted() {
    responseAware.checkResponseSubmitted();
  }

  /**
   * Log out of UI and close browser
   *
   * @throws Throwable pass the exception
   */
  @Then("^the user logs out$")
  public void the_user_logs_out() throws Throwable {
    responseAware.invokeLogout();
    responseAware.closeWebDriver();
  }

  /**
   * close browser
   *
   * @throws Throwable pass the exception
   */
  @Then("^close browser$")
  public void close_browser() throws Throwable {
    responseAware.closeWebDriver();
  }
}
