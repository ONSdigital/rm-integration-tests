package uk.gov.ons.ctp.response.samplesvc.util;

import java.io.IOException;
import java.util.List;

import com.jcraft.jsch.JSchException;
import com.jcraft.jsch.SftpException;

import uk.gov.ons.ctp.util.SFTPResponseAware;
import uk.gov.ons.ctp.util.World;

/**
 * Created by Stephen Goddard on 5/5/17.
 */
public class SampleSvcSFTPResponseAware {
  /* Property keys */
  private static final String SFTP_SURVEY_LOCATION_KEY = "cuc.collect.samplesvc.sftp.survey";
  private static final String XML_LOCATION_KEY = "cuc.collect.samplesvc.xml.location";
  private static final String SSVC_FILENAME_VALID_KEY = "cuc.collect.samplesvc.valid.filename";
  private static final String SSVC_FILENAME_INVALID_KEY = "cuc.collect.samplesvc.invalid.filename";
  private static final String SSVC_FILENAME_MIN_KEY = "cuc.collect.samplesvc.min.filename";
  private static final String SFTP_USERNAME = "cuc.sftp.samplesvc.username";
  private static final String SFTP_PASSWORD = "cuc.sftp.samplesvc.password";

  private World world;
  private final SFTPResponseAware responseAware;

  /**
   * Constructor
   *
   * @param newWorld class with application and environment properties
   * @param sftpResponseAware SFTP response aware object
   */
  public SampleSvcSFTPResponseAware(final World newWorld, SFTPResponseAware sftpResponseAware) {
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
   * Clean any files from previous runs of the sample service for the survey area:
   * Clean survey area files
   * Clean errors files
   *
   * @param surveyType survey area to run
   * @throws JSchException JSch exception
   * @throws SftpException SFTP exception
   */
  public void invokeCleanSurveyFolders(String surveyType) throws JSchException, SftpException {
    final String surveyLocation = String.format(world.getProperty(SFTP_SURVEY_LOCATION_KEY), surveyType);
    responseAware.setCredentials(world.getProperty(SFTP_USERNAME), world.getProperty(SFTP_PASSWORD));
    responseAware.deleteAllFilesInDirectory(surveyLocation);
  }

  /**
   * Move files to trigger the sample service for the survey type
   *
   * @param surveyType survey area to run
   * @param fileType currently either valid or invalid
   * @throws JSchException JSch exception
   * @throws SftpException SFTP exception
   */
  public void invokeSurveyFileTransfer(String surveyType, String fileType) throws JSchException, SftpException {
    final String surveyLocation = String.format(world.getProperty(SFTP_SURVEY_LOCATION_KEY), surveyType);
    String filename = constructFilename(surveyType, fileType);
    responseAware.setCredentials(world.getProperty(SFTP_USERNAME), world.getProperty(SFTP_PASSWORD));
    responseAware.copyFileFromLocalToRemote(surveyLocation, world.getProperty(XML_LOCATION_KEY), filename);
  }

  /**
   * Confirm file exists
   *
   * @param surveyType survey area to run
   * @param filename to be found
   * @throws JSchException JSch exception
   * @throws SftpException SFTP exception
   * @return List of filename(s)
   */
  public List<String>  invokeConfirmSurveyProcessedFileExists(String surveyType, String filename)
      throws JSchException, SftpException {
    final String surveyLocation = String.format(world.getProperty(SFTP_SURVEY_LOCATION_KEY), surveyType);
    responseAware.setCredentials(world.getProperty(SFTP_USERNAME), world.getProperty(SFTP_PASSWORD));
    return responseAware.findFilesInDirectory(surveyLocation, filename);
  }

  /**
   * Get contents of file
   *
   * @param surveyType survey area to run
   * @param filename to be found
   * @throws JSchException JSch exception
   * @throws SftpException SFTP exception
   * @throws IOException IO exception
   */
  public void invokeGetFileContents(String surveyType, String filename)
      throws JSchException, SftpException, IOException {
    final String surveyLocation = String.format(world.getProperty(SFTP_SURVEY_LOCATION_KEY), surveyType);
    responseAware.setCredentials(world.getProperty(SFTP_USERNAME), world.getProperty(SFTP_PASSWORD));
    responseAware.getContentsOfFile(surveyLocation, filename);
  }

  /**
   * Construct filename for survey type
   *
   * @param surveyType survey area to run
   * @param fileType currently either valid or invalid
   * @return constructed filename
   */
  private String constructFilename(String surveyType, String fileType) {
    String filename = "";

    if (fileType.equalsIgnoreCase("valid")) {
      String timezone = "";
      if (System.getProperty("cuc.env").equalsIgnoreCase("local") && surveyType.equalsIgnoreCase("BSD")) {
        timezone = "-local";
      } else if (surveyType.equalsIgnoreCase("BSD")) {
        timezone = "-utc";
      }
      filename = String.format(world.getProperty(SSVC_FILENAME_VALID_KEY), surveyType, timezone);
    } else if (fileType.equalsIgnoreCase("invalid")) {
      filename = String.format(world.getProperty(SSVC_FILENAME_INVALID_KEY), surveyType);
    } else if (fileType.equalsIgnoreCase("min")) {
      filename = String.format(world.getProperty(SSVC_FILENAME_MIN_KEY), surveyType);
    }
    return filename;
  }
}
