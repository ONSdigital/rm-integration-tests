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
   * @param location source folder
   * @throws Throwable pass the exception
   */
  @Given("^create test directory \"(.*?)\"$")
  public void create_test_directory(String location) throws Throwable {
    responseAware.invokeMkdir(location);
  }

  /**
   * Move any files to the destination folder
   *
   * @param copyLocation destination folder
   * @throws Throwable pass the exception
   */
  @When("^move print files to \"(.*?)\"$")
  public void move_print_files_to(String copyLocation) throws Throwable {
    responseAware.moveFilesToTempDir(copyLocation);
  }

  /**
   * Move any files to the destination folder
   *
   * @param filename to get contents of
   * @throws Throwable pass the exception
   */
  @Given("^get the contents of the print files where the filename begins \"(.*?)\"$")
  public void get_the_contents_of_the_print_files_where_the_filename_begins(String filename) throws Throwable {
    responseAware.invokeGetPrintFileContents(filename + "*");
  }

  /**
   * Confirm each line starts with an iac by checking length of first field
   *
   * @throws Throwable pass the exception
   */
  @When("^each line should start with an iac$")
  public void each_line_should_start_with_an_iac() throws Throwable {
    String[] lines = responseAware.getBody().split(System.lineSeparator());

    for (String line: lines) {
      if (line.contains("|")) {
        String[] fields = line.split("\\|");
        String iac = fields[1];
        assertTrue("iac not found: " + iac, iac.length() == IAC_SIZE);
      }
    }
  }
}
