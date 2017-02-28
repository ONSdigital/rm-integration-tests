package uk.gov.ons.ctp.response.casesvc.steps;

import java.util.List;
import java.util.Properties;

import org.json.JSONObject;

import com.jayway.jsonpath.JsonPath;

import cucumber.api.DataTable;
import cucumber.api.java.en.Then;
import cucumber.api.java.en.When;
import uk.gov.ons.ctp.response.casesvc.util.CaseResponseAware;

/**
 * Created by Stephen Goddard on 7/3/16.
 */
public class CasesSteps {
  private final CaseResponseAware responseAware;

  private static final int CASEID = 1;
  private static final int DESC_LABEL = 2;
  private static final int DESC_VALUE = 3;
  private static final int CAT_LABEL = 4;
  private static final int CAT_VALUE = 5;
  private static final int SUBCAT_LABEL = 6;
  private static final int SUBCAT_VALUE = 7;
  private static final int CREATE_LABEL = 8;
  private static final int CREATE_VALUE = 9;

  private static final int CASE_CREATE_LABEL = 10;
  private static final int CASE_TYPE_LABEL = 12;
  private static final int CASE_TYPE_VALUE = 13;
  private static final int ACTION_PLAN_LABEL = 14;
  private static final int ACTION_PLAN_VALUE = 15;
  private static final int TITLE_LABEL = 16;
  private static final int TITLE_VALUE = 17;
  private static final int FORENAME_LABEL = 18;
  private static final int FORENAME_VALUE = 19;
  private static final int SURNAME_LABEL = 20;
  private static final int SURNAME_VALUE = 21;
  private static final int PHONE_LABEL = 22;
  private static final int PHONE_VALUE = 23;
  private static final int EMAIL_LABEL = 24;
  private static final int EMAIL_VALUE = 25;

  /**
   * Constructor
   *
   * @param caseResponseAware case frame end point runner
   */
  public CasesSteps(CaseResponseAware caseResponseAware) {
    this.responseAware = caseResponseAware;
  }

  /**
   * Test get request for /cases/casegroup/{casegroupid}
   *
   * @param caseGroupId case group id
   * @throws Throwable pass the exception
   */
  @When("^I make the GET call to the caseservice case endpoint for casegroupid \"(.*?)\"$")
  public void i_make_the_GET_call_to_the_caseservice_case_endpoint_for_casegroupid(String caseGroupId)
      throws Throwable {
    responseAware.invokeCaseGroupEndpoint(caseGroupId);
  }

  /**
   * Test get request for /cases/iac/{iac} iac
   * Note: a previous run to get case is required so an IAC is available to test
   *
   * @throws Throwable pass the exception
   */
  @When("^I make the GET call to the caseservice case endpoint for iac$")
  public void i_make_the_GET_call_to_the_caseservice_case_endpoint_for_iac() throws Throwable {
    String iac = JsonPath.read(responseAware.getBody(), "$.iac");
    iac = iac.replaceAll("\\s+", "%20");

    responseAware.invokeCaseIACEndpoint(iac);
  }

  /**
   * Test get request for /cases/iac/{iac} invalid iac
   *
   * @param iac code to get case for
   * @throws Throwable pass the exception
   */
  @When("^I make the GET call to the caseservice case endpoint for invalid iac \"(.*?)\"$")
  public void i_make_the_GET_call_to_the_caseservice_case_endpoint_for_invalid_iac(String iac) throws Throwable {
    responseAware.invokeCaseIACEndpoint(iac);
  }

  /**
   * Test get request for /cases/{caseId}
   *
   * @param caseid case id
   * @throws Throwable pass the exception
   */
  @When("^I make the GET call to the caseservice cases endpoint for case \"(.*?)\"$")
  public void i_make_the_GET_call_to_the_caseservice_cases_endpoint_for_case(String caseid) throws Throwable {
    responseAware.invokeCasesEndpoint(caseid);
  }

  /**
   * Test get request for /cases/{caseId} where caseId is taken from a previous get
   *
   * @throws Throwable pass the exception
   */
  @Then("^I make the GET call to the caseservice cases endpoint for current case$")
  public void i_make_the_GET_call_to_the_caseservice_cases_endpoint_for_current_case() throws Throwable {
    Integer caseId = JsonPath.read(responseAware.getBody(), "$." + "caseId");
    responseAware.invokeCasesEndpoint(caseId.toString());
  }

  /**
   * Test get request for /cases/{caseId}/events
   *
   * @param caseid case id
   * @throws Throwable pass the exception
   */
  @When("^I make the GET call to the caseservice cases endpoint for events for case \"(.*?)\"$")
  public void i_make_the_GET_call_to_the_caseservice_cases_endpoint_for_events_for_case(String caseid)
      throws Throwable {
    responseAware.invokeCasesEventsEndpoint(caseid);
  }

  /**
   * Test post request for /cases/{caseId}/events invalid input
   *
   * @param caseid case id
   * @throws Throwable pass the exception
   */
  @When("^I make the POST call to the caseservice cases events with invalid input for case id \"(.*?)\"$")
  public void i_make_the_POST_call_to_the_caseservice_cases_events_with_invalid_input_for_case_id(String caseid)
      throws Throwable {
    Properties properties = new Properties();
    properties.put("input", "invalid input value");

    responseAware.invokePostCasesEventsEndpoint(caseid, properties);
  }

  /**
   * Test post request for /cases/{caseId}/events
   *
   * @param content to be in json
   * @throws Throwable pass the exception
   */
  @When("^I make the POST call to the caseservice cases events$")
  public void i_make_the_POST_call_to_the_caseservice_cases_events(DataTable content) throws Throwable {
    List<String> jsonContent = content.asList(String.class);

    JSONObject json = new JSONObject();
    json.put(jsonContent.get(DESC_LABEL), jsonContent.get(DESC_VALUE));
    json.put(jsonContent.get(CAT_LABEL), jsonContent.get(CAT_VALUE));
    json.put(jsonContent.get(SUBCAT_LABEL), jsonContent.get(SUBCAT_VALUE));
    json.put(jsonContent.get(CREATE_LABEL), jsonContent.get(CREATE_VALUE));

    JSONObject subJson = new JSONObject();
    subJson.put(jsonContent.get(CASE_TYPE_LABEL), Integer.parseInt(jsonContent.get(CASE_TYPE_VALUE)));
    subJson.put(jsonContent.get(ACTION_PLAN_LABEL), Integer.parseInt(jsonContent.get(ACTION_PLAN_VALUE)));
    subJson.put(jsonContent.get(TITLE_LABEL), jsonContent.get(TITLE_VALUE));
    subJson.put(jsonContent.get(FORENAME_LABEL), jsonContent.get(FORENAME_VALUE));
    subJson.put(jsonContent.get(SURNAME_LABEL), jsonContent.get(SURNAME_VALUE));
    subJson.put(jsonContent.get(PHONE_LABEL), jsonContent.get(PHONE_VALUE));
    subJson.put(jsonContent.get(EMAIL_LABEL), jsonContent.get(EMAIL_VALUE));
    json.put(jsonContent.get(CASE_CREATE_LABEL), subJson);

    responseAware.invokePostCasesEventsEndpoint(jsonContent.get(CASEID), json.toString());
  }

}
