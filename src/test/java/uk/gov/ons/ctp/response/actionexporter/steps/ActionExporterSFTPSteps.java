package uk.gov.ons.ctp.response.actionexporter.steps;

import cucumber.api.java.en.Given;
import cucumber.api.java.en.When;
import uk.gov.ons.ctp.response.actionexporter.util.ActionExporterSFTPResponseAware;

import static org.junit.Assert.assertTrue;

/**
 * Created by Stephen Goddard on 23/6/17.
 */
public class ActionExporterSFTPSteps {
  private static final int IAC_SIZE = 12;
  private final ActionExporterSFTPResponseAware responseAware;

  /**
   * Constructor
   *
   * @param actionExporterSFTPResponseAware SFTP runner
   */
  public ActionExporterSFTPSteps(ActionExporterSFTPResponseAware actionExporterSFTPResponseAware) {
    this.responseAware = actionExporterSFTPResponseAware;
  }

  /**
   * Create the directory if it does not exist
   *
   * @param previousFilesLoc source folder
   * @param surveyType to navigate to correct folder
   * @throws Throwable pass the exception
   */
  @Given("^create test directory \"(.*?)\" for \"(.*?)\"$")
  public void create_test_directory_for(String previousFilesLoc, String surveyType) throws Throwable {
    responseAware.invokeMkdir(previousFilesLoc, surveyType);
  }

  /**
   * Move any files to the destination folder
   *
   * @param previousFilesLoc destination folder
   * @param surveyType to navigate to correct folder
   * @throws Throwable pass the exception
   */
  @When("^move print files to \"(.*?)\" for \"(.*?)\"$")
  public void move_print_files_to_for(String previousFilesLoc, String surveyType) throws Throwable {
    responseAware.moveFilesToTempDir(previousFilesLoc, surveyType);
  }

  /**
   * Move any files to the destination folder
   *
   * @param filename to get contents of
   * @param surveyType to navigate to correct folder
   * @throws Throwable pass the exception
   */
  @Given("^get the contents of the print files where the filename begins \"(.*?)\" for \"(.*?)\"$")
  public void get_the_contents_of_the_print_files_where_the_filename_begins_for(String filename, String surveyType)
      throws Throwable {
    responseAware.invokeGetPrintFileContents(filename + "*", surveyType);
  }

  /**
   * Confirm each line starts with an iac by checking length of first field
   *
   * @throws Throwable pass the exception
   */
  @When("^each line should contain an iac$")
  public void each_line_should_contain_an_iac() throws Throwable {
    String[] lines = responseAware.getBody().split(System.lineSeparator());

    for (String line: lines) {
      if (line.contains(":")) {
        String[] fields = line.split("\\:");
        String iac = fields[1];
        assertTrue("iac not found: " + iac, iac.length() == IAC_SIZE);
      }
    }
  }
}
