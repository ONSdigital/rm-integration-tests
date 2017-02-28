package uk.gov.ons.ctp.ui.util;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

import org.openqa.selenium.By;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.ui.Select;

import uk.gov.ons.ctp.util.SeleniumAware;
import uk.gov.ons.ctp.util.World;

/**
 * Created by Stephen Goddard on 24/05/16.
 * Edited by Chris Hardman on 17/11/16
 *
 */
public class UiResponseAware extends SeleniumAware {
  private static final String[] QUESTION_SETS = new String[]{"H1", "H1S", "H2", "H2S", "I1", "I1S", "HOTEL"};
  private static final String[] ADDRESS_TYPES = new String[]{"Household"};
  private static final String[] CASE_STATES = new String[]{"ACTIONABLE", "INACTIONABLE", "REPLACEMENT_INIT",
      "SAMPLED_INIT"};
  private static final List<String> REPORT_TYPES = new ArrayList<>(Arrays.asList("HH Returnrate", "HH Noreturns",
    "HH Returnrate Sample", "HH Returnrate LA", "CE Returnrate Uni", "CE ReturnRate SHousing", "CE Returnrate Hotel",
    "HL Metrics", "HH Outstanding Cases", "SH Outstanding Cases", "CE Outstanding Cases", "Print Volumes"));

  /**
   * Constructor
   *
   * @param newWorld class with application and environment properties
   */
  public UiResponseAware(final World newWorld) {
    super(newWorld);
  }

  /**
   * Initialise browser and login to UI
   *
   * @param browser string representation of the browser to be used
   */
  public void invokeUILogin(String browser) {
    initialiseWebDriver(browser);

    invokeNavigateToPage(getWorld().getUiUrl("/signin"));

    WebElement inputUsername = getWebDriver().findElement(By.id("username"));
    inputUsername.sendKeys(getWorld().getProperty("integration.test.username"));
    WebElement inputPassword = getWebDriver().findElement(By.xpath("//input[@placeholder='Password']"));
    inputPassword.sendKeys(getWorld().getProperty("integration.test.password"));

    getWebDriver().findElement(By.xpath("//input[@type='submit']")).click();
  }

  /**
   * Initialise browser and login to UI as other users
   * General
   * Field
   * Error
   *
   * @param browser string representation of the browser to be used
   * @param userType type of user to login
   */
  public void invokeUIOtherLogin(String browser, String userType) {
    initialiseWebDriver(browser);

    invokeNavigateToPage(getWorld().getUiUrl("/signin"));

    String username = "";
    String password = "";
    if (userType.equals("CSO")) {
      username = getWorld().getProperty("integration.test.cso.username");
      password = getWorld().getProperty("integration.test.cso.password");
    } else if (userType.equals("General")) {
      username = getWorld().getProperty("integration.test.general.username");
      password = getWorld().getProperty("integration.test.general.password");
    } else if (userType.equals("Field")) {
     username = getWorld().getProperty("integration.test.field.username");
     password = getWorld().getProperty("integration.test.field.password");
    } else if (userType.equals("Report")) {
      username = getWorld().getProperty("integration.test.report.username");
      password = getWorld().getProperty("integration.test.report.password");
    } else if (userType.equals("Error")) {
      username = getWorld().getProperty("integration.test.error.username");
      password = getWorld().getProperty("integration.test.error.password");
    }

    WebElement inputUsername = getWebDriver().findElement(By.id("username"));
    inputUsername.sendKeys(username);
    WebElement inputPassword = getWebDriver().findElement(By.xpath("//input[@placeholder='Password']"));
    inputPassword.sendKeys(password);

    getWebDriver().findElement(By.xpath("//input[@type='submit']")).click();
  }


