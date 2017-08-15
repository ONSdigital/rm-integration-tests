package uk.gov.ons.ctp.response.collectionexercisesvc.steps;

import cucumber.api.java.en.Given;
import uk.gov.ons.ctp.response.collectionexercisesvc.util.CollectionExerciseSvcResponseAware;

/**
 * Created by Stephen Goddard on 12/5/17.
 */
public class CollectionExerciseSvcSteps {
  private final CollectionExerciseSvcResponseAware responseAware;

  /**
   * Constructor
   *
   * @param collectionExerciseSvcResponseAware end point runner
   */
  public CollectionExerciseSvcSteps(CollectionExerciseSvcResponseAware collectionExerciseSvcResponseAware) {
    this.responseAware = collectionExerciseSvcResponseAware;
  }

  /* End point steps */

  /**
   * Test put request for /collectionexercises/{exerciseId}.
   *
   * @param exerciseId exercise id
   * @throws Throwable pass the exception
   */
  @Given("^I make the PUT call to the collection exercise endpoint for exercise id \"(.*?)\"$")
  public void i_make_the_PUT_call_to_the_collection_exercise_endpoint_for_exercise_id(String exerciseId)
      throws Throwable {
    responseAware.invokePutCollectionExerciseId(exerciseId);
  }

  /**
   * Test get request for /collectionexercises/survey/{surveyid}.
   *
   * @param surveyId survey id
   * @throws Throwable pass the exception
   */
  @Given("^I make the GET call to the collection exercise endpoint for survey by survey id \"(.*?)\"$")
  public void i_make_the_GET_call_to_the_collection_exercise_endpoint_for_survey_by_survey_id(String surveyId)
      throws Throwable {
    responseAware.invokeGetSurveyId(surveyId);
  }

  /**
   * Test get request for /collectionexercises/{exerciseId}.
   *
   * @param exerciseId exercise id
   * @throws Throwable pass the exception
   */
  @Given("^I make the GET call to the collection exercise endpoint for exercise by exercise id \"(.*?)\"$")
  public void i_make_the_GET_call_to_the_collection_exercise_endpoint_for_exercise_by_exercise_id(String exerciseId)
      throws Throwable {
    responseAware.invokeGetCollectionExerciseId(exerciseId);
  }

  /**
   * Test post request for /info
   * @throws Throwable pass the exception
   */
  @Given("^I make the call to the collection exercise endpoint for info")
  public void i_make_the_call_to_the_sample_service_endpoint_for_info() throws Throwable {
    responseAware.invokeInfoEndpoint();
  }

}
