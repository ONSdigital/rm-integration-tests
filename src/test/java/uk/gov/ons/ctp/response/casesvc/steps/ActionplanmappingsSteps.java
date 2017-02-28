package uk.gov.ons.ctp.response.casesvc.steps;

import cucumber.api.java.en.When;
import uk.gov.ons.ctp.response.casesvc.util.CaseResponseAware;

/**
 * Created by stephen.goddard on 29/9/16.
 */
public class ActionplanmappingsSteps {
  private final CaseResponseAware responseAware;

  /**
   * Constructor
   *
   * @param caseResponseAware case frame end point runner
   */
  public ActionplanmappingsSteps(CaseResponseAware caseResponseAware) {
    this.responseAware = caseResponseAware;
  }

  /**
   * Test get request for /actionplanmappings/{mappingid}
   *
   * @param mappingId action plan mapping id
   * @throws Throwable pass the exception
   */
  @When("^I make the GET call to the caseservice actionplanmapping endpoint for mappingid \"(.*?)\"$")
  public void i_make_the_GET_call_to_the_caseservice_actionplanmapping_endpoint_for_mappingid(String mappingId)
      throws Throwable {
    responseAware.invokeActionPlanMappingIdEndpoint(mappingId);
  }

  /**
   * Test get request for /actionplanmappings/casetype/{casetypeid}
   *
   * @param casetypeId case type id
   * @throws Throwable pass the exception
   */
  @When("^I make the GET call to the caseservice actionplanmapping endpoint for casetypeid \"(.*?)\"$")
  public void i_make_the_GET_call_to_the_caseservice_actionplanmapping_endpoint_for_casetypeid(String casetypeId)
      throws Throwable {
    responseAware.invokeActionPlanMappingCaseTypeIdEndpoint(casetypeId);
  }

}
