package uk.gov.ons.ctp.response.casesvc.steps;

import java.util.Properties;

import cucumber.api.java.en.When;
import uk.gov.ons.ctp.response.casesvc.util.CaseResponseAware;

/**
 * Created by Stephen Goddard on 9/3/16.
 */
public class SamplesSteps {
  private final CaseResponseAware responseAware;

  /**
   * Constructor
   *
   * @param caseResponseAware case frame end point runner
   */
  public SamplesSteps(CaseResponseAware caseResponseAware) {
    this.responseAware = caseResponseAware;
  }

  /**
   * Test get request for /samples/{sampleId}
   *
   * @param sampleId sample id
   * @throws Throwable pass the exception
   */
  @When("^I make the GET call to the caseservice for samples for sample id \"(.*?)\"$")
  public void i_make_the_GET_call_to_the_caseservice_for_samples_for_sample_id(String sampleId) throws Throwable {
    responseAware.invokeSamplesEndpoint(sampleId);
  }

  /**
   * Test put request for /samples/{sampleId}
   *
   * @param sampleId sample id
   * @param geoType for JSON payload
   * @param geoCode for JSON payload
   * @throws Throwable pass the exception
   */
  @When("^I make the PUT call to the caseservice sample endpoint for sample id "
      + "\"(.*?)\" for area \"(.*?)\" code \"(.*?)\"$")
  public void i_make_the_PUT_call_to_the_caseservice_sample_endpoint_for_sample_id_for_area_code(String sampleId,
      String geoType, String geoCode) throws Throwable {
    Properties properties = new Properties();
    properties.setProperty("type", geoType);
    properties.setProperty("code", geoCode);

    responseAware.invokeSamplesSamplesidEndpoint(sampleId, properties);
  }
}
