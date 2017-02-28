package uk.gov.ons.ctp.response.casesvc.steps;

import cucumber.api.java.en.When;
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
   * Test get request for /casegroup/uprn/{uprn}
   *
   * @param uprn for case group
   * @throws Throwable pass the exception
   */
  @When("^I make the GET call to the caseservice casegroup endpoint for uprn \"(.*?)\"$")
  public void i_make_the_GET_call_to_the_caseservice_casegroup_endpoint_for_uprn(String uprn) throws Throwable {
    responseAware.invokeCaseGroupUprnEndpoint(uprn);
  }

  /**
   * Test get request for /cases/casegroup/{casegroupid}
   *
   * @param caseGroupId case group id
   * @throws Throwable pass the exception
   */
  @When("^I make the GET call to the caseservice casegroup endpoint for casegroupid \"(.*?)\"$")
  public void i_make_the_GET_call_to_the_caseservice_casegroup_endpoint_for_casegroupid(String caseGroupId)
      throws Throwable {
    responseAware.invokeCaseGroupIdEndpoint(caseGroupId);
  }
}
