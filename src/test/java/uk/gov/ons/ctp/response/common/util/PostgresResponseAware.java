package uk.gov.ons.ctp.response.common.util;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import org.apache.http.auth.AuthenticationException;
import org.apache.http.entity.ContentType;

import uk.gov.ons.ctp.util.HTTPResponseAware;
import uk.gov.ons.ctp.util.World;

/**
 * Created by Stephen Goddard on 22/08/17.
 */
public class PostgresResponseAware {
  private static final String POST_URL = "/sql";
  private static final String SERVICE = "dbtool";
  private World world;
  private HTTPResponseAware responseAware;

  /**
   * Constructor - also gets singleton of http request runner.
   *
   * @param newWorld class with application and environment properties
   */
  public PostgresResponseAware(final World newWorld) {
    this.world = newWorld;
    this.responseAware = HTTPResponseAware.getInstance();
  }

  /**
   * Run DB commands
   *
   * @param sql to be run
   * @throws AuthenticationException pass the exception
   * @throws IOException pass the exception
   */
  public void dbRunSql(String sql) throws AuthenticationException, IOException {
    responseAware.invokePost(world.getUrl(POST_URL, SERVICE), sql, ContentType.TEXT_PLAIN);
  }

  /**
   * Run DB query to get row count commands
   *
   * @param countSql to be run
   * @return long to indicate result of running sql
   * @throws AuthenticationException pass the exception
   * @throws IOException pass the exception
   */
  public long rowCount(String countSql) throws AuthenticationException, IOException {
    responseAware.invokePost(world.getUrl(POST_URL, SERVICE), countSql, ContentType.TEXT_PLAIN);
    String result = responseAware.getBody();
    String[] resultArr = result.split("\n");

    return Long.parseLong(resultArr[1]);
  }

  /**
   * Run DB commands where integer is expected as result
   *
   * @param updateSql to be run
   * @return integer to indicate result of running sql
   * @throws AuthenticationException pass the exception
   * @throws IOException pass the exception
   */
  public int dbRunSqlReturnInt(String updateSql) throws AuthenticationException, IOException {
    responseAware.invokePost(world.getUrl(POST_URL, SERVICE), updateSql, ContentType.TEXT_PLAIN);
    String result = responseAware.getBody();
    String[] resultArr = result.split("\n");

    return Integer.parseInt(resultArr[1]);
  }

  /**
   * Run DB commands where integer is expected as result
   *
   * @param sql to be run
   * @return List of strings result from db
   * @throws AuthenticationException pass the exception
   * @throws IOException pass the exception
   */
  public List<String> dbRunSqlReturnList(String sql) throws AuthenticationException, IOException {
    List<String> resultList = new ArrayList<String>();

    responseAware.invokePost(world.getUrl(POST_URL, SERVICE), sql, ContentType.TEXT_PLAIN);
    String result = responseAware.getBody();
    String[] resultArr = result.split("\n");

    for (int i = 1; i < resultArr.length; i++) {
      resultList.add(resultArr[i]);
    }

    return resultList;
  }
}
