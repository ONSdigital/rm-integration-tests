package uk.gov.ons.ctp.response.common.steps;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertTrue;

import java.util.List;

import cucumber.api.java.en.Given;
import cucumber.api.java.en.Then;
import cucumber.api.java.en.When;
import uk.gov.ons.ctp.response.samplesvc.util.SampleSvcSFTPResponseAware;

/**
 * Created by Stephen Goddard on 5/5/17.
 */
public class SFTPSteps {
  private final SampleSvcSFTPResponseAware responseAware;

  /**
   * Constructor
   *
   * @param sftpResponseAware SFTP runner
   */
  public SFTPSteps(SampleSvcSFTPResponseAware sftpResponseAware) {
    this.responseAware = sftpResponseAware;
  }

  /**
   * Test the exit code
   *
   * @param exitCodeStr exit code
   * @throws Throwable pass the exception
   */
  @When("^the sftp exit status should be \"(.*?)\"$")
  public void the_sftp_exit_status_should_be(String exitCodeStr) throws Throwable {
    int exitCode = new Integer(exitCodeStr).intValue();
    int runExitCode = responseAware.getStatus();
    assertEquals("Exit code equals: " + runExitCode, exitCode, runExitCode);
  }

  /**
   * Clean any files from previous runs of the sample service for the survey area
   *
   * @param surveyType survey area to run
   * @throws Throwable pass the exception
   */
  @Given("^clean sftp folders of all previous ingestions for \"(.*?)\" surveys$")
  public void clean_sftp_folders_of_all_previous_ingestions_for_surveys(String surveyType) throws Throwable {
    responseAware.invokeCleanSurveyFolders(surveyType);
  }

  /**
   * Move file to trigger sample service to process file
   *
   * @param surveyType survey area to run
   * @param fileType currently either valid or invalid
   * @throws Throwable pass the exception
   */
  @When("^for the \"(.*?)\" survey move the \"(.*?)\" file to trigger ingestion$")
  public void for_the_survey_move_the_file_to_trigger_ingestion(String surveyType, String fileType) throws Throwable {
    responseAware.invokeSurveyFileTransfer(surveyType, fileType);
  }

  /**
   * Confirm the sample service has processed the file and the renamed file exists
   *
   * @param surveyType survey area to run
   * @param filename name of file to check exists
   * @throws Throwable pass the exception
   */
  @Then("^for the \"(.*?)\" survey confirm processed file \"(.*?)\" is found$")
  public void for_the_survey_confirm_processed_file_is_found(String surveyType, String filename) throws Throwable {
    List<String> resultList = responseAware.invokeConfirmSurveyProcessedFileExists(surveyType, filename);
    assertTrue("Processed File not found: " + filename, resultList.size() == 1);
  }

  /**
   * Confirm the sample service has processed the file and the renamed file exists
   *
   * @param surveyType survey area to run
   * @param filename name of file to check exists
   * @throws Throwable pass the exception
   */
  @Then("^for the \"(.*?)\" survey get the contents of the file \"(.*?)\"$")
  public void for_the_survey_get_the_contents_of_the_file(String surveyType, String filename) throws Throwable {
    responseAware.invokeGetFileContents(surveyType, filename);
  }

  /**
   * Confirm the file contains a line with the details as expected
   *
   * @param entry line (excluding iac) to be searched for
   * @throws Throwable pass the exception
   */
  @When("^and the contents should contain \"(.*?)\"$")
  public void and_the_contents_should_contain(String entry) throws Throwable {
    assertTrue("File does not contain the correct entry", responseAware.getBody().contains(entry));
  }
}
