package uk.gov.ons.ctp.response.common.steps;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertTrue;

import java.nio.charset.Charset;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.sql.Timestamp;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.List;
import java.util.TimeZone;

import cucumber.api.DataTable;
import cucumber.api.java.en.Given;
import cucumber.api.java.en.Then;
import cucumber.api.java.en.When;
import uk.gov.ons.ctp.response.common.util.PostgresResponseAware;
import uk.gov.ons.ctp.util.World;

/**
 * Created by Stephen Goddard on 25/5/16.
 */
public class PostgresSteps {
  /* Property keys */
  private static final String SQL_LOCATION = "cuc.sql.location";
  private static final long CASEREF_SEQ = 1000000000000001L;

  private World world;
  private final PostgresResponseAware responseAware;

  /* Sequence SQL */
  private static final String CURRVAL_SQL = "SELECT last_value FROM %s";

  /* Row count SQL */
  private static final String COUNT_SQL = "SELECT count(*) FROM %s";
  private static final String COUNT_WHERE = "SELECT count(*) FROM %s WHERE %s";
  private static final String DISTINCT_COUNT = "SELECT count(*) FROM (SELECT distinct %s FROM %s WHERE %s) AS TEMP";

  /* Select SQL */
  private static final String SELECT_WHERE = "SELECT %s FROM %s WHERE %s";
  private static final String UPDATE_WHERE = "UPDATE %s SET %s WHERE %s";

  /**
   * Constructor
   *
   * @param postgresResponseAware postgres runner
   * @param newWorld class with application and environment properties
   */
  public PostgresSteps(PostgresResponseAware postgresResponseAware, final World newWorld) {
    this.responseAware = postgresResponseAware;
    this.world = newWorld;
  }

  /**
   * Confirm clean of sample service postgres DB
   *
   * @throws Throwable pass the exception
   */
  @Given("^the samplesvc database has been reset$")
  public void the_samplesvc_database_has_been_reset() throws Throwable {
    checkRecordsInDBEqual("sample.samplesummary", 0);
    checkRecordsInDBEqual("sample.sampleunit", 0);
    checkRecordsInDBEqual("sample.collectionexercisejob", 0);

    checkSequenceInDBEqual("sample.samplesummaryseq", 1);
    checkSequenceInDBEqual("sample.sampleunitseq", 1);
    checkSequenceInDBEqual("sample.collectionexercisejobseq", 1);
  }

  /**
   * Confirm clean of collection exercise service postgres DB
   *
   * @throws Throwable pass the exception
   */
  @Given("^the collectionexercisesvc database has been reset$")
  public void the_collectionexercisesvc_database_has_been_reset() throws Throwable {
    checkRecordsInDBEqual("collectionexercise.sampleunit", 0);
    checkRecordsInDBEqual("collectionexercise.sampleunitgroup", 0);

    checkSequenceInDBEqual("collectionexercise.sampleunitgrouppkseq", 1);
    checkSequenceInDBEqual("collectionexercise.sampleunitpkseq", 1);

    check_records_in_DB_equal_for("collectionexercise.collectionexercise", 3, "statefk = 'INIT'");
  }

  /**
   * Confirm clean of case service postgres DB
   *
   * @throws Throwable pass the exception
   */
  @Then("^the casesvc database has been reset$")
  public void the_casesvc_database_has_been_reset() throws Throwable {
    checkRecordsInDBEqual("casesvc.case", 0);
    checkRecordsInDBEqual("casesvc.caseevent", 0);
    checkRecordsInDBEqual("casesvc.casegroup", 0);
    checkRecordsInDBEqual("casesvc.response", 0);

    checkSequenceInDBEqual("casesvc.caseeventseq", 1);
    checkSequenceInDBEqual("casesvc.casegroupseq", 1);
    checkSequenceInDBEqual("casesvc.caseseq", 1);
    checkSequenceInDBEqual("casesvc.caserefseq", CASEREF_SEQ);
    checkSequenceInDBEqual("casesvc.responseseq", 1);
  }

  /**
   * Confirm clean of action service postgres DB
   *
   * @throws Throwable pass the exception
   */
  @Then("^the actionsvc database has been reset$")
  public void the_actionsvc_database_has_been_reset() throws Throwable {
    checkRecordsInDBEqual("action.action", 0);
    checkRecordsInDBLessThanEqual("action.actionplanjob", 1);
    checkRecordsInDBEqual("action.case", 0);
    checkRecordsInDBEqual("action.messagelog", 0);

    checkSequenceInDBEqual("action.actionpkseq", 1);
    checkSequenceInDBEqual("action.actionplanjobseq", 1);
    checkSequenceInDBEqual("action.casepkseq", 1);
    checkSequenceInDBEqual("action.messageseq", 1);
  }

