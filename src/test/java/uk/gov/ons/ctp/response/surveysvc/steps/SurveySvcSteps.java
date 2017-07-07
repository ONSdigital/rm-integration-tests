package uk.gov.ons.ctp.response.surveysvc.steps;

import cucumber.api.java.en.Given;
import uk.gov.ons.ctp.response.surveysvc.util.SurveySvcResponseAware;

/**
 * Created by Stephen Goddard on 16/5/17.
 */
public class SurveySvcSteps {
  private final SurveySvcResponseAware responseAware;

  /**
   * Constructor
   *
   * @param surveySvcResponseAware end point runner
   */
  public SurveySvcSteps(SurveySvcResponseAware surveySvcResponseAware) {
    this.responseAware = surveySvcResponseAware;
  }

  /* End point steps */

  /**
   * Test get request for /surveys response
   *
   * @throws Throwable pass the exception
   */
  @Given("^I make the GET call to the survey service endpoint for surveys$")
  public void i_make_the_GET_call_to_the_survey_service_endpoint_for_surveys() throws Throwable {
    responseAware.invokeGetSurveys();
  }

  /**
   * Test get request for /surveys/{id} response
   *
   * @param id survey id
   *
   * @throws Throwable pass the exception
   */
  @Given("^I make the GET call to the survey service endpoint for survey by id \"(.*?)\"$")
  public void i_make_the_GET_call_to_the_survey_service_endpoint_for_survey_by_id(String id) throws Throwable {
    responseAware.invokeGetSurvey(id);
  }

  /**
   * Test get request for /surveys/name/{name} response
   *
   * @param name survey name
   *
   * @throws Throwable pass the exception
   */
  @Given("^I make the GET call to the survey service endpoint for name \"(.*?)\"$")
  public void i_make_the_GET_call_to_the_survey_service_endpoint_for_name(String name) throws Throwable {
    responseAware.invokeGetSurveyName(name);
  }

  /**
   * Test get request for /surveys/ref/{surveyref} response
   *
   * @param surveyref survey reference
   *
   * @throws Throwable pass the exception
   */
  @Given("^I make the GET call to the survey service endpoint for survey ref \"(.*?)\"$")
  public void i_make_the_GET_call_to_the_survey_service_endpoint_for_survey_ref(String surveyref) throws Throwable {
    responseAware.invokeGetSurveyRef(surveyref);
  }

  /**
   * Test get request for /surveys/{id}/classifiertypeselectors response
   *
   * @param id survey id
   *
   * @throws Throwable pass the exception
   */
  @Given("^I make the GET call to the survey service endpoint for classifiers by id \"(.*?)\"$")
  public void i_make_the_GET_call_to_the_survey_service_endpoint_for_classifiers_by_id(String id) throws Throwable {
    responseAware.invokeGetClassifiers(id);
  }

  /**
   * Test get request for /surveys/{id}/classifiertypeselectors/{id} response
   *
   * @param sid survey id
   * @param cid classifier id
   *
   * @throws Throwable pass the exception
   */
  @Given("^I make the GET call to the survey service endpoint for classifier by id \"(.*?)\" and \"(.*?)\"$")
  public void i_make_the_GET_call_to_the_survey_service_endpoint_for_classifier_by_id_and(String sid, String cid)
      throws Throwable {
    responseAware.invokeGetClassifier(sid, cid);
  }
}
