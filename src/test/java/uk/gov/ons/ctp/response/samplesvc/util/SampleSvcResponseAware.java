package uk.gov.ons.ctp.response.samplesvc.util;

import java.io.File;
//import java.io.FileInputStream;
import java.io.IOException;
//import java.util.Properties;

import org.apache.http.auth.AuthenticationException;
import org.apache.http.entity.ContentType;

import com.jcraft.jsch.JSchException;
import com.jcraft.jsch.SftpException;

import uk.gov.ons.ctp.response.common.util.PostgresResponseAware;
import uk.gov.ons.ctp.util.HTTPResponseAware;
import uk.gov.ons.ctp.util.World;

/**
 * Created by Stephen Goddard on 11/4/17.
 */
public class SampleSvcResponseAware {
  private static final String POST_URL = "/samples/sampleunitrequests";
  private static final String INFO_URL = "/info";
  private static final String BRES_UPLOAD_URL = "/samples/%s/fileupload";
  private static final String USERNAME = "cuc.collect.username";
  private static final String PASSWORD = "cuc.collect.password";
  private static final String SERVICE = "samplesvc";
  private static final String SSVC_FILENAME_VALID_KEY = "cuc.collect.samplesvc.valid.filename";
  private static final String SSVC_FILENAME_INVALID_KEY = "cuc.collect.samplesvc.invalid.filename";
  private static final String SSVC_FILENAME_MIN_KEY = "cuc.collect.samplesvc.min.filename";
  private static final String FILE_LOCATION_KEY = "cuc.collect.samplesvc.csv.location";
  private World world;
  private HTTPResponseAware responseAware;
  private final PostgresResponseAware postgresResponseAware;

  /**
   * Constructor - also gets singleton of http request runner.
   *
   * @param newWorld class with application and environment properties
   * @param dbResponseAware DB runner
   */
  public SampleSvcResponseAware(final World newWorld, final PostgresResponseAware dbResponseAware) {
    this.world = newWorld;
    this.responseAware = HTTPResponseAware.getInstance();
    responseAware.enableBasicAuth(world.getProperty(USERNAME), world.getProperty(PASSWORD));
    this.postgresResponseAware = dbResponseAware;
  }

  /**
   * Test post request for /samples/sampleunitrequests response
   *
   * @param properties to create json from
   * @throws IOException pass the exception
   * @throws AuthenticationException pass the exception
   */
  public void invokePostEndpoint(StringBuffer text, String key) throws IOException, AuthenticationException {
    String summaryId = postgresResponseAware.getSignalFieldFromRecord("id", "sample.samplesummary", key);
    text.append("\"sampleSummaryUUIDList\":[\"" + summaryId + "\"]");
    text.append("}");

    responseAware.invokePost(world.getUrl(POST_URL, SERVICE), text.toString(), ContentType.APPLICATION_JSON);
  }

  /**
   * Test get request for /info response
   *
   * @throws IOException pass the exception
   * @throws AuthenticationException pass the exception
   */
  public void invokeInfoEndpoint() throws IOException, AuthenticationException {
    responseAware.invokeGet(world.getUrl(INFO_URL, SERVICE));
  }
  
  /**
   * Move files to trigger the sample service for the survey type
   *
   * @param surveyType survey area to run
   * @param fileType currently either valid or invalid
   * @throws JSchException JSch exception
   * @throws SftpException SFTP exception
   * @throws IOException 
   * @throws AuthenticationException 
   */
  public void invokeSurveyFileEndpoint(String surveyName, String surveyType, String fileType) throws AuthenticationException, IOException {
    final String surveyLocation = String.format(world.getProperty(FILE_LOCATION_KEY), surveyType);
    String filename = constructFilename(surveyType, fileType);
    File file = new File(surveyLocation + filename);
    //FileInputStream input = new FileInputStream(file);
    //MultipartFile multipartFile = new MockMultipartFile(file.getName(),"text/plain", IOUtils.toByteArray(input));

    final String url = String.format(BRES_UPLOAD_URL, surveyName);

    responseAware.invokeFilePost(world.getUrl(url, SERVICE), file);
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
