package uk.gov.ons.ctp.ui.rm.ro.util;

import org.openqa.selenium.WebElement;

import uk.gov.ons.ctp.management.ui.util.TableHelper;
import uk.gov.ons.ctp.ui.rm.ro.pom.ActionStatusPom;
import uk.gov.ons.ctp.ui.rm.ro.pom.CaseEventsPom;
import uk.gov.ons.ctp.ui.rm.ro.pom.PrintVolumesPom;
import uk.gov.ons.ctp.ui.rm.ro.pom.ReportsPom;
import uk.gov.ons.ctp.ui.rm.ro.pom.SampleReportPom;
import uk.gov.ons.ctp.ui.rm.ro.pom.SearchReportUnitPom;
import uk.gov.ons.ctp.ui.rm.ro.pom.SignInPom;
import uk.gov.ons.ctp.ui.util.SeleniumAware;
import uk.gov.ons.ctp.util.World;

/**
 * Created by Stephen Goddard on 24/05/16.
 * Edited by Chris Hardman on 17/11/16
 *
 */
public class UIResponseAware extends SeleniumAware {
  private static final String REPORTS_URL = "/reports";
  private static final String SERVICE = "ui";

  /**
   * Constructor
   *
   * @param newWorld class with application and environment properties
   */
  public UIResponseAware(final World newWorld) {
    super(newWorld);
  }

  public void searchReportingUnit (String reportRef){

    SearchReportUnitPom search = new SearchReportUnitPom(getWebDriver());
    search.setReportRef(reportRef);
    search.submitReportRef();
  }
  
  public void checkCaseEventsForCase (String event){
	SearchReportUnitPom search = new SearchReportUnitPom(getWebDriver());
	search.checkCaseEvent(event);
  }
  
  
  public void invokeReportSelection(String reportType) {
    invokeNavigateToPage(getWorld().getUrl(REPORTS_URL, SERVICE));

    ReportsPom reports = new ReportsPom(getWebDriver());
    reports.selectReportType(reportType);
  }
  
  public void viewReport() {
    ReportsPom reports = new ReportsPom(getWebDriver());
    reports.selectReport();
  }
 
  public void viewCaseEvents(String field, String value) {
    CaseEventsPom caseReport = new CaseEventsPom(getWebDriver());
    switch (field){
    case "sampleType":
      caseReport.checkSampleUnitType(value);
      break;
    case "caseCreated":
      caseReport.checkCaseCreated(value);
      break;
    case "actionCompleted":
      caseReport.checkActionCompleted(value);
  	  break;
    case "accountCreated":
      caseReport.checkAccountCreated(value);
      break;
    case "accountEnrolled":
      caseReport.checkEnrolled(value);
      break;
    case "authentication":
      caseReport.checkAuthentication(value);
  	  break;
    case "offlineResponse":
        caseReport.checkOfflineResponse(value);
        break;
    case "downloaded":
        caseReport.checkCollectionDownload(value);
        break;
    case "successfulResponse":
        caseReport.checkSuccessfulResponse(value);
        break;
    case "unsuccessfulResponse":
        caseReport.checkUnsuccessfulResponse(value);
        break;
    }
  }
  
  public void viewSampleUnit(String field, String value) {
    SampleReportPom sampleReport = new SampleReportPom(getWebDriver());
    switch (field){
    case "formType":
	  sampleReport.checkFormType(value);
	  break;
    }
  }
  
  public void viewPrintVolume(String field, String value) {
    PrintVolumesPom printReport = new PrintVolumesPom(getWebDriver());
    switch (field){
    case "fileName":
      printReport.checkFileName(value);
      break;
    case "row":
      printReport.checkRowCount(value);
      break;
    }
  }
  
  public void viewActionStatus(String field, String value) {
    ActionStatusPom actionReport = new ActionStatusPom(getWebDriver());
    switch (field){
    case "enrolmentLetter":
      actionReport.checkEnrolmentLetter(value);
      break;
    case "enrolmentAction":
      actionReport.checkEnrolmentActionCount(value);
      break;
    case "reminderLetter":
      actionReport.checkReminderLetter(value);
      break;
    case "reminderAction":
      actionReport.checkReminderActionCount(value);
      break;
    case "surveyReminderNoifcation":
        actionReport.checkReminderActionCount(value);
        break;
    }
  }
  
  public void checksColumnValues(int column, String value, int number) {
	  ReportsPom reports = new ReportsPom(getWebDriver());
	  reports.checksColumnValues(column, value, number);
  }
}
