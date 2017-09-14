package uk.gov.ons.ctp.response.sdx.steps;

import java.util.List;
import java.util.Properties;

import cucumber.api.java.en.Given;
import cucumber.api.java.en.When;
import uk.gov.ons.ctp.response.sdx.util.SdxGatewayResponseAware;

/**
 * Created by Stephen Goddard on 30/9/16.
 */
public class SdxGatewaySteps {
  private final SdxGatewayResponseAware responseAware;

  /**
   * Constructor
   *
   * @param sdxResponseAware SDX Gateway end point runner
   */
  public SdxGatewaySteps(SdxGatewayResponseAware sdxResponseAware) {
    this.responseAware = sdxResponseAware;
  }

  /**
   * Test get request for /info response
   *
   * @throws Throwable pass the exception
   */
  @Given("^I make the call to the SDX gateway endpoint for info$")
  public void i_make_the_call_to_the_SDX_gateway_endpoint_for_info() throws Throwable {
    responseAware.invokeInfoEndpoint();
  }

  /**
   * Test post request for /receipts with caseref
   *
   * @param caseType case type to receipt
   * @throws Throwable pass the exception
   */
  @Given("^I make the POST call to the SDX Gateway online receipt for \"(.*?)\" case with caseref$")
  public void i_make_the_POST_call_to_the_SDX_Gateway_online_receipt_for_case_with_caseref(String caseType)
      throws Throwable {
    List<String> result = responseAware.getCaseForType(caseType);
    Properties properties = new Properties();
    properties.put("caseId", result.get(0));
    properties.put("caseRef", result.get(1));
    responseAware.invokeSdxReceiptEndpoint(properties);
  }

  /**
   * Test post request for /receipts without caseref
   *
   * @param caseType case type to receipt
   * @throws Throwable pass the exception
   */
  @Given("^I make the POST call to the SDX Gateway online receipt for \"(.*?)\" case without caseref$")
  public void i_make_the_POST_call_to_the_SDX_Gateway_online_receipt_for_case_without_caseref(String caseType)
      throws Throwable {
    List<String> result = responseAware.getCaseForType(caseType);

    Properties properties = new Properties();
    properties.put("caseId", result.get(0));
    properties.put("caseRef", "");
    responseAware.invokeSdxReceiptEndpoint(properties);
  }

  /**
   * Test post request for /receipts - missing caseid
   *
   * @throws Throwable pass the exception
   */
  @When("^I make the POST call to the SDX Gateway online receipt for missing caseid$")
  public void i_make_the_POST_call_to_the_SDX_Gateway_online_receipt_for_missing_caseid() throws Throwable {
    Properties properties = new Properties();
    properties.put("caseRef", "");
    responseAware.invokeSdxReceiptEndpoint(properties);
  }
}
