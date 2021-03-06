package uk.gov.ons.ctp.response.surveysvc.util;

import java.io.IOException;

import org.apache.http.auth.AuthenticationException;

import uk.gov.ons.ctp.util.HTTPResponseAware;
import uk.gov.ons.ctp.util.World;

/**
 * Created by Stephen Goddard on 16/5/17.
 */
public class SurveySvcResponseAware {
  private static final String GET_SURVEYS_URL = "/surveys";
  private static final String GET_SURVEY_URL = "/surveys/%s";
  private static final String GET_NAME_URL = "/surveys/shortname/%s";
  private static final String GET_SURVEYREF_URL = "/surveys/ref/%s";
  private static final String GET_CLASSIFIERS_URL = "/surveys/%s/classifiertypeselectors";
  private static final String GET_CLASSIFIER_URL = "/surveys/%s/classifiertypeselectors/%s";
  private static final String GET_INFO_URL = "/info";
  private static final String USERNAME = "cuc.collect.username";
  private static final String PASSWORD = "cuc.collect.password";
  private static final String SERVICE = "surveysvc";
  private World world;
  private HTTPResponseAware responseAware;

  /**
   * Constructor - also gets singleton of http request runner.
   *
   * @param newWorld class with application and environment properties
   */
  public SurveySvcResponseAware(final World newWorld) {
    this.world = newWorld;
    this.responseAware = HTTPResponseAware.getInstance();
    responseAware.enableBasicAuth(world.getProperty(USERNAME), world.getProperty(PASSWORD));
  }

  /**
   * Test get request for /surveys response
   *
   * @throws IOException pass the exception
   * @throws AuthenticationException pass the exception
   */
  public void invokeGetSurveys() throws IOException, AuthenticationException {
    responseAware.invokeGet(world.getUrl(GET_SURVEYS_URL, SERVICE));
  }

  /**
   * Test get request for /surveys/{id} response
   *
   * @param id survey id
   * @throws IOException pass the exception
   * @throws AuthenticationException pass the exception
   */
  public void invokeGetSurvey(String id) throws IOException, AuthenticationException {
    final String url = String.format(GET_SURVEY_URL, id);
    responseAware.invokeGet(world.getUrl(url, SERVICE));
  }

  /**
   * Test get request for /surveys/name/{name} response
   *
   * @param name survey name
   * @throws IOException pass the exception
   * @throws AuthenticationException pass the exception
   */
  public void invokeGetSurveyName(String name) throws IOException, AuthenticationException {
    final String url = String.format(GET_NAME_URL, name);
    responseAware.invokeGet(world.getUrl(url, SERVICE));
  }

  /**
   * Test get request for /surveys/ref/{surveyref} response
   *
   * @param surveyref survey reference
   * @throws IOException pass the exception
   * @throws AuthenticationException pass the exception
   */
  public void invokeGetSurveyRef(String surveyref) throws IOException, AuthenticationException {
    final String url = String.format(GET_SURVEYREF_URL, surveyref);
    responseAware.invokeGet(world.getUrl(url, SERVICE));
  }

  /**
   * Test get request for /surveys/{id}/classifiertypeselectors response
   *
   * @param id survey id
   * @throws IOException pass the exception
   * @throws AuthenticationException pass the exception
   */
  public void invokeGetClassifiers(String id) throws IOException, AuthenticationException {
    final String url = String.format(GET_CLASSIFIERS_URL, id);
    responseAware.invokeGet(world.getUrl(url, SERVICE));
  }

  /**
   * Test get request for /surveys/{id}/classifiertypeselectors/{id} response
   *
   * @param sid survey ID
   * @param cid classifier ID
   * @throws IOException pass the exception
   * @throws AuthenticationException pass the exception
   */
  public void invokeGetClassifier(String sid, String cid) throws IOException, AuthenticationException {
    final String url = String.format(GET_CLASSIFIER_URL, sid, cid);
    responseAware.invokeGet(world.getUrl(url, SERVICE));
  }

  /**
   * Test get request for /info response
   *
   * @throws IOException pass the exception
   * @throws AuthenticationException pass the exception
   */
  public void invokeGetInfo() throws IOException, AuthenticationException {
    responseAware.invokeGet(world.getUrl(GET_INFO_URL, SERVICE));
  }
}
