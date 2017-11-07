package uk.gov.ons.ctp.response.samplesvc.steps;

//import java.util.Properties;

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
  @Given("^I make the POST call to the sample service endpoint for surveyRef \"(.*?)\" and for \"(.*?)\" with a start of \"(.*?)\" for ref \"(.*?)\"$")
  public void i_make_the_POST_call_to_the_sample_service_endpoint_for_surveyRef_and_for_with_a_start_of_for_ref(
      String surveyRef, String collectionExerciseId, String timeStamp, String summaryKey) throws Throwable {
    StringBuffer jsonText = new StringBuffer();
    jsonText.append("{");
    jsonText.append("\"surveyRef\":\"" + surveyRef + "\",");
    jsonText.append("\"collectionExerciseId\":\"" + collectionExerciseId + "\",");
    jsonText.append("\"exerciseDateTime\":\"" + timeStamp + "\",");

    responseAware.invokePostEndpoint(jsonText, summaryKey);
  }

  
  /**
   * Test post request for /info
   * @throws Throwable pass the exception
   */
  @Given("^I make the call to the sample service endpoint for info")
  public void i_make_the_call_to_the_sample_service_endpoint_for_info() throws Throwable {
    responseAware.invokeInfoEndpoint();
  }
  
  
  /**
   * Move file to trigger sample service to process file
   *
   * @param surveyType survey area to run
   * @param fileType currently either valid or invalid
   * @throws Throwable pass the exception
   */
  @When("^I make the POST call to the sample \"(.*?)\" service endpoint for the \"(.*?)\" survey \"(.*?)\" file to trigger ingestion$")
  public void i_make_the_POST_call_to_the_sample_service_endpoint_for_the_survey_file_to_trigger_ingestion(String surveyName, String surveyType, String fileType) throws Throwable {
    responseAware.invokeSurveyFileEndpoint(surveyName, surveyType, fileType);
  }
}
