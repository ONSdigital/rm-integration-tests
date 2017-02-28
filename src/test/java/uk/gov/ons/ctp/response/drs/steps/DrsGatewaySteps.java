package uk.gov.ons.ctp.response.drs.steps;

import cucumber.api.java.en.When;
import uk.gov.ons.ctp.response.drs.util.DrsGatewayResponseAware;

/**
 * Created by Stephen Goddard on 16/12/16.
 */
public class DrsGatewaySteps {
  private final DrsGatewayResponseAware responseAware;

  /**
   * Constructor
   *
   * @param drsResponseAware DRS Gateway end point runner
   */
  public DrsGatewaySteps(DrsGatewayResponseAware drsResponseAware) {
    this.responseAware = drsResponseAware;
  }

  /**
   * Test post request for / with outcome code and actionId
   *
   * @param outcome DRS out come code
   * @param actionId DRS primary order number or RM actionId
   * @throws Throwable pass the exception
   */
  @When("^I make the POST \"(.*?)\" call to the DRS Gateway for actionId \"(.*?)\"$")
  public void i_make_the_POST_call_to_the_DRS_Gateway_for_actionId(String outcome, String actionId)
      throws Throwable {
    responseAware.invokeDRSResponse(outcome, actionId);
  }

}
