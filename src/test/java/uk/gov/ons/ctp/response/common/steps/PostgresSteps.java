package uk.gov.ons.ctp.response.common.steps;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertTrue;

import java.nio.charset.Charset;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;
import java.util.Calendar;
import java.util.Date;

import cucumber.api.DataTable;
import cucumber.api.java.en.Given;
import cucumber.api.java.en.Then;
import cucumber.api.java.en.When;
import uk.gov.ons.ctp.util.PostgresResponseAware;
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

  /* Truncate SQL */
  private static final String TRUNCATE_SQL = "truncate %s cascade;";

  /* Sequence SQL */
  private static final String SEQUENCE_SQL = "alter sequence %s restart with %s";
  private static final String CURRVAL_SQL = "select last_value from %s";

  /* Row count SQL */
  private static final String COUNT_SQL = "select count(*) from %s";
  private static final String COUNT_FIELD_SQL = "select * from %s where %s is not null";
  private static final String COUNT_WHERE = "select count(*) from %s where %s";
  private static final String COUNT_WHERE_SELECT = "select count(*) from %s where exists (select %s from %s where %s)";
  private static final String DISTINCT_COUNT = "select count(*) from (select distinct %s from %s where %s) as temp";

  /* Select SQL */
  private static final String SELECT_WHERE = "select %s from %s where %s";
  private static final String UPDATE_WHERE = "update %s set %s where %s";

  /* Delete SQL */
  private static final String DELETE_WHERE = "delete from %s where %s";

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
   * Reset the postgres DB to an initial state
   *
   * @throws Throwable pass the exception
   */
  @When("^reset the postgres DB$")
  public void reset_the_postgres_DB() throws Throwable {
//    responseAware.dbUpdateInsert(String.format(TRUNCATE_SQL, "casesvc.case"));
//    responseAware.dbUpdateInsert(String.format(TRUNCATE_SQL, "casesvc.caseevent"));
//    responseAware.dbUpdateInsert(String.format(TRUNCATE_SQL, "casesvc.casegroup"));
//    responseAware.dbUpdateInsert(String.format(TRUNCATE_SQL, "casesvc.contact"));
//    responseAware.dbUpdateInsert(String.format(TRUNCATE_SQL, "casesvc.response"));
//    responseAware.dbUpdateInsert(String.format(TRUNCATE_SQL, "casesvc.messagelog"));
//    responseAware.dbUpdateInsert(String.format(TRUNCATE_SQL, "casesvc.unlinkedcasereceipt"));
//    responseAware.dbUpdateInsert(String.format(TRUNCATE_SQL, "casesvc.report"));
    responseAware.dbUpdateInsert(String.format(TRUNCATE_SQL, "actionexporter.report"));
    responseAware.dbUpdateInsert(String.format(TRUNCATE_SQL, "action.action"));
    responseAware.dbUpdateInsert(String.format(TRUNCATE_SQL, "action.actionplanjob"));
    responseAware.dbUpdateInsert(String.format(TRUNCATE_SQL, "action.case"));
    responseAware.dbUpdateInsert(String.format(TRUNCATE_SQL, "action.messagelog"));

//    responseAware.dbUpdateInsert(String.format(SEQUENCE_SQL, "casesvc.caseeventidseq", "1"));
//    responseAware.dbUpdateInsert(String.format(SEQUENCE_SQL, "casesvc.caseidseq", "1"));
//    responseAware.dbUpdateInsert(String.format(SEQUENCE_SQL, "casesvc.casegroupidseq", "1"));
//    responseAware.dbUpdateInsert(String.format(SEQUENCE_SQL, "casesvc.caserefseq", "1000000000000001"));
//    responseAware.dbUpdateInsert(String.format(SEQUENCE_SQL, "casesvc.responseidseq", "1"));
//    responseAware.dbUpdateInsert(String.format(SEQUENCE_SQL, "casesvc.messageseq", "1"));
    responseAware.dbUpdateInsert(String.format(SEQUENCE_SQL, "action.actionidseq", "1"));
    responseAware.dbUpdateInsert(String.format(SEQUENCE_SQL, "action.actionplanjobseq", "1"));
    responseAware.dbUpdateInsert(String.format(SEQUENCE_SQL, "action.messageseq", "1"));
  }

  /**
   * Confirm clean of sample service postgres DB
   *
   * @throws Throwable pass the exception
   */
  @Given("^the samplesvc database has been reset$")
  public void the_samplesvc_database_has_been_reset() throws Throwable {
    check_records_in_DB_equal("sample.samplesummary", 0);
    check_records_in_DB_equal("sample.sampleunit", 0);
    check_records_in_DB_equal("sample.collectionexercisejob", 0);

    check_sequence_in_DB_equal("sample.samplesummaryseq", 1);
    check_sequence_in_DB_equal("sample.sampleunitidseq", 1);
    check_sequence_in_DB_equal("sample.collectionexercisejobidseq", 1);
  }

  /**
   * Confirm clean of collection exercise service postgres DB
   *
   * @throws Throwable pass the exception
   */
  @Given("^the collectionexercisesvc database has been reset$")
  public void the_collectionexercisesvc_database_has_been_reset() throws Throwable {
    check_records_in_DB_equal("collectionexercise.sampleunit", 0);
    check_records_in_DB_equal("collectionexercise.sampleunitgroup", 0);
    check_records_in_DB_equal("collectionexercise.collectionexercise", 0);
    check_records_in_DB_equal("collectionexercise.survey", 0);

    check_sequence_in_DB_equal("collectionexercise.exerciseidseq", 1);
    check_sequence_in_DB_equal("collectionexercise.sampleunitgroupidseq", 1);
  }

  /**
   * Confirm clean of case service postgres DB
   *
   * @throws Throwable pass the exception
   */
  @Then("^the casesvc database has been reset$")
  public void the_casesvc_database_has_been_reset() throws Throwable {
    check_records_in_DB_equal("casesvc.case", 0);
    check_records_in_DB_equal("casesvc.caseevent", 0);
    check_records_in_DB_equal("casesvc.casegroup", 0);
    check_records_in_DB_equal("casesvc.response", 0);

    check_sequence_in_DB_equal("casesvc.caseeventidseq", 1);
    check_sequence_in_DB_equal("casesvc.casegroupidseq", 1);
    check_sequence_in_DB_equal("casesvc.caseidseq", 1);
    check_sequence_in_DB_equal("casesvc.caserefseq", CASEREF_SEQ);
    check_sequence_in_DB_equal("casesvc.responseidseq", 1);
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
    responseAware.dbUpdateInsert(strbuffer.toString());
  }

  /**
   * Test number records in a db table
   *
   * @param table to be checked
   * @param total expected value to be tested
   * @throws Throwable pass the exception
   */
  @Then("^check \"(.*?)\" records in DB equal (\\d+)$")
  public void check_records_in_DB_equal(String table, long total) throws Throwable {
    long result = responseAware.rowCount(String.format(COUNT_SQL, table));
    assertTrue(table + " found in DB equal to: " + result, result == total);
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
   * Test sequence number is as expected
   *
   * @param sequence to be checked
   * @param total expected value to be tested
   * @throws Throwable pass the exception
   */
  @Then("^check \"(.*?)\" sequence in DB equal (\\d+)$")
  public void check_sequence_in_DB_equal(String sequence, long total) throws Throwable {
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
   * Test more than one entry for column exist
   *
   * @param column column to inspect
   * @throws Throwable pass the exception
   */
  @Given("^the fields exists in DB \"(.*?)\"$")
  public void the_fields_exists_in_DB(String column) throws Throwable {
    long result = responseAware.rowCount(String.format(COUNT_FIELD_SQL, "casesvc.questionnaire", column));
    assertTrue("Field not found in DB: " + column, result > 0);
  }

  /**
   * Test the number of case events for a specified sample
   *
   * @param total expected value to be tested
   * @param value column value to select on
   * @throws Throwable pass the exception
   */
  @Then("^casesvc events exist in DB equal (\\d+) for sample (\\d+)$")
  public void casesvc_events_exist_in_DB_equal_for_sample(int total, int value) throws Throwable {
    long result = responseAware.rowCount(String.format(COUNT_WHERE_SELECT,
        "casesvc.caseevent", "caseid", "casesvc.case", "sampleid = " + value));
    assertTrue("Casesvc case event for sample found in DB not equal to: : " + total, result == total);
  }

  /**
   * Remove case events linked to the case provided.
   *
   * @param caseId case id to delete related events
   * @throws Throwable pass the exception
   */
  @Given("^Case events have been removed for case \"(.*?)\"$")
  public void case_events_have_been_removed_for_case(String caseId) throws Throwable {
    responseAware.dbUpdateInsert(String.format(DELETE_WHERE, "casesvc.caseevent", "caseid = " + caseId));
  }

  /**
   * Run update sql with a where clause.
   *
   * @param from table to update
   * @param set values to update
   * @param where clause to us in update
   * @throws Throwable pass the exception
   */
  @Given("^Update \"(.*?)\" to \"(.*?)\" where \"(.*?)\"$")
  public void update_to_where(String from, String set, String where) throws Throwable {
    System.out.println(String.format(UPDATE_WHERE, from, set, where));
    responseAware.dbUpdateInsert(String.format(UPDATE_WHERE, from, set, where));
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

    int adjustment = getActionPlanDaysOffset(adjustmentData.get(3), adjustmentData.get(4));
    adjustment = -adjustment;
    String adjustedTime = adjustTimeFromNow(Calendar.DATE, adjustment);
    System.out.println("Ajustment offset: " + adjustment + " Adjusted Time: " + adjustedTime);
    int result = adjustActionCaseSurveyStartDate(adjustedTime, adjustmentData.get(3));

    assertEquals(result, Integer.parseInt(adjustmentData.get(5)));
  }

  /**
   * Get the days offset for action plan rule
   *
   * @param actionPlanId action plan to get rule for
   * @param actionTypeId action type to get rule for
   * @return the offset in days
   * @throws Throwable pass the exception
   */
  private int getActionPlanDaysOffset(String actionPlanId, String actionTypeId) throws Throwable {
    List<Object> daysOffset = new ArrayList<Object>();
    int offset = 0;

    String whereCriteria = String.format("actionplanid = %s and actiontypeid = %s", actionPlanId, actionTypeId);
    String adjustmentSql = String.format(SELECT_WHERE, "surveydatedaysoffset", "action.actionrule", whereCriteria);
    daysOffset = (ArrayList<Object>) responseAware.dbSelect(adjustmentSql);
    offset = (Integer) daysOffset.get(0);

    return offset;
  }

  /**
   * Adjust the survey start time
   *
   * @param adjustment days by which the survey should be adjusted by
   * @param survey to adjust
   * @throws Throwable pass the exception
   */
  @When("^the survey start and is reset to (\\d+) days ahead for \"(.*?)\"$")
  public void the_survey_start_and_is_reset_to_days_ahead_for(int adjustment, String survey) throws Throwable {
    String adjustedTime = adjustTimeFromNow(Calendar.DATE, adjustment);
    String updateSql = String.format(UPDATE_WHERE, "action.survey", "surveystartdate = '" + adjustedTime + "'",
        "name = '" + survey + "'");
    System.out.println("Adjustment survey start date sql: " + updateSql);
    int result = responseAware.dbUpdateInsert(updateSql);

    assertEquals(result, 1);
  }

  /**
   * Adjust the survey end time
   *
   * @param adjustment days by which the survey should be adjusted by
   * @param survey to adjust
   * @throws Throwable pass the exception
   */
  @Then("^the survey end and is reset to (\\d+) days ahead for \"(.*?)\"$")
  public void the_survey_end_and_is_reset_to_days_ahead_for(int adjustment, String survey) throws Throwable {
    String adjustedTime = adjustTimeFromNow(Calendar.DATE, adjustment);
    String updateSql = String.format(UPDATE_WHERE, "action.survey", "surveyenddate = '" + adjustedTime + "'",
      "name = '" + survey + "'");
    System.out.println("Adjustment survey end date sql: " + updateSql);
    int result = responseAware.dbUpdateInsert(updateSql);

    assertEquals(result, 1);
  }

  /**
   * Call function to populate reports table
   *
   * @param function to be called
   * @throws Throwable pass the exception
   */
  @Then("^call the \"(.*?)\" function$")
  public void call_the_function(String function) throws Throwable {
    responseAware.dbSelect(String.format("select %s", function));
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
        "actionplanstartdate = '" + adjustedTime + "'", "actionplanid = " + actionPlanId);
    int result = responseAware.dbUpdateInsert(updateSql);

    return result;
  }

  /**
   * Adjust time from now
   *
   * @param unit unit of time to be adjusted
   * @param adjustment the amount by which time is to be adjusted
   * @return adjusted time as string
   */
  private String adjustTimeFromNow(int unit, int adjustment) {
    Calendar cal = Calendar.getInstance();
    cal.setTime(new Date());
    cal.add(unit, adjustment);
    Timestamp time = new Timestamp(cal.getTime().getTime());

    return time.toString();
  }
}