  /**
   * Confirm clean of action exporter postgres DB
   *
   * @throws Throwable pass the exception
   */
  @Then("^the actionexporter database has been reset$")
  public void the_actionexporter_database_has_been_reset() throws Throwable {
    checkRecordsInDBEqual("actionexporter.address", 0);
    checkRecordsInDBEqual("actionexporter.contact", 0);
    checkRecordsInDBEqual("actionexporter.filerowcount", 0);
    checkRecordsInDBEqual("actionexporter.report", 0);

    checkSequenceInDBEqual("actionexporter.actionrequestpkseq", 1);
    checkSequenceInDBEqual("actionexporter.contactpkseq", 1);
    checkSequenceInDBEqual("actionexporter.reportpkseq", 1);
  }

  /**
   * Confirm clean of notify gateway postgres DB
   *
   * @throws Throwable pass the exception
   */
  @Then("^the notifygatewaysvc database has been reset$")
  public void the_notifygatewaysvc_database_has_been_reset() throws Throwable {
    checkRecordsInDBEqual("notifygatewaysvc.message", 0);

    checkSequenceInDBEqual("notifygatewaysvc.messageseq", 1);
  }

  /**
   * Run .sql script
   *
   * @param service to run script against
   * @param scriptFile to be run
   * @throws Throwable pass the exception
   */
  @Given("^for the \"(.*?)\" run the \"(.*?)\" postgres DB script$")
  public void for_the_run_the_postgres_DB_script(String service, String scriptFile) throws Throwable {
    StringBuffer strbuffer = new StringBuffer();
    Path path = Paths.get(world.getProperty(SQL_LOCATION) + service + "/" + scriptFile);

    List<String> lines = Files.readAllLines(path, Charset.forName("UTF-8"));
    for (String line:lines) {
      strbuffer.append(line);
    }
    responseAware.dbRunSql(strbuffer.toString());
  }

  /**
   * Test number records in a db table
   *
   * @param table to be checked
   * @param total expected value to be tested
   * @throws Throwable pass the exception
   */
  private void checkRecordsInDBEqual(String table, long total) throws Throwable {
    long result = responseAware.rowCount(String.format(COUNT_SQL, table));
    assertTrue(table + " found in DB equal to: " + result, result == total);
  }

  /**
  * Test number records (less or equal) in a db table
  *
  * @param table to be checked
  * @param total expected value to be tested
  * @throws Throwable pass the exception
  */
  private void checkRecordsInDBLessThanEqual(String table, long total) throws Throwable {
    long result = responseAware.rowCount(String.format(COUNT_SQL, table));
    assertTrue(table + " found in DB equal to: " + result, result <= total);
  }

  /**
   * Test number records in a db table where matches search criteria
   *
   * @param table to be checked
   * @param total expected value to be tested
   * @param whereSearch sql search criteria
   * @throws Throwable pass the exception
   */
  @Then("^check \"(.*?)\" records in DB equal (\\d+) for \"(.*?)\"$")
  public void check_records_in_DB_equal_for(String table, int total, String whereSearch) throws Throwable {
    long result = responseAware.rowCount(String.format(COUNT_WHERE, table, whereSearch));
    assertTrue(table + " found " + whereSearch + " in DB equal to: " + result, result == total);
  }

  /**
   * Check number of records in DB action service
   *
   * @param table to be checked
   * @param data used to complete DB count
   * @throws Throwable pass the exception
   */
  @Then("^check \"(.*?)\" records in DB$")
  public void check_records_in_DB(String table, DataTable data) throws Throwable {
    List<String> testData = data.asList(String.class);

    String whereCriteria = String.format(
        "actionplanfk = %s and actionrulefk = %s and actiontypefk = %s and statefk = '%s'",
        testData.get(5), testData.get(6), testData.get(7), testData.get(8));
    System.out.println(String.format(COUNT_WHERE, table, whereCriteria));
    long result = responseAware.rowCount(String.format(COUNT_WHERE, table, whereCriteria));

    assertTrue("Found " + whereCriteria + " in DB equal to: " + result, result == Integer.parseInt(testData.get(9)));
  }

  /**
   * Check number of records in DB is equal to expected result
   *
   * @param table to be checked
   * @param total count to be asserted true
   * @throws Throwable pass the exception
   */
  @Then("^check \"(.*?)\" records in DB equal (\\d+)$")
  public void check_records_in_DB_equal(String table, int total) throws Throwable {
    long result = responseAware.rowCount(String.format(COUNT_SQL, table));
    assertTrue(table + " found count in DB equal to: " + result, result == total);
  }

