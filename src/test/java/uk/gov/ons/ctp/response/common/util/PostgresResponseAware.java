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
  private static final String POST_UPDATE_URL = "/sql/update";
  private static final String SERVICE = "dbtool";
  private static final String LIMIT_SQL = "SELECT %s FROM %s LIMIT %s;";
  private static final String WHERE_SQL = "SELECT %s FROM %s WHERE samplesummarypk = %s;";
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
   * Run Update DB commands returning the number of records affected
   *
   * @param updateSql to be run
   * @return Number of records updated
   * @throws AuthenticationException pass the exception
   * @throws IOException pass the exception
   */
  public int runUpdateSql(String updateSql) throws AuthenticationException, IOException {
    responseAware.invokePost(world.getUrl(POST_UPDATE_URL, SERVICE), updateSql, ContentType.TEXT_PLAIN);
    String result = responseAware.getBody();
    return Integer.parseInt(result);
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
    List<String> resultList = dbRunSqlReturnList(countSql);
    return Long.parseLong(resultList.get(0));
  }

  /**
   * Run DB commands where integer is expected as result
   *
   * @param sql to be run
   * @return integer to indicate result of running sql
   * @throws AuthenticationException pass the exception
   * @throws IOException pass the exception
   */
  public int runSqlReturnInt(String sql) throws AuthenticationException, IOException {
    List<String> resultList = dbRunSqlReturnList(sql);
    return Integer.parseInt(resultList.get(0));
  }

  /**
   * Get single field from database
   *
   * @param field name to extract value of
   * @param table name
   * @return String field value
   * @throws IOException pass the exception
   * @throws AuthenticationException pass the exception
   */
  public String getFieldFromRecord(String field, String table) throws IOException, AuthenticationException {
    String sql = String.format(LIMIT_SQL, field, table, "1");
    List<String> resultList = dbRunSqlReturnList(sql);
    return resultList.get(0);
  }
  
  /**
   * Get single field from database
   *
   * @param field name to extract value of
   * @param table name
   * @return String field value
   * @throws IOException pass the exception
   * @throws AuthenticationException pass the exception
   */
  public String getSignalFieldFromRecord(String field, String table, String match) throws IOException, AuthenticationException {
    String sql = String.format(WHERE_SQL, field, table, match);
    List<String> resultList = dbRunSqlReturnList(sql);
    return resultList.get(0);
  }

  /**
   * Get record from database
   *
   * @param sql to be run
   * @return List of fields from record
   * @throws IOException pass the exception
   * @throws AuthenticationException pass the exception
   */
  public List<String> getRecord(String sql) throws IOException, AuthenticationException {
    List<String> recordList = new ArrayList<String>();

    List<String> resultList = dbRunSqlReturnList(sql);
    String[] fieldArr = resultList.get(0).split(",");

    for (String field: fieldArr) {
      recordList.add(field);
    }
    return recordList;
  }

  /**
   * Run DB commands where integer is expected as result
   *
   * @param sql to be run
   * @return List of strings result from db
   * @throws AuthenticationException pass the exception
   * @throws IOException pass the exception
   */
  private List<String> dbRunSqlReturnList(String sql) throws AuthenticationException, IOException {
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
