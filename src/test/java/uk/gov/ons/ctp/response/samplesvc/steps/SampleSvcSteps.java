package uk.gov.ons.ctp.response.samplesvc.steps;

import java.util.Properties;

import cucumber.api.java.en.Given;
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

  /* End point steps */

  /**
   * Test post request for /samples/sampleunitrequests response
   *
   * @param surveyRef survey reference to get
   * @param collectionExerciseId collection exercise id
   * @param timeStamp start date time for sample
   *
   * @throws Throwable pass the exception
   */
  @Given("^I make the POST call to the sample service endpoint for surveyRef \"(.*?)\" and for \"(.*?)\""
      + " with a start of \"(.*?)\"$")
  public void i_make_the_POST_call_to_the_sample_service_endpoint_for_surveyRef_and_for_with_a_start_of(
      String surveyRef, String collectionExerciseId, String timeStamp) throws Throwable {
    Properties properties = new Properties();
    properties.put("surveyRef", surveyRef);
    properties.put("collectionExerciseId", collectionExerciseId);
    properties.put("exerciseDateTime", timeStamp);

    responseAware.invokePostEndpoint(properties);
  }
}
