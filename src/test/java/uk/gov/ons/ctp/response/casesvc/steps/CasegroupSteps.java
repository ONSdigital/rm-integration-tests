package uk.gov.ons.ctp.response.casesvc.steps;

import cucumber.api.java.en.Given;
import uk.gov.ons.ctp.response.casesvc.util.CaseResponseAware;

/**
 * Created by stephen.goddard on 29/9/16.
 */
public class CasegroupSteps {
  private final CaseResponseAware responseAware;

  /**
   * Constructor
   *
   * @param caseResponseAware case frame end point runner
   */
  public CasegroupSteps(CaseResponseAware caseResponseAware) {
    this.responseAware = caseResponseAware;
  }

  /**
   * Test get request for /casegroups/{caseGroupId}
   *
   * @throws Throwable pass the exception
   */
  @Given("^I make the GET call to the caseservice casegroups endpoint for casegroupid$")
  public void i_make_the_GET_call_to_the_caseservice_casegroups_endpoint_for_casegroupid() throws Throwable {
    responseAware.invokeCasegroupIdEndpoint(null);
  }

  /**
   * Test get request for /casegroups/{caseGroupId} invalid caseGroupId
   *
   * @param caseGroupId case group id
   * @throws Throwable pass the exception
   */
  @Given("^I make the GET call to the caseservice casegroup endpoint for casegroupid \"(.*?)\"$")
  public void i_make_the_GET_call_to_the_caseservice_casegroup_endpoint_for_casegroupid(String caseGroupId)
      throws Throwable {
    responseAware.invokeCasegroupIdEndpoint(caseGroupId);
  }

  /**
   * Test get request for /cases/casegroupid/{casegroupid}
   *
   * @throws Throwable pass the exception
   */
  @Given("^I make the GET call to the caseservice cases endpoint for casegroupid$")
  public void i_make_the_GET_call_to_the_caseservice_cases_endpoint_for_casegroupid() throws Throwable {
    responseAware.invokeCasesCasegroupEndpoint(null);
  }

  /**
   * Test get request for /cases/casegroupid/{casegroupid} invalid caseGroupId
   *
   * @param caseGroupId case group id
   * @throws Throwable pass the exception
   */
  @Given("^I make the GET call to the caseservice cases endpoint for casegroupid \"(.*?)\"$")
  public void i_make_the_GET_call_to_the_caseservice_cases_endpoint_for_casegroupid(String caseGroupId)
      throws Throwable {
    responseAware.invokeCasesCasegroupEndpoint(caseGroupId);
  }

//  /**
//   * Get casegroup id from DB case in case service
//   *
//   * @return casegroup id found in DB
//   * @throws Throwable pass the exception
//   */
//  private String getGroupIdFromCasegroup() throws Throwable {
//    List<Object> result = new ArrayList<Object>();
//
//    String sql = String.format(PostgresSteps.LIMIT_SQL, "id", "casesvc.casegroup", "1");
//    result = (ArrayList<Object>) postgresResponseAware.dbSelect(sql);
//
//    return result.get(0).toString();
//  }
}
