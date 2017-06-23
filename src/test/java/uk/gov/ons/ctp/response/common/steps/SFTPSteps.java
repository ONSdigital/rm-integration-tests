package uk.gov.ons.ctp.response.common.steps;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertTrue;

import cucumber.api.java.en.Then;
import cucumber.api.java.en.When;
import uk.gov.ons.ctp.util.SFTPResponseAware;

/**
 * Created by Stephen Goddard on 5/5/17.
 */
public class SFTPSteps {
  private final SFTPResponseAware responseAware;

  /**
   * Constructor
   *
   * @param newSftpResponseAware SFTP runner
   */
  public SFTPSteps(SFTPResponseAware newSftpResponseAware) {
    this.responseAware = newSftpResponseAware;
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
   * Confirm the file contains a line with the details as expected
   *
   * @param entry line (excluding iac) to be searched for
   * @throws Throwable pass the exception
   */
  @When("^the contents should contain \"(.*?)\"$")
  public void the_contents_should_contain(String entry) throws Throwable {
    assertTrue("File does not contain the correct entry", responseAware.getBody().contains(entry));
  }

  /**
   * Confirm the number of lines in file(s) is as expected
   *
   * @param noLines expected number of lines in file
   * @throws Throwable pass the exception
   */
  @Then("^the contents should contain (\\d+) lines$")
  public void the_contents_should_contain_lines(int noLines) throws Throwable {
    String[] lines = responseAware.getBody().split(System.lineSeparator());
    assertTrue("Number of lines found does not match: " + lines.length, lines.length == noLines);
  }
}
