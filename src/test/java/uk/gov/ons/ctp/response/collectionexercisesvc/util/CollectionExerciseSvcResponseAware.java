package uk.gov.ons.ctp.response.collectionexercisesvc.util;

import java.io.IOException;
import java.util.List;
import java.util.Properties;
import java.util.UUID;

import org.apache.http.auth.AuthenticationException;
import org.apache.http.entity.ContentType;

import uk.gov.ons.ctp.util.HTTPResponseAware;
import uk.gov.ons.ctp.util.World;

/**
 * Created by Stephen Goddard on 12/5/17.
 */
public class CollectionExerciseSvcResponseAware {
  private static final String PUT_EXERCISE_URL = "/collectionexercises/%s";
  private static final String GET_SURVEY_URL = "/collectionexercises/survey/%s";
  private static final String GET_EXERCISE_URL = "/collectionexercises/%s";
  private static final String PUT_SAMPLE_URL = "/collectionexercises/link/%s";
  private static final String INFO_URL = "/info";
  private static final String USERNAME = "cuc.collect.username";
  private static final String PASSWORD = "cuc.collect.password";
  private static final String SERVICE = "collectionexercisesvc";
  private World world;
  private HTTPResponseAware responseAware;
  
  /**
   * Constructor - also gets singleton of http request runner.
   *
   * @param newWorld class with application and environment properties
   */
  public CollectionExerciseSvcResponseAware(final World newWorld) {
    this.world = newWorld;
    this.responseAware = HTTPResponseAware.getInstance();
    
    responseAware.enableBasicAuth(world.getProperty(USERNAME), world.getProperty(PASSWORD));
  }

  /**
   *
   *
   * @param samplesummaryId samplesummary Id
   * @throws IOException IO exception
   * @throws AuthenticationException authentication exception
   */
  public void invokePutCollectionExerciseSampleSummary(List<UUID> sampleSummaryId, String exerciseId) throws AuthenticationException, IOException {
    final String url = String.format(world.getUrl(PUT_SAMPLE_URL, SERVICE), exerciseId);
    UUID id = sampleSummaryId.get(0);
    //Properties properties = new Properties();
    //properties.setProperty(key, value)
    responseAware.invokeBasicPut(url, id.toString());
  }
  
  
  /**
   * Collection Exercise Service - /collectionexercises/{exerciseId} put endpoints.
   *
   * @param exerciseId exercise id
   * @throws IOException IO exception
   * @throws AuthenticationException authentication exception
   */
  public void invokePutCollectionExerciseId(String exerciseId) throws AuthenticationException, IOException {
    final String url = String.format(world.getUrl(PUT_EXERCISE_URL, SERVICE), exerciseId);
    responseAware.invokePut(url, "", ContentType.APPLICATION_JSON);
  }

  /**
   * Collection Exercise Service - /collectionexercises/survey/{surveyid} get endpoints.
   *
   * @param surveyId survey id
   * @throws IOException IO exception
   * @throws AuthenticationException authentication exception
   */
  public void invokeGetSurveyId(String surveyId) throws AuthenticationException, IOException {
    System.out.println("Get survey");
    final String url = String.format(world.getUrl(GET_SURVEY_URL, SERVICE), surveyId);
    responseAware.invokeGet(url);
  }

  /**
   * Collection Exercise Service - /collectionexercises/{exerciseId} get endpoints.
   *
   * @param exerciseId exercise id
   * @throws IOException IO exception
   * @throws AuthenticationException authentication exception
   */
  public void invokeGetCollectionExerciseId(String exerciseId) throws AuthenticationException, IOException {
    System.out.println("Get exercise");
    final String url = String.format(world.getUrl(GET_EXERCISE_URL, SERVICE), exerciseId);
    responseAware.invokeGet(url);
  }

  /**
   * Test post request for /info response
   *
   * @throws IOException pass the exception
   * @throws AuthenticationException pass the exception
   */
  public void invokeInfoEndpoint() throws IOException, AuthenticationException {
    responseAware.invokeGet(world.getUrl(INFO_URL, SERVICE));
  }
}
