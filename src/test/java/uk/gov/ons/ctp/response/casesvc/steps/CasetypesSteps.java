package uk.gov.ons.ctp.response.casesvc.steps;

import cucumber.api.java.en.When;
import uk.gov.ons.ctp.response.casesvc.util.CaseResponseAware;

/**
 * Created by Stephen Goddard on 8/3/16.
 */
public class CasetypesSteps {
  private final CaseResponseAware responseAware;

  /**
   * Constructor
   *
   * @param caseResponseAware case frame end point runner
   */
  public CasetypesSteps(CaseResponseAware caseResponseAware) {
    this.responseAware = caseResponseAware;
  }

  /**
   * Test get request for /casetypes/{casetype}
   *
   * @param casetype case type
   * @throws Throwable pass the exception
   */
  @When("^I make the GET call to the caseservice for casetypes by casetype \"(.*?)\"$")
  public void i_make_the_GET_call_to_the_caseservice_for_casetypes_by_casetype(String casetype) throws Throwable {
    responseAware.invokeCasetypesEndpoint(casetype);
  }
}
