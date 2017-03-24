package uk.gov.ons.ctp.ui.steps;

import uk.gov.ons.ctp.ui.util.ResponseOperationUIResponseAware;

/**
 * Created by Stephen Goddard on 23/03/17.
 */
public class ReportsUISteps {
  private final ResponseOperationUIResponseAware responseAware;
//private static final List<String> REPORT_TYPES = new ArrayList<>(Arrays.asList("HH Returnrate", "HH Noreturns",
//"HH Returnrate Sample", "HH Returnrate LA", "CE Returnrate Uni", "CE ReturnRate SHousing", "CE Returnrate Hotel",
//"HL Metrics", "HH Outstanding Cases", "SH Outstanding Cases", "CE Outstanding Cases", "Print Volumes"));


  /**
   * Constructor
   *
   * @param uiResponseAware ui runner
   */
  public ReportsUISteps(ResponseOperationUIResponseAware uiResponseAware) {
    this.responseAware = uiResponseAware;
  }

  /**
   * Navigate to the given page
   *
   * @param page to be navigated to
   * @throws Throwable pass the exception
   */
//  @When("^navigates to the \"(.*?)\" page")
//  public void navigates_to_the_page(String page) throws Throwable {
//    responseAware.invokeUIReportsPage(page);
//  }

  /**
   * The table contains the elements
   *
   * @param firstElement the first element to check for in the table
   * @param secondElement the second element to check for in the table
   * @param columnOne the first column to check for in the table
   * @param columnTwo the second column to check for in the table
   * @throws Throwable pass the exception
   */
//  @When("^the first row of the table should contain the values \"(.*?)\" and \"(.*?)\" in columns (\\d+) and (\\d+)$")
//  public void the_first_row_of_the_table_should_contain_the_values_and(
//      String firstElement, String secondElement, int columnOne, int  columnTwo) throws Throwable {
//    assertEquals(responseAware.invokeCheckReportContents(columnOne), firstElement);
//    assertEquals(responseAware.invokeCheckReportContents(columnTwo), secondElement);
//  }

  /**
   * The table headings contain the text
   *
   * @param firstHeading the first heading in the table
   * @param secondHeading the second heading in the table
   * @throws Throwable pass the exception
   */
//  @When("^the table should contain the headings \"(.*?)\" and \"(.*?)\"")
//  public void the_table_should_contain_the_headings_and(String firstHeading, String secondHeading) throws Throwable {
//    assertTrue(responseAware.invokeCheckReportHeadings(firstHeading, secondHeading));
//  }

  /**
   * Check that an error message is displayed
   *
   * @throws Throwable pass the exception
   */
//  @When("^an error message appears on screen")
//  public void an_error_message_appears_on_screen() throws Throwable {
//    assertFalse(responseAware.invokeUIReportsCheckError("information"));
//  }

  /**
   * Check that an error message is not displayed
   *
   * @throws Throwable pass the exception
   */
//  @When("^there is no error message")
//  public void there_is_no_error_message() throws Throwable {
//    assertTrue(responseAware.invokeUIReportsCheckError("information"));
//  }

  /**
   * Check that the error message is correct
   *
   * @param expectedError the error message expected
   * @throws Throwable pass the exception
   */
//  @When("^the error message is \"(.*?)\"$")
//  public void the_error_message_is(String expectedError) throws Throwable {
//    assertTrue(responseAware.invokeReportErrorCheck(expectedError));
//  }


  /**
   * Check that a specific error string appears on the page
   *
   * @param error string expected on page
   * @return true if an error message is displayed on the page
   */
//  public boolean invokeUIReportsCheckError(String error) {
//    return getWebDriver().findElements(By.id(error)).isEmpty();
//  }

  /**
   * Check that report for specified date exists
   *
   * @throws Throwable pass the exception
   */
//  @When("^the report for todays date should be present$")
//  public void the_report_for_todays_date_should_be_present() throws Throwable {
//    String date = responseAware.invokeReportDateCheck();
//    Date today = Calendar.getInstance().getTime();
//    SimpleDateFormat sdf = new SimpleDateFormat("EEEE, dd MMM yyyy");
//    assertTrue("Report date doesn't match", date.startsWith(sdf.format(today)));
//  }

  /**
   * Validates the report types
   *
   * @throws Throwable pass the exception
   */
//  @Then("validates the report types shown to the user$")
//  public void validates_the_report_types_shown_to_the_user() throws Throwable {
//    assertTrue(responseAware.invokeValidateOnReportTypes());
//  }

//  /**
//   * Navigate to the given page
//   *
//   * @param page page to navigate to
//   */
//  public void invokeUIReportsPage(String page) {
//    getWebDriver().findElement(By.linkText(page)).click();
//  }

//  /**
//   * Extract report date from UI and return value
//   *
//   * @return report date on page
//   */
//  public String invokeReportDateCheck() {
//    return extractValueFromTable(1, 1, 1);
//  }

  /**
   * Check if the correct headings appear for the current report
   *
   * @param firstHeading the first heading in the table
   * @param lastHeading the last heading in the table
   * @return true if headings are correct
   */
//  public boolean invokeCheckReportHeadings(String firstHeading, String lastHeading) {
//    return (getWebDriver().getPageSource().contains(firstHeading) && getWebDriver().getPageSource()
//        .contains(lastHeading));
//  }

  /**
   * Check if the correct elements appear for the current report table
   *
   * @param column the column number to be extracted
   * @return contents of table element at given column
   */
//  public String invokeCheckReportContents(int column) {
//    return extractValueFromTable(1, 1, column);
//  }
//
//  /**
//   * Check if the correct error message is displayed
//   *
//   * @param error the error message that should exist on the page
//   * @return true if error message exists
//   */
//  public boolean invokeReportErrorCheck(String error) {
//    return getWebDriver().getPageSource().contains(error);
//  }
//
//  /**
//   * checks contents of report type table to match format and content as within the data base.
//   *
//   * @return true is match is found
//   */
//  public boolean invokeValidateOnReportTypes() {
//    List<String> returnedReportTypes = extractColumnValuesFromTable(1, 1);
//
//    if (returnedReportTypes.equals(REPORT_TYPES)) {
//      System.out.println("Types match");
//      return true;
//    } else {
//      System.out.println(returnedReportTypes + ", " + REPORT_TYPES);
//      return false;
//    }
//  }

  //
///**
// * close browser
// *
// * @throws Throwable pass the exception
// */
//@Then("^close browser$")
//public void close_browser() throws Throwable {
//  responseAware.closeWebDriver();
//}
}
