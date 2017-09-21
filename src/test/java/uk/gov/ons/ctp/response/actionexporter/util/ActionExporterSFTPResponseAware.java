package uk.gov.ons.ctp.response.actionexporter.util;

import java.io.IOException;

import com.jcraft.jsch.JSchException;
import com.jcraft.jsch.SftpException;

import uk.gov.ons.ctp.util.SFTPResponseAware;
import uk.gov.ons.ctp.util.World;

/**
 * Created by Stephen Goddard on 5/5/17.
 */
public class ActionExporterSFTPResponseAware {
  /* Property keys */
  private static final String PRINT_FILE_LOCATION_KEY = "cuc.collect.actionexp.print.file";
  private static final String SFTP_USERNAME = "cuc.sftp.actionexp.username";
  private static final String SFTP_PASSWORD = "cuc.sftp.actionexp.password";

  private World world;
  private final SFTPResponseAware responseAware;

  /**
   * Constructor
   *
   * @param newWorld class with application and environment properties
   * @param sftpResponseAware SFTP response aware object
   */
  public ActionExporterSFTPResponseAware(final World newWorld, SFTPResponseAware sftpResponseAware) {
    this.world = newWorld;
    this.responseAware = sftpResponseAware;
    responseAware.setCredentials(world.getProperty(SFTP_USERNAME), world.getProperty(SFTP_PASSWORD));
  }

  /**
   * Get response status.
   *
   * @return status int
   */
  public int getStatus() {
    return responseAware.getStatus();
  }

  /**
   * Get response body.
   *
   * @return body as string
   */
  public String getBody() {
    return responseAware.getBody();
  }

  /**
   * Get contents of print file(s)
   *
   * @param copyLocation directory to be created
   * @param surveyType to navigate to correct folder
   * @throws JSchException JSch exception
   * @throws SftpException SFTP exception
   * @throws IOException IO exception
   */
  public void invokeMkdir(String copyLocation, String surveyType) throws JSchException, SftpException, IOException {
    final String surveyLocation = String.format(world.getProperty(PRINT_FILE_LOCATION_KEY), surveyType);
    responseAware.makeDir(surveyLocation, copyLocation);
  }

  /**
   * Get contents of print file(s)
   *
   * @param copyLocation directory where file(s) are to be moved to
   * @param surveyType to navigate to correct folder
   * @throws JSchException JSch exception
   * @throws SftpException SFTP exception
   * @throws IOException IO exception
   */
  public void moveFilesToTempDir(String copyLocation, String surveyType)
      throws JSchException, SftpException, IOException {
    final String surveyLocation = String.format(world.getProperty(PRINT_FILE_LOCATION_KEY), surveyType);
    responseAware.moveFiles(surveyLocation, copyLocation);
  }

  /**
   * Get contents of print file(s)
   *
   * @param filename or part name to be found and contents extracted
   * @param surveyType to navigate to correct folder
   * @throws JSchException JSch exception
   * @throws SftpException SFTP exception
   * @throws IOException IO exception
   */
  public void invokeGetPrintFileContents(String filename, String surveyType)
      throws JSchException, SftpException, IOException {
    final String surveyLocation = String.format(world.getProperty(PRINT_FILE_LOCATION_KEY), surveyType);
    responseAware.getContentsOfFile(surveyLocation, filename);
  }
}
