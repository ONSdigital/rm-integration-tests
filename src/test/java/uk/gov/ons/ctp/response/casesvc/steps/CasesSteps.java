package uk.gov.ons.ctp.response.casesvc.steps;

import java.util.List;
import java.util.Properties;

//import org.json.JSONObject;
//
//import cucumber.api.DataTable;
import cucumber.api.java.en.Given;
import cucumber.api.java.en.When;
import uk.gov.ons.ctp.response.casesvc.util.CaseResponseAware;

/**
 * Created by Stephen Goddard on 7/3/16.
 */
public class CasesSteps {
  private final CaseResponseAware responseAware;

  /**
   * Constructor
   *
   * @param caseResponseAware case frame end point runner
   */
  public CasesSteps(CaseResponseAware caseResponseAware) {
    this.responseAware = caseResponseAware;
  }

  /**
   * Test get request for /cases/iac/{iac} Optional parameters are passed from the feature file to the url
   *
   * @param params Url parameters
   * @throws Throwable pass the exception
   */
  @Given("^I make the GET call to the caseservice case endpoint for iac with parameters \"(.*?)\"$")
  public void i_make_the_GET_call_to_the_caseservice_case_endpoint_for_iac_with_parameters(String params)
      throws Throwable {
    responseAware.invokeCaseIACEndpoint(null, params);
  }

  /**
   * Test get request for /cases/iac/{iac} invalid iac with no parameters
   *
   * @param iac code to get case for
   * @throws Throwable pass the exception
   */
  @When("^I make the GET call to the caseservice case endpoint for invalid iac \"(.*?)\"$")
  public void i_make_the_GET_call_to_the_caseservice_case_endpoint_for_invalid_iac(String iac) throws Throwable {
    responseAware.invokeCaseIACEndpoint(iac, "");
  }

  /**
   * Test get request for /cases/{caseId} invalid iac with no parameters
   *
   * @param params Url parameters
   * @throws Throwable pass the exception
   */
  @When("^I make the GET call to the caseservice cases endpoint for case with parameters \"(.*?)\"$")
  public void i_make_the_GET_call_to_the_caseservice_cases_endpoint_for_case_with_parameters(String params)
      throws Throwable {
    responseAware.invokeCasesEndpoint(null, params);
  }

  /**
   * Test get request for /cases/{caseId} invalid iac with no parameters
   *
   * @param caseid case id
   * @throws Throwable pass the exception
   */
  @When("^I make the GET call to the caseservice cases endpoint for case \"(.*?)\"$")
  public void i_make_the_GET_call_to_the_caseservice_cases_endpoint_for_case(String caseid) throws Throwable {
    responseAware.invokeCasesEndpoint(caseid, "");
  }

  /**
   * Test get request for /cases/partyid/{partyid} invalid iac with no parameters
   *
   * @param params Url parameters
   * @throws Throwable pass the exception
   */
  @Given("^I make the GET call to the caseservice cases endpoint for party with parameters \"(.*?)\"$")
  public void i_make_the_GET_call_to_the_caseservice_cases_endpoint_for_party_with_parameters(String params)
      throws Throwable {
    responseAware.invokePartyEndpoint(null, params);
  }

  /**
   * Test get request for /cases/partyid/{partyid} invalid partyid with no parameters
   *
   * @param partyId case id
   * @throws Throwable pass the exception
   */
  @Given("^I make the GET call to the caseservice cases endpoint for party \"(.*?)\"$")
  public void i_make_the_GET_call_to_the_caseservice_cases_endpoint_for_party(String partyId) throws Throwable {
    responseAware.invokePartyEndpoint(partyId, "");
  }

  /**
   * Test get request for /cases/caseevents/{caseid}
   *
   * @throws Throwable pass the exception
   */
  @Given("^I make the GET call to the caseservice cases endpoint for events$")
  public void i_make_the_GET_call_to_the_caseservice_cases_endpoint_for_events() throws Throwable {
    responseAware.invokeCasesEventsEndpoint(null);
  }

  /**
   * Test get request for /cases/caseevents/{caseid} invalid caseid with no parameters
   *
   * @param caseId case id
   * @throws Throwable pass the exception
   */
  @Given("^I make the GET call to the caseservice cases endpoint for events for \"(.*?)\"$")
  public void i_make_the_GET_call_to_the_caseservice_cases_endpoint_for_events_for(String caseId) throws Throwable {
    responseAware.invokeCasesEventsEndpoint(caseId);
  }

  /**
   * Test get request for /cases/{caseId}/events
   *
   * @param caseId case id
   * @throws Throwable pass the exception
   */
  @When("^I make the GET call to the caseservice cases endpoint for events for case \"(.*?)\"$")
  public void i_make_the_GET_call_to_the_caseservice_cases_endpoint_for_events_for_case(String caseId)
      throws Throwable {
    responseAware.invokeCasesEventsEndpoint(caseId);
  }

  /**
   * Test post request for /cases/{caseId}/events invalid input
   *
   * @param caseId case id
   * @throws Throwable pass the exception
   */
  @When("^I make the POST call to the caseservice cases events with invalid input for case id \"(.*?)\"$")
  public void i_make_the_POST_call_to_the_caseservice_cases_events_with_invalid_input_for_case_id(String caseId)
      throws Throwable {
    Properties properties = new Properties();
    properties.put("input", "invalid input value");

    responseAware.invokePostCasesEventsEndpoint(caseId, properties);
  }

  /**
   * Test post request for /cases/{caseId}/events
   *
   * @param getValues to be in json
   * @throws Throwable pass the exception
   */
  @When("^I make the POST call to the caseservice cases events$")
  public void i_make_the_POST_call_to_the_caseservice_cases_events(List<String> getValues) throws Throwable {
    Properties properties = new Properties();
    properties.put("description", getValues.get(0));
    properties.put("category", getValues.get(1));
    properties.put("subCategory", getValues.get(2));
    properties.put("createdBy", getValues.get(3));

    responseAware.invokePostCasesEventsEndpoint(getValues.get(4), properties);
  }

}
