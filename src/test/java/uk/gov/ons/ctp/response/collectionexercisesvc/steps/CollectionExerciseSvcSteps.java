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
}