  /**
   * Checks the permission of user that has logged in are correct
   * @param user string representation of users
   * @return boolean whether or not user has permissions
   */
  public boolean userPermissionsCheck(String user) {
    if (!user.equals("error")) {
      String userCheck = getWebDriver().findElement(By.xpath("//p[@class='message']")).getText();
      System.out.println(userCheck + ", " + user);
      if (userCheck.equals("Welcome back Collect CSO User.") && user.equals("cso")) {
        System.out.println("CSO User successful");
        return  true;
      } else if (userCheck.equals("Welcome back General Escalate.") && user.equals("general")) {
        System.out.println("General Escalate User successful.");
        return  true;
      } else if (userCheck.equals("Welcome back Field Escalate.") && user.equals("field")) {
        System.out.println("Field Escalate User successful");
        return  true;
      } else if (userCheck.equals("Welcome back Collect Reports user.") && user.equals("report")) {
        System.out.println("Report User successful");
        return  true;
      }
    } else if (user.equals("error")) {
      String errorCheck = getWebDriver().findElement(By.xpath("//p[@class='message']")).getText();
      if (errorCheck.equals("You could not be signed in. Did you enter the correct credentials?")) {
        System.out.println("Error denied permission successful");
        return  true;
      }
    }

    System.out.println("Error: unexpected result");
    return false;
  }
  /**
   * Enter a postcode to page and enter
   *
   * @param postcode string representation of postcode
   */
  public void invokeUIPostcodeSelect(String postcode) {
    final String url = String.format("/postcodes/%s", postcode);
    invokeGoToPage(url);
  }

  /**
   * check results of postCode search
   * @param postcode to check for addresses
   * @return boolean whether postcode is correct
   *
   */
  public boolean invokeUIPostcodeVerification(String postcode) {
    Boolean postCodeTitle = getWebDriver().findElements(By.id("information")).size() > 0;
    System.out.println(postCodeTitle + "   " + postcode);
    if (postCodeTitle && postcode.equals("incorrect")) {
      System.out.println("no addresses");
      return true;
    } else if (!postCodeTitle && postcode.equals("correct")) {
      System.out.println("addresses");
      return true;
    }
    return false;
  }

  /**
   * Select address from table and click view cases
   *
   * @param address string representation of address to find in table
   */
  public void invokeUIAddressSelect(String address) {
    WebElement row = this.extractRowFromTableBySearch(0, address);

    // Handle when there are more entries than displayed on the table - go to next table
    if (row == null) {
      while (getWebDriver().findElement(By.className("next_page")) != null) {
        getWebDriver().findElement(By.className("next_page")).click();
        row = this.extractRowFromTableBySearch(0, address);
        if (row != null) {
          break;
        }
      }
    }
    row.findElement(By.linkText("View Cases")).click();
  }

  /**
   * check results of postCode search
   *
   * @param type string representation of postcode
   * @return boolean if verified
   *
   */
  public boolean invokeUICaseInformationVerification(String type) {
    int i = 0;
    if (type.equals("QuestionSet")) {
      String questionSet = extractValueFromTable(2, 1, 4);
      System.out.println(questionSet);
      while (i < QUESTION_SETS.length) {
        if (questionSet.equals(QUESTION_SETS[i])) {
            System.out.println("This Case has a correct question set and its prensent");
            return true;
        }
        i++;
      }
    } else if (type.equals("AddressType")) {
      String addressType = extractValueFromTable(1, 1, 9);
      while (i < ADDRESS_TYPES.length) {
        if (addressType.equals(ADDRESS_TYPES[i])) {
            System.out.println("This Case has a correct address type and its prensent");
            return true;
        }
        i++;
      }
    } else if (type.equals("CaseState")) {
      String caseState = extractValueFromTable(1, 1, 1);
      while (i < CASE_STATES.length) {
        if (caseState.equals(CASE_STATES[i])) {
            System.out.println("This Case has a correct case state and its prensent");
            return true;
        }
        i++;
      }
    }

    return false;
  }

  /**
   * Select case id to load case page
   *
   * @param caseId string representation of case id to select
   */
  public void invokeUICasesPage(String caseId) {
    if (!getWebDriver().findElement(By.linkText(caseId)).equals(null)) {
      getWebDriver().findElement(By.linkText(caseId)).click();
    } else {
      System.out.println("Address has no cases.");
    }
  }

  /**
   * Select case id to load case page
   */
  public void checkCasesCount() {
    List<WebElement> tables = getWebDriver().findElements(By.tagName("table"));
    int rowsCount = tables.size();

    System.out.println("Case Count: " + rowsCount);

    if (rowsCount == 0) {
      System.out.println("No cases are associated to this address. There should always be at least one.");
    }
  }

