package uk.gov.ons.ctp.response.casesvc.steps;

import cucumber.api.java.en.When;
import uk.gov.ons.ctp.response.casesvc.util.CaseFrameResponseAware;

/**
 * Created by philippe.brossier on 3/2/16.
 */
public class AddressesSteps {

  private final CaseFrameResponseAware responseAware;

  /**
   * Constructor
   *
   * @param caseFrameResponseAware case frame end point runner
   */
  public AddressesSteps(CaseFrameResponseAware caseFrameResponseAware) {
    this.responseAware = caseFrameResponseAware;
  }

  /**
   * Test get request for /addresses/{uprnCode}
   *
   * @param uprnCode UPRN code
   * @throws Throwable pass the exception
   */
  @When("^I make the GET call to the frameservice addresses endpoint for uprn \"([^\"]*)\"$")
  public void i_make_the_GET_call_to_the_frameservice_addresses_endpoint(String uprnCode) throws Throwable {
    responseAware.invokeAddressesEndpoint(uprnCode);
  }

  /**
   * Test get request for /addresses/postcode/{postcode}
   *
   * @param postcode for address
   * @throws Throwable pass the exception
   */
  @When("^I make the GET call to the frameservice addresses endpoint for postcode \"([^\"]*)\"$")
  public void i_make_the_GET_call_to_the_frameservice_addresses_postcode_endpoint(String postcode) throws Throwable {
    responseAware.invokeAddressesPostcodeEndpoint(postcode);
  }
}
