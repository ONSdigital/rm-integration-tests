package uk.gov.ons.ctp.response.samplesvc.steps;

import static org.junit.Assert.assertTrue;

import java.io.File;
import java.util.List;

import org.springframework.core.io.ClassPathResource;

import cucumber.api.java.en.Given;
import cucumber.api.java.en.Then;
import cucumber.api.java.en.When;
import uk.gov.ons.ctp.response.samplesvc.util.XsdValidator;
import uk.gov.ons.ctp.util.World;

/**
 * Created by stephen.goddard on 3/4/17.
 */
public class XsdValidationSteps {
  private static final String XSD_LOCATION_KEY = "cuc.collect.samplesvc.xsd.location";
  private static final String XML_LOCATION_KEY = "cuc.collect.samplesvc.xml.location";
  private String schemaFile;
  private String sourceFile;

  private final XsdValidator validator;
  private final World world;

  /**
   * Constructor - also sets the xsd validator
   *
   * @param newWorld class with application and environment properties
   */
  public XsdValidationSteps(World newWorld) {
    this.world = newWorld;
    validator = new XsdValidator(world.getProperty(XSD_LOCATION_KEY));
  }

  /**
   * Test the xsd schema is available
   *
   * @param fileName of xsd schema
   * @throws Throwable pass the exception
   */
  @Given("^xsd is available \"(.*?)\"$")
  public void xsd_is_available(String fileName) throws Throwable {
    schemaFile = world.getProperty(XSD_LOCATION_KEY) + fileName;
    assertTrue("XSD file does not exist: " + schemaFile, new ClassPathResource(schemaFile).exists());
  }

  /**
   * Test the source is available
   *
   * @param fileName of xml source
   * @throws Throwable pass the exception
   */
  @When("^xml is available \"(.*?)\"$")
  public void xml_is_available(String fileName) throws Throwable {
    sourceFile = world.getProperty(XML_LOCATION_KEY) + fileName;
    File file = new File(sourceFile);
    assertTrue("XML file does not exist: " + sourceFile, file.exists());
  }

  /**
   * Runs the validation
   *
   * @throws Throwable pass the exception
   */
  @Then("^Validate$")
  public void validate() throws Throwable {
    validator.Validate(schemaFile, sourceFile);
  }

  /**
   * Test the number of warnings generated by validation
   *
   * @param count number of warnings
   * @throws Throwable pass the exception
   */
  @Then("^the total number of warnings was (\\d+)$")
  public void the_total_number_of_warnings_was(int count) throws Throwable {
    int result = validator.getWarningsList().size();
    assertTrue("Number of warning messages does not match: " + result, result == count);
  }

  /**
   * Test the number of errors generated by validation
   *
   * @param count number of errors
   * @throws Throwable pass the exception
   */
  @Then("^the total number of errors was (\\d+)$")
  public void the_total_number_of_errors_was(int count) throws Throwable {
    System.out.println(validator.getErrorsList().toString());
    int result = validator.getErrorsList().size();
    assertTrue("Number of error messages does not match: " + result, result == count);
  }

  /**
   * Test the error message appear in list of errors from validation
   *
   * @param msg message to find
   * @throws Throwable pass the exception
   */
  @Then("^the error list should contain \"(.*?)\"$")
  public void the_error_list_should_contain(String msg) throws Throwable {
    boolean result = isMessageFoundInList(validator.getErrorsList(), msg);
    assertTrue("Error messages not found: ", result);
  }

  /**
   * Searches list for message
   *
   * @param list to be searched
   * @param msg message to find
   * @return boolean for search found
   */
  private boolean isMessageFoundInList(List<String> list, String msg) {
    boolean result = false;
    for (String errorMsg: list) {
      result = errorMsg.contains(msg);
      if (result) {
        break;
      }
    }
    return result;
  }
}