  /**
   * Create a request for an individual form
   *
   * @param formContent List of content to fill in form
   */
  public void invokeUICreateIndividualRequest(List<String> formContent) {
    getWebDriver().findElement(By.cssSelector("input[type='submit'][value='Request Individual Form…']")).click();
    invokeUICompleteForm(formContent);
  }

  /**
   * Create a request for a replacement IAC
   *
   * @param formContent List of content to fill in form
   */
  public void invokeUICreateReplacementIACRequest(List<String> formContent) {
    getWebDriver().findElement(By.cssSelector(
    "input[type='submit'][value='Request Replacement Access Code…']")).click();
    invokeUICompleteForm(formContent);
  }

  /**
   * Create a request for a replacement paper form
   *
   * @param formContent List of content to fill in form
   */
  public void invokeUICreateReplacementPaperRequest(List<String> formContent) {
    getWebDriver().findElement(By.cssSelector("input[type='submit'][value='Request Paper Form…']")).click();
    invokeUICompleteForm(formContent);
  }

  /**
   * Complete the form as per form content
   *
   * @param formContent List of content to fill in form
   */
  private void invokeUICompleteForm(List<String> formContent) {
    if (formContent.get(6).equals("English")) {
      WebElement row = this.extractRowFromTableBySearch(0, formContent.get(6));
      row.findElement(By.id("regular")).click();
    } else if (formContent.get(6).equals("Welsh")) {
      WebElement row = this.extractRowFromTableBySearch(0, formContent.get(6));
      row.findElement(By.id("regular")).click();
    } else {
      WebElement row = this.extractRowFromTableBySearch(0, formContent.get(0));
      row.findElement(By.id("regular")).click();
    }
    String title = formContent.get(1);
    if (title != null && title.length() > 0) {
      final Select selectBox = new Select(getWebDriver().findElement(By.id("customertitle")));
      selectBox.selectByVisibleText(title);
    }
    getWebDriver().findElement(By.id("customerforename")).sendKeys(formContent.get(2));
    getWebDriver().findElement(By.id("customersurname")).sendKeys(formContent.get(3));
    String email = formContent.get(4);
    if (email != null && email.length() > 0) {
      getWebDriver().findElement(By.id("emailaddress")).sendKeys(formContent.get(4));
    }
    getWebDriver().findElement(By.id("phonenumber")).sendKeys(formContent.get(5));

    getWebDriver().findElement(By.xpath("//input[@type='submit']")).click();
  }

  /**
   * Create a request for a translation booklet
   *
   * @param translation to request
   */
  public void invokeUICreateTranslationRequest(String translation) {
    getWebDriver().findElement(By.cssSelector("input[type='submit'][value='Request Translation Booklet…']")).click();

    if (translation != null && translation.length() > 0) {
      final Select selectBox = new Select(getWebDriver().findElement(By.id("eventcategory")));
      selectBox.selectByVisibleText(translation);
    }
    getWebDriver().findElement(By.xpath("//input[@type='submit']")).click();
  }

  /**
   * Create an event and submit
   *
   * @param formContent List of content to fill in form
   */
  public void invokeUICreateCaseEvent(List<String> formContent) {
    getWebDriver().findElement(By.xpath("//input[@value='Create Event…']")).click();

    // enter details and save
    getWebDriver().findElement(By.id("eventtext")).sendKeys(formContent.get(1));

    final Select titleBox = new Select(getWebDriver().findElement(By.id("customertitle")));
    titleBox.selectByVisibleText("Lord");

    getWebDriver().findElement(By.id("customerforename")).sendKeys(formContent.get(2));
    getWebDriver().findElement(By.id("customersurname")).sendKeys(formContent.get(2));
    getWebDriver().findElement(By.id("customercontact")).sendKeys(formContent.get(3));
    String category = formContent.get(0);

    if (category != null && category.length() > 0) {
      final Select selectBox = new Select(getWebDriver().findElement(By.id("eventcategory")));
      selectBox.selectByVisibleText(category);
    }

    getWebDriver().findElement(By.xpath("//input[@type='submit']")).click();
  }

  /**
   * Navigate back to the case screen for the current case
   */
  public void invokeUINavigateBackToCase() {
    getWebDriver().findElement(By.xpath("//*[@id=\"breadcrumbs\"]/a[3]")).click();
  }

