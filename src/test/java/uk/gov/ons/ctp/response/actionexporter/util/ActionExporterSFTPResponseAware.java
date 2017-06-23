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
   * @throws JSchException JSch exception
   * @throws SftpException SFTP exception
   * @throws IOException IO exception
   */
  public void invokeMkdir(String copyLocation) throws JSchException, SftpException, IOException {
    responseAware.makeDir(world.getProperty(PRINT_FILE_LOCATION_KEY), copyLocation);
  }

  /**
   * Get contents of print file(s)
   *
   * @param copyLocation directory where file(s) are to be moved to
   * @throws JSchException JSch exception
   * @throws SftpException SFTP exception
   * @throws IOException IO exception
   */
  public void moveFilesToTempDir(String copyLocation) throws JSchException, SftpException, IOException {
    responseAware.moveFiles(world.getProperty(PRINT_FILE_LOCATION_KEY), copyLocation);
  }

  /**
   * Get contents of print file(s)
   *
   * @param filename or part name to be found and contents extracted
   * @throws JSchException JSch exception
   * @throws SftpException SFTP exception
   * @throws IOException IO exception
   */
  public void invokeGetPrintFileContents(String filename) throws JSchException, SftpException, IOException {
    responseAware.getContentsOfFile(world.getProperty(PRINT_FILE_LOCATION_KEY), filename);
  }

  /**
   * Clean print files from directory from previous test run
   *
   * @throws JSchException JSch exception
   * @throws SftpException SFTP exception
   * @throws IOException IO exception
   */
  public void invokeCleanOldPrintFolders() throws JSchException, SftpException, IOException {
    responseAware.deleteAllFilesInDirectory(world.getProperty(PRINT_FILE_LOCATION_KEY));
  }
}
