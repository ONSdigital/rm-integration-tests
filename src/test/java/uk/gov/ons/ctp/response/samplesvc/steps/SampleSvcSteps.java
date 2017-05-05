package uk.gov.ons.ctp.response.samplesvc.steps;

import java.util.Properties;

import cucumber.api.java.en.Given;
import cucumber.api.java.en.When;
import uk.gov.ons.ctp.response.samplesvc.util.SampleSvcResponseAware;

/**
 * Created by Stephen Goddard on 11/4/17.
 */
public class SampleSvcSteps {
  private final SampleSvcResponseAware responseAware;

  /**
   * Constructor
   *
   * @param sampleSvcResponseAware end point runner
   */
  public SampleSvcSteps(SampleSvcResponseAware sampleSvcResponseAware) {
    this.responseAware = sampleSvcResponseAware;
  }

  @Given("^I make the POST call to the sample service endpoint for surveyRef \"(.*?)\" and for \"(.*?)\" with a start of \"(.*?)\"$")
  public void i_make_the_POST_call_to_the_sample_service_endpoint_for_surveyRef_and_for_with_a_start_of
      (String surveyRef, String collectionExerciseId, String timeStamp) throws Throwable {
    Properties properties = new Properties();
    properties.put("surveyRef", surveyRef);
    properties.put("collectionExerciseId", collectionExerciseId);
    properties.put("exerciseDateTime", timeStamp);

    responseAware.invokePostEndpoint(properties);
  }

//  /**
//   * Test get request for /samples/{surveyRef}/{startTimestamp} response
//   *
//   * @param surveyRef survey reference to get
//   * @param timeStamp start date time for sample
//   *
//   * @throws Throwable pass the exception
//   */
//  @Given("^I make the POST call to the sample service endpoint for surveyRef \"(.*?)\" with a start of \"(.*?)\"$")
//  public void i_make_the_POST_call_to_the_sample_service_endpoint_for_surveyRef_with_a_start_of(
//      String surveyRef, String timeStamp) throws Throwable {
//    responseAware.invokeGetSampleSvcEndpoint(surveyRef, timeStamp);
//  }

//  /**
//   * Test put request for /samples/{sampleId} response
//   *
//   * @param sampleId to update
//   *
//   * @throws Throwable pass the exception
//   */
//  @When("^I make the PUT call to the sample service endpoint for sample id \"(.*?)\"$")
//  public void i_make_the_PUT_call_to_the_sample_service_endpoint_for_sample_id(String sampleId) throws Throwable {
//    responseAware.invokePutSampleSvcEndpoint(sampleId);
//  }
}
