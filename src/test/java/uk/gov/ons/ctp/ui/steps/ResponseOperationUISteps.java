package uk.gov.ons.ctp.ui.steps;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertFalse;
import static org.junit.Assert.assertTrue;

import java.util.List;

import cucumber.api.DataTable;
import cucumber.api.java.en.Given;
import cucumber.api.java.en.Then;
import cucumber.api.java.en.When;
import uk.gov.ons.ctp.ui.util.ResponseOperationUIResponseAware;

/**
 * Created by Stephen Goddard on 24/05/16.
 * Edited by Chris Hardman on 18/11/16
 */
public class ResponseOperationUISteps {
  private final ResponseOperationUIResponseAware responseAware;

  /**
   * Constructor
   *
   * @param uiResponseAware ui runner
   */
  public ResponseOperationUISteps(ResponseOperationUIResponseAware uiResponseAware) {
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
   * Get cases for address
   *
   * @param address to be used
   * @throws Throwable pass the exception
   */
  @When("^selects case for address \"(.*?)\"$")
  public void selects_case_for_address(String address) throws Throwable {
    responseAware.invokeUIAddressSelect(address);
  }

  /**
   * verifies addresses message found from addresses page
   *
   * @throws Throwable pass the exception
   */
  @Then("^the user gets verification addresses found$")
  public void the_user_gets_verification_addresses_found() throws Throwable {
    String msg = responseAware.invokeGetAddressesFoundMessage();
    assertTrue("No addresses found with message: " + msg, msg.equals("Click to view cases for an address."));
  }

  /**
   * verifies no addresses message found from addresses page
   *
   * @throws Throwable pass the exception
   */
  @Then("^the user gets verification addresses not found$")
  public void the_user_gets_verification_addresses_not_found() throws Throwable {
    String invalidMsg = responseAware.invokeGetInvalidPostcodeMessage();
    assertTrue("Invalid postcode found message: " + invalidMsg, invalidMsg.equals(""));

    String msg = responseAware.invokeGetNoAddressesFoundMessage();
    assertTrue("Addresses found with message: " + msg, msg.equals("There are no addresses for this postcode."));
  }

  /**
   * verifies invalid postcode message found from addresses page
   *
   * @throws Throwable pass the exception
   */
  @Then("^the user gets verification of invalid postcode$")
  public void the_user_gets_verification_of_invalid_postcode() throws Throwable {
    String invalidMsg = responseAware.invokeGetInvalidPostcodeMessage();
    assertTrue("Addresses found with message: " + invalidMsg, invalidMsg.equals("• Please enter a valid postcode"));

    String msg = responseAware.invokeGetNoAddressesFoundMessage();
    assertTrue("Addresses found with message: " + msg, msg.equals("There are no addresses for this postcode."));
  }

  /**
   * Get question set from case table on case page
   *
   * @param qSet question set to be validated against
   * @throws Throwable pass the exception
   */
  @Then("^the case questionset should be \"(.*?)\"$")
  public void the_case_questionset_should_be(String qSet) throws Throwable {
    String result = responseAware.invokeGetCaseQuestionSet();
    assertTrue("Invalid question set found: " + result, result.equals(qSet));
  }

  /**
   * Get address type from address table on case page
   *
   * @param addressType to be validated against
   * @throws Throwable pass the exception
   */
  @Then("^the case address type should be \"(.*?)\"$")
  public void the_case_address_type_should_be(String addressType) throws Throwable {
    String result = responseAware.invokeGetAddressType();
    assertTrue("Invalid address type found: " + result, result.equals(addressType));
  }

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
   * Confirm cases are associated with an address by confirming the cases table exists
   */
  @When("^check cases are associated with address$")
  public void check_cases_are_associated_with_address() {
    int result = responseAware.checkCasesCount();
    assertTrue("No cases found for address", result == 2);
  }

  /**
   * Confirm no cases are associated with an address by confirming the cases table does not exists
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
   * @throws Throwable pass the exception
   */
  @When("^the user navigates to the page for escalations$")
  public void the_user_navigates_to_the_page_for_escalations() throws Throwable {
    responseAware.invokeUIClickAdditionalFuctionLink();
  }

  /**
   * Navigate to the escalated page for the type of escalated cases
   *
   * @param ecalatedType type of escalation to be navigated to
   * @throws Throwable pass the exception
   */
  @When("^navigates to the escalated page \"(.*?)\"$")
  public void navigates_to_the_escalated_page(String ecalatedType) throws Throwable {
    responseAware.invokeUIEscalation(ecalatedType);
  }

  /**
   * Navigate to the reports page on UI
   *
   * @throws Throwable pass the exception
   */
  @When("^the user navigates to the page for reports$")
  public void the_user_navigates_to_the_page_for_reports() throws Throwable {
    responseAware.invokeUIClickAdditionalFuctionLink();
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
  @Then("^the action state should be \"(.*?)\"$")
  public void the_action_state_should_be(String category) throws Throwable {
    String eventState = responseAware.invokeCaseActionState();
    assertTrue("Case action state not as expected: " + eventState, category.equals(eventState));
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
   * Test escalated user can see case event is present from the view list
   *
   * @param caseId value to be tested against
   * @throws Throwable pass the exception
   */
  @When("^the escalated user checks case is present for \"(.*?)\"$")
  public void the_escalated_user_checks_case_is_present_for(String caseId) throws Throwable {
    assertFalse("Case not found in escalation review list", responseAware.isCaseLinkEmpty(caseId));
  }

  /**
   * Test escalated user can see case event is not present in the view list
   *
   * @param caseId value to be tested against
   * @throws Throwable pass the exception
   */
  @When("^the escalated user checks case is not present for \"(.*?)\"$")
  public void the_escalated_user_checks_case_is_not_present_for(String caseId) throws Throwable {
    assertTrue("Case found in escalation review list", responseAware.isCaseLinkEmpty(caseId));
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
   * Test case event history is displayed
   */
  @Then("^the event history should be displayed$")
  public void the_event_history_should_be_displayed() {
    assertTrue("Action Events table not found", responseAware.eventHistoryDisplayed());
  }

  /**
   * Test response has been submitted to case
   */
  @Then("^check response date is displayed$")
  public void check_response_date_is_displayed() {
    String result = responseAware.checkResponseDateDisplayed();
    assertFalse("Date found: " + result, result.equals("-"));
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
}