  /**
   * Test sequence number is as expected
   *
   * @param sequence to be checked
   * @param total expected value to be tested
   * @throws Throwable pass the exception
   */
  public void checkSequenceInDBEqual(String sequence, long total) throws Throwable {
    long result = responseAware.rowCount(String.format(CURRVAL_SQL, sequence));
    assertTrue(sequence + " found in DB equal to: " + result + " Not = : " + total, result == total);
  }

  /**
   * Test number distinct records in a db table where matches search criteria
   *
   * @param table to be checked
   * @param total expected value to be tested
   * @param column to be checked
   * @param whereSearch sql search criteria
   * @throws Throwable pass the exception
   */
  @When("^check \"(.*?)\" distinct records in DB equal (\\d+) for \"(.*?)\" where \"(.*?)\"$")
  public void check_distinct_records_in_DB_equal_for_where(String table, int total, String column, String whereSearch)
      throws Throwable {
    long result = responseAware.rowCount(String.format(DISTINCT_COUNT, column, table, whereSearch));
    assertTrue(table + " distinct records found in DB equal to: : " + result, result == total);
  }

  /**
   * Test adjust survey date for printer action
   *
   * @param data to get action plan offset and update action.case with adjusted date
   * @throws Throwable pass the exception
   */
  @Given("^the case start date is adjusted to trigger action plan$")
  public void the_case_start_date_is_adjusted_to_trigger_action_plan(DataTable data) throws Throwable {
    List<String> adjustmentData = data.asList(String.class);
    System.out.println(adjustmentData);
    int adjustment = getActionPlanDaysOffset(adjustmentData.get(4), adjustmentData.get(5), adjustmentData.get(6));

    adjustment = -adjustment;
    String adjustedTime = adjustTimeFromNow(new Date(), Calendar.DATE, adjustment);

    // Adjust -1 as summer time saving is not processed in postgres.
    if (TimeZone.getTimeZone("Europe/London").inDaylightTime(new Date())) {
      System.out.println("BST Adjustment");
      DateFormat formatter = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss.SSS");
      Date bstDate = formatter.parse(adjustedTime);
      adjustedTime = adjustTimeFromNow(bstDate, Calendar.HOUR, -1);
    }

    System.out.println("Ajustment offset: " + adjustment + " Adjusted Time: " + adjustedTime);
    int result = adjustActionCaseSurveyStartDate(adjustedTime, adjustmentData.get(4));

    assertEquals(result, Integer.parseInt(adjustmentData.get(7)));
  }

  /**
   * Get the days offset for action plan rule
   *
   * @param actionPlanId action plan to get rule for
   * @param actionRuleId action plan rule
   * @param actionTypeId action type to get rule for
   * @return the offset in days
   * @throws Throwable pass the exception
   */
  private int getActionPlanDaysOffset(String actionPlanId, String actionRuleId, String actionTypeId) throws Throwable {
    String whereCriteria = String.format(
        "actionplanfk = %s and actionrulepk = %s and actiontypefk = %s", actionPlanId, actionRuleId, actionTypeId);
    String adjustmentSql = String.format(SELECT_WHERE, "daysoffset", "action.actionrule", whereCriteria);

    return responseAware.runSqlReturnInt(adjustmentSql);
  }

  /**
   * Run sql to adjust action.case actionplanstartdate
   *
   * @param adjustedTime adjusted date as a string
   * @param actionPlanId action plan id to be updated
   * @return result the number of rows updated
   * @throws Throwable pass the exception
   */
  private int adjustActionCaseSurveyStartDate(String adjustedTime, String actionPlanId) throws Throwable {
    String updateSql = String.format(UPDATE_WHERE, "action.case",
        "actionplanstartdate = '" + adjustedTime + "'", "actionplanfk = " + actionPlanId);
    int result = responseAware.runUpdateSql(updateSql);

    return result;
  }

  /**
   * Adjust time from now
   *
   * @param date against which to be adjusted
   * @param unit unit of time to be adjusted
   * @param adjustment the amount by which time is to be adjusted
   * @return adjusted time as string
   */
  private String adjustTimeFromNow(Date date, int unit, int adjustment) {
    Calendar cal = Calendar.getInstance();
    cal.setTime(date);
    cal.add(unit, adjustment);
    Timestamp time = new Timestamp(cal.getTime().getTime());

    return time.toString();
  }
}
