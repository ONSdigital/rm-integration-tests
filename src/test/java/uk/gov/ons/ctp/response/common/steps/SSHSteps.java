package uk.gov.ons.ctp.response.common.steps;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertTrue;

import java.util.List;

import cucumber.api.DataTable;
//import cucumber.api.java.en.Given;
import cucumber.api.java.en.Then;
import cucumber.api.java.en.When;
import uk.gov.ons.ctp.util.SSHResponseAware;

/**
 * Created by Stephen Goddard on 16/8/16.
 */
public class SSHSteps {
//  private static final int IAC_SIZE = 12;
  private final SSHResponseAware responseAware;

  /**
   * Constructor
   *
   * @param sshResponseAware ssh runner
   */
  public SSHSteps(SSHResponseAware sshResponseAware) {
    this.responseAware = sshResponseAware;
  }

//  /**
//   * Create the directory if it does not exist
//   *
//   * @param location source folder
//   * @throws Throwable pass the exception
//   */
//  @Given("^create test directory \"(.*?)\"$")
//  public void create_test_directory(String location) throws Throwable {
//    responseAware.invokeMkdir(location);
//  }

  /**
   * Move any files to the destination folder
   *
   * @param location source folder
   * @param copyLocation destination folder
   * @throws Throwable pass the exception
   */
  @When("^move print files from \"(.*?)\" to \"(.*?)\"$")
  public void move_print_files_from_to(String location, String copyLocation) throws Throwable {
    responseAware.invokePrintFileReset(location, copyLocation);
  }

  /**
   * Test the exit code
   *
   * @param exitCode exit code
   * @throws Throwable pass the exception
   */
  @When("^the exit status should be (\\d+)$")
  public void the_exit_status_should_be(int exitCode) throws Throwable {
    int runExitCode = responseAware.getStatus();
    assertEquals("Exit code equals: " + runExitCode, exitCode, runExitCode);
  }

  /**
   * Get contents of file from the location
   *
   * @param location place where print files are generated
   * @param actionType which starts the filename
   * @throws Throwable pass the exception
   */
  @Then("^get the contents of the file from \"(.*?)\" where the filename begins \"(.*?)\"$")
  public void get_the_contents_of_the_file_from_where_the_filename_begins(String location, String actionType)
      throws Throwable {
    responseAware.invokeGetFileContentsForActionType(location, actionType);
  }

//  /**
//   * Confirm each line starts with an iac by checking length of first field
//   *
//   * @throws Throwable pass the exception
//   */
//  @When("^and each line should start with an iac$")
//  public void and_each_line_should_start_with_an_iac() throws Throwable {
//    String[] lines = responseAware.getBody().split("\\n");
//
//    for (String line: lines) {
//      if (line.contains("|")) {
//        String[] fields = line.split("\\|");
//        String iac = fields[0];
//        assertTrue("iac not found: " + iac, iac.length() == IAC_SIZE);
//      }
//    }
//  }

//  /**
//   * Confirm the file contains a line with the details as expected
//   *
//   * @param entry line (excluding iac) to be searched for
//   * @throws Throwable pass the exception
//   */
//  @When("^and the contents should contain \"(.*?)\"$")
//  public void and_the_contents_should_contain(String entry) throws Throwable {
//    assertTrue("File does not contain the correct entry", responseAware.getBody().contains(entry));
//  }

  /**
   * Creates txt and puts it in SFTP directory
   *
   * @param filename name of file to be created
   * @param content contents of datatable
   * @param path path to place file
   * @throws Throwable pass the exception
   */
  @When("^I create a file in \"(.*?)\" named \"(.*?)\" containing$")
  public void create_a_file_containing(String path, String filename, DataTable content) throws Throwable {
    List<String> formContent = content.asList(String.class);

    String finalContent = "";
    for (int i = 0; i < formContent.size(); i++) {
      finalContent += formContent.get(i);
    }

    responseAware.invokeCreateTestReceipt(filename, path, finalContent);
  }

  /**
   * Test to check if file exists
   *
   * @param filename to check for
   * @param path path to check in
   * @throws Throwable pass the exception
   */
  @Then("^the file \"(.*?)\" in \"(.*?)\" will no longer exist$")
  public void the_file_will_no_longer_exist(String filename, String path) throws Throwable {
    assertTrue(!responseAware.fileExists(path, filename));
  }

  /**
   * Test files are deleted correctly when renamed
   *
   * @param filename to check for
   * @param path path to check in
   * @throws Throwable pass the exception
   */
  @Then("^the txt file will be renamed to \"(.*?)\" in \"(.*?)\" to indicate it has been processed$")
  public void the_csv_file_will_be_renamed_to_indicate_it_has_been_processed(String filename, String path)
      throws Throwable {
    assertTrue(responseAware.fileExists(path, filename));
  }

  // Samplesvc steps

  /**
   * Clean any files from previous runs of the sample service for the survey area
   *
   * @param surveyType survey area to run
   * @throws Throwable pass the exception
   */
//  @Given("^clean sftp folders of all previous ingestions for \"(.*?)\" surveys$")
//  public void clean_sftp_folders_of_all_previous_ingestions_for_surveys(String surveyType) throws Throwable {
//    responseAware.invokeCleanSurveyFolders(surveyType);
//  }

//  /**
//   * Move file to trigger sample service to process file
//   *
//   * @param surveyType survey area to run
//   * @param fileType currently either valid or invalid
//   * @throws Throwable pass the exception
//   */
//  @When("^for the \"(.*?)\" survey move the \"(.*?)\" file to trigger ingestion$")
//  public void for_the_survey_move_the_file_to_trigger_ingestion(String surveyType, String fileType) throws Throwable {
//    responseAware.invokeSurveyFileTransfer(surveyType, fileType);
//  }

//  /**
//   * Confirm the sample service has processed the file and the renamed file exists
//   *
//   * @param surveyType survey area to run
//   * @param filename name of file to check exists
//   * @throws Throwable pass the exception
//   */
//  @Then("^for the \"(.*?)\" survey confirm processed file \"(.*?)\" is found$")
//  public void for_the_survey_confirm_processed_file_is_found(String surveyType, String filename) throws Throwable {
//    String result = responseAware.invokeConfirmSurveyProcessedFileExists(surveyType, filename);
//    assertTrue("Processed File not found: " + filename, result.contains("\nFound"));
//  }

//  @Then("^for the \"(.*?)\" survey get the contents of the file \"(.*?)\"$")
//  public void for_the_survey_get_the_contents_of_the_file(String surveyType, String filename) throws Throwable {
//    responseAware.invokeGetFileContents(surveyType, filename);
//  }
}