  /**
   * Navigate to the escalated complaints page
   *
   * @param type of escalation to navigate to
   */
  public void invokeUIEscalation(String type) {
    getWebDriver().findElement(By.linkText("Manage")).click();
    getWebDriver().findElement(By.linkText(type)).click();
  }

  /**
   * Navigate to the given page
   *
   * @param page page to navigate to
   */
  public void invokeUIReportsPage(String page) {
    getWebDriver().findElement(By.linkText(page)).click();
  }

  /**
   * Check that a specific error string appears on the page
   *
   * @param error string expected on page
   * @return true if an error message is displayed on the page
   */
  public boolean invokeUIReportsCheckError(String error) {
    return getWebDriver().findElements(By.id(error)).isEmpty();
  }

  /**
   * Extract report date from UI and return value
   *
   * @return report date on page
   */
  public String invokeReportDateCheck() {
    return extractValueFromTable(1, 1, 1);
  }

  /**
   * Check if the correct headings appear for the current report
   *
   * @param firstHeading the first heading in the table
   * @param lastHeading the last heading in the table
   * @return true if headings are correct
   */
  public boolean invokeCheckReportHeadings(String firstHeading, String lastHeading) {
    return (getWebDriver().getPageSource().contains(firstHeading) && getWebDriver().getPageSource()
        .contains(lastHeading));
  }

  /**
   * Check if the correct elements appear for the current report table
   *
   * @param column the column number to be extracted
   * @return contents of table element at given column
   */
  public String invokeCheckReportContents(int column) {
    return extractValueFromTable(1, 1, column);
  }

  /**
   * Check if the correct error message is displayed
   *
   * @param error the error message that should exist on the page
   * @return true if error message exists
   */
  public boolean invokeReportErrorCheck(String error) {
    return getWebDriver().getPageSource().contains(error);
  }

  /**
   * checks contents of report type table to match format and content as within the data base.
   *
   * @return true is match is found
   */
  public boolean invokeValidateOnReportTypes() {
    List<String> returnedReportTypes = extractColumnValuesFromTable(1, 1);

    if (returnedReportTypes.equals(REPORT_TYPES)) {
      System.out.println("Types match");
      return true;
    } else {
      System.out.println(returnedReportTypes + ", " + REPORT_TYPES);
      return false;
    }
  }

  /**
   * Navigate to the case page from the escalated complaints page
   *
   * @param caseId string representation of case id to select
   */
  public void invokeUIManagerCasePage(String caseId) {
    getWebDriver().findElement(By.linkText(caseId)).click();
  }

  /**
   * Navigate to specified page on UI
   *
   * @param url go to page on UI
   */
  public void invokeGoToPage(String url) {
    invokeNavigateToPage(getWorld().getUiUrl(url));
  }

  /**
   * Extract case state from UI and return value
   *
   * @return case state on page
   */
  public String invokeCaseStateCheck() {
    return extractValueFromTable(2, 1, 2);
  }

  /**
   * Extract case state from UI  for specific case and return value
   *
   * @param caseId to search for
   * @return case state for case id
   */
  public String invokeCaseStateCheck(String caseId) {
    WebElement row = this.extractRowFromTableBySearch(1, caseId);
    return row.findElements(By.tagName("td")).get(1).getText();
  }

  /**
   * Extract case state from UI  for specific case and return value
   *
   * @return case state for case id
   */
  public String invokeDescriptionCheck() {
    return extractValueFromTable(2, 1, 4);
  }

  /**
   * Extract case event category from UI and return value
   *
   * @return case event category on page
   */
  public String invokeCaseEventCategory() {
    return extractValueFromTable(3, 1, 4);
  }

  /**
   * Extract case events from UI and returns list
   *
   * @return case event list
   */
  public List<String> invokeCaseEventList() {
    return extractColumnValuesFromTable(3, 4);
  }

  /**
   * Extract case event categories from UI and return values
   *
   * @return case event categories from table column
   */
  public List<String> invokeCaseEventsCategories() {
    return extractColumnValuesFromTable(3, 4);
  }

  /**
   * Extract case action category from UI and return value
   *
   * @return case action category on page
   */
  public String invokeCaseActionCategory() {
    return extractValueFromTable(4, 1, 4);
  }

