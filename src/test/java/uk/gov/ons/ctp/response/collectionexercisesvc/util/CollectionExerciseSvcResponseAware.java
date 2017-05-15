package uk.gov.ons.ctp.response.collectionexercisesvc.util;

import java.io.IOException;

import org.apache.http.auth.AuthenticationException;
import org.apache.http.entity.ContentType;

import uk.gov.ons.ctp.util.HTTPResponseAware;
import uk.gov.ons.ctp.util.World;

/**
 * Created by Stephen Goddard on 12/5/17.
 */
public class CollectionExerciseSvcResponseAware {
  private static final String PUT_URL = "/collectionexercises/%s";
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
  }

  /**
   * Collection Exercise Service - /collectionexercises/{exerciseId} put endoints.
   *
   * @param exerciseId exercise id
   * @throws IOException IO exception
   * @throws AuthenticationException authentication exception
   */
  public void invokePutCollectionExerciseId(String exerciseId) throws AuthenticationException, IOException {
    final String url = String.format(world.getCollectionExerciseSvcUrl(PUT_URL), exerciseId);
    responseAware.invokePut(url, "", ContentType.APPLICATION_JSON);
  }
}