  /**
   * Extract case event description from UI and return value
   *
   * @return case event category on page
   */
  public String invokeCaseEventDescription() {
    return extractValueFromTable(3, 1, 5);
  }

  /**
   * Extract case event description from UI and return value
   *
   * @return case event category on page
   */
  public List<String> invokeCaseEventDescriptionList() {
    return extractColumnValuesFromTable(3, 5);
  }
  /**
   * Check if case event history is visible
   */
  public void eventHistoryVisible() {
    if (!getWebDriver().findElement(By.xpath("//th[contains(.,'Case Event ID')]")).equals(null)) {
      System.out.println("Case Event History is visible");
    } else {
      System.out.println("Case Event History is hidden. There may be an error");
    }
  }

  /**
   * Check if response has been submitted for questionnaire
   */
  public void checkResponseSubmitted() {
    String responseDate = extractValueFromTable(2, 1, 3);

    if (responseDate.equals("-")) {
      System.out.println("No response received");
    } else {
      System.out.println("Response received");
    }
  }

  /**
   * Check to see if the specified caseID element exists on the page
   *
   * @param caseId to check for
   * @return boolean
   */
  public boolean checkCaseIdRemoved(String caseId) {
    return getWebDriver().findElements(By.linkText(caseId)).isEmpty();
  }

  /**
   * Log out of UI
   */
  public void invokeLogout() {
    getWebDriver().findElement(By.id("signoutlink"));
  }

  /**
   * Extract a value from a table
   *
   * @param tableNumber Integer table number, table at the top of the table is number 1
   * @param rowNumber Integer row number in the table, excluding the header
   * @param columnNumber Integer column number in the row
   * @return String value
   */
  private String extractValueFromTable(int tableNumber, int rowNumber, int columnNumber) {
    List<WebElement> secondaryTables = getWebDriver().findElements(By.tagName("table"));
    WebElement caseEventsTable = secondaryTables.get(tableNumber - 1);
    // find the body of the table
    WebElement tableBody = caseEventsTable.findElement(By.tagName("tbody"));
    // find the row containing the data of interest
    List<WebElement> rows = tableBody.findElements(By.tagName("tr"));
    WebElement row = rows.get(rowNumber - 1);
    // find the column of interest and and get the value
    List<WebElement> values = row.findElements(By.tagName("td"));

    return values.get(columnNumber - 1).getText();
  }

  /**
   * Extract a values from a table column
   *
   * @param tableNumber Integer table number, table at the top of the table is number 1
   * @param columnNumber Integer column number in the row
   * @return List of values
   */
  private List<String> extractColumnValuesFromTable(int tableNumber, int columnNumber) {
    List<String> columnValues = new ArrayList<String>();

    List<WebElement> secondaryTables = getWebDriver().findElements(By.tagName("table"));
    WebElement caseEventsTable = secondaryTables.get(tableNumber - 1);
    WebElement tableBody = caseEventsTable.findElement(By.tagName("tbody"));
    List<WebElement> rows = tableBody.findElements(By.tagName("tr"));

    for (WebElement row: rows) {
      List<WebElement> values = row.findElements(By.tagName("td"));
      columnValues.add(values.get(columnNumber - 1).getText());
    }
    return columnValues;
  }

  /**
   * Extract row from a table
   *
   * @param tableNumber Integer table number, table at the top of the table is number 1
   * @param search String to identify row in table
   * @return WebElement holding row
   */
  private WebElement extractRowFromTableBySearch(int tableNumber, String search) {
    WebElement element = null;
    boolean found = false;

    List<WebElement> tables = getWebDriver().findElements(By.tagName("table"));
    WebElement table = tables.get(tableNumber);
    List<WebElement> trCollection = table.findElements(By.xpath("//table/tbody/tr"));

    for (WebElement trElement : trCollection) {
      List<WebElement> tdCollection = trElement.findElements(By.xpath("td"));
      for (WebElement tdElement : tdCollection) {

        found = tdElement.getText().equalsIgnoreCase(search);
        if (found) {
          element = trElement;
          break;
        }
      }
      if (found) {
        break;
      }
    }
    return element;
  }
}
