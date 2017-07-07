package uk.gov.ons.ctp.response.common.steps;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertNotNull;
import static org.junit.Assert.assertNull;
import static org.junit.Assert.assertTrue;

//import java.io.File;
import java.math.BigDecimal;
import java.util.LinkedHashMap;
import java.util.regex.Pattern;

import com.jayway.jsonpath.JsonPath;
//import org.codehaus.plexus.util.FileUtils;

import cucumber.api.java.en.Given;
import cucumber.api.java.en.Then;
//import cucumber.api.java.en.When;
import net.minidev.json.JSONArray;
import uk.gov.ons.ctp.util.HTTPResponseAware;
import uk.gov.ons.ctp.util.World;

/**
 * Created by philippe.brossier on 28/01/16. Moved by Stephen Goddard on
 * 14/3/16.
 */
public class CommonSteps {
  private static final Double DELTA = 1E-14;
  private static final int MILLI_TO_SECONDS = 1000;
  private static final String BASIC_AUTH_USERNAME_PROPERTY_KEY = "cuc.basic.auth.username";
  private static final String BASIC_AUTH_PASSWORD_PROPERTY_KEY = "cuc.basic.auth.password";

  private final HTTPResponseAware responseAware;
  private final World world;
//  private File fileContent;

  /**
   * Constructor - also gets singleton of http request runner
   *
   * @param newWorld class with application and environment properties
   */
  public CommonSteps(World newWorld) {
    this.responseAware = HTTPResponseAware.getInstance();
    this.world = newWorld;
  }

  /**
   * Test response status matches feature value
   *
   * @param status value from scenario in feature
   * @throws Throwable pass the exception
   */
  @Then("^the response status should be (\\d+)$")
  public void the_response_status_should_be(int status) throws Throwable {
    System.out.println("responseAware.getStatus() = " + responseAware.getStatus());
    assertEquals(status, responseAware.getStatus());
  }

  /**
   * Test response should contain the value from feature
   *
   * @param value from scenario in feature
   * @throws Throwable pass the exception
   */
  @Then("^the response should contain \"(.*?)\"$")
  public void the_response_should_contain(String value) throws Throwable {
    assertTrue("Response does not match: " + responseAware.getBody(), responseAware.getBody().contains(value));
  }

  /**
   * Test response should contain the field from feature
   *
   * @param field value from scenario in feature
   * @throws Throwable pass the exception
   */
  @Then("^the response should contain the field \"([^\"]*)\"$")
  public void the_response_should_contain_the_field(String field) throws Throwable {
    assertNotNull(JsonPath.read(responseAware.getBody(), "$." + field));
  }

  /**
   * Test response should contain the field from feature containing a value
   *
   * @param field value from scenario in feature
   * @param value the value that field should contain
   * @throws Throwable pass the exception
   */
  @Then("^the response should contain the field \"([^\"]*)\" with contents \"([^\"]*)\"$")
  public void the_response_should_contain_the_field_with_contents(String field, String value) throws Throwable {
    String[] json = responseAware.getBody().split("\",\"");
    int i = 0;
    while (!json[i].contains(field)) {
      i++;
    }
    assertTrue(json[i].contains(value));
  }

  /**
   * Test response should contain the field with string value from feature
   *
   * @param field from scenario in feature
   * @param value from scenario in feature to be matched
   * @throws Throwable pass the exception
   */
  @Then("^the response should contain the field \"([^\"]*)\" with value \"([^\"]*)\"$")
  public void the_response_should_contain_the_field_with_value(String field, String value) throws Throwable {
    assertEquals(value, JsonPath.read(responseAware.getBody(), "$." + field));
  }

  /**
   * Test response should contain the field with null value from feature
   *
   * @param field from scenario in feature
   * @throws Throwable pass the exception
   */
  @Then("^the response should contain the field \"([^\"]*)\" with a null value$")
  public void the_response_should_contain_the_field_with_null_value(String field) throws Throwable {
    assertNull(JsonPath.read(responseAware.getBody(), "$." + field));
  }

  /**
   * Test response should contain the field with regex from feature
   *
   * @param field from scenario in feature
   * @param regex from scenario in feature to be matched
   * @throws Throwable pass the exception
   */
  @Then("^the response should contain the field \"([^\"]*)\" with value matching the regex \"([^\"]*)\"")
  public void the_response_should_contain_the_field_with_value_matching_pattern(String field, String regex)
      throws Throwable {
    String jsonString = JsonPath.read(responseAware.getBody(), "$." + field);
    Pattern pattern = Pattern.compile(regex, Pattern.CASE_INSENSITIVE | Pattern.DOTALL);
    assertTrue(pattern.matcher(jsonString).matches());
  }

  /**
   * Test response should contain the field from feature with integer value
   *
   * @param field from scenario in feature
   * @throws Throwable pass the exception
   */
  @Then("^the response should contain the field \"([^\"]*)\" with an integer value$")
  public void the_response_should_contain_the_field_with_integer_value(String field) throws Throwable {
    Object obj = JsonPath.read(responseAware.getBody(), "$." + field);
    assertTrue(obj instanceof Integer);
  }

  /**
   * Test response should contain the field with integer from feature
   *
   * @param field from scenario in feature
   * @param value from scenario in feature to be matched
   * @throws Throwable pass the exception
   */
  @Then("^the response should contain the field \"([^\"]*)\" with an integer value of ([^\"]*)$")
  public void the_response_should_contain_the_field_with_integer_value_of(String field, int value) throws Throwable {
    Object obj = JsonPath.read(responseAware.getBody(), "$." + field);

    Integer retrievedValue = (Integer) obj;
    assertTrue(obj instanceof Integer);
    assertEquals(value, retrievedValue.intValue());
  }

  /**
   * Test response should contain the field from feature with long value
   *
   * @param field from scenario in feature
   * @throws Throwable pass the exception
   */
  @Then("^the response should contain the field \"([^\"]*)\" with a long value$")
  public void the_response_should_contain_the_field_with_long_value(String field) throws Throwable {
    Object obj = JsonPath.read(responseAware.getBody(), "$." + field);
    assertTrue(obj instanceof Long);
  }

  /**
   * Test response should contain the field with long from feature
   *
   * @param field from scenario in feature
   * @param value from scenario in feature to be matched
   * @throws Throwable pass the exception
   */
  @Then("^the response should contain the field \"([^\"]*)\" with a long value of ([^\"]*)$")
  public void the_response_should_contain_the_field_with_long_value_of(String field, long value) throws Throwable {
    Object obj = JsonPath.read(responseAware.getBody(), "$." + field);
    assertTrue(obj instanceof Long);

    Long retrievedValue = (Long) obj;
    assertEquals(value, retrievedValue.longValue());
  }

  /**
   * Test response should contain the field with double from feature
   *
   * @param field from scenario in feature
   * @param value from scenario in feature to be matched
   * @throws Throwable pass the exception
   */
  @Then("^the response should contain the field \"([^\"]*)\" with a double value of ([^\"]*)$")
  public void the_response_should_contain_the_field_with_double_value_of(String field, double value)
      throws Throwable {
    Object obj = JsonPath.read(responseAware.getBody(), "$." + field);
    assertTrue(obj instanceof Double);

    Double retrievedValue = (Double) obj;
    assertEquals(value, retrievedValue.doubleValue(), DELTA);
  }

  /**
   * Test response should contain the field with BigDecimal from feature
   *
   * @param field from scenario in feature
   * @param value from scenario in feature to be matched
   * @throws Throwable pass the exception
   */
  @Then("^the response should contain the field \"([^\"]*)\" with a BigDecimal value of ([^\"]*)$")
  public void the_response_should_contain_the_field_with_BigDecimal_value_of(String field, BigDecimal value)
      throws Throwable {
    Object obj = JsonPath.read(responseAware.getBody(), "$." + field);
    assertTrue(obj instanceof BigDecimal);

    BigDecimal retrievedValue = (BigDecimal) obj;
    int result = retrievedValue.compareTo(value);
    assertTrue(result == 0);
  }

  /**
   * Test response should contain the field from feature with string value
   *
   * @param field from scenario in feature
   * @throws Throwable pass the exception
   */
  @Then("^the response should contain the field \"([^\"]*)\" with a String value$")
  public void the_response_should_contain_the_field_with_string_value(String field) throws Throwable {
    Object obj = JsonPath.read(responseAware.getBody(), "$." + field);
    assertTrue(obj instanceof String);
  }

  /**
   * Test response should contain a JSON array with size from feature
   *
   * @param value array size from scenario in feature
   * @throws Throwable pass the exception
   */
  @Then("^the response should contain a JSON array of size ([^\"]*)$")
  public void the_response_should_contain_json_array_of_size(int value) throws Throwable {
    Object obj = JsonPath.read(responseAware.getBody(), "$");
    assertTrue(obj instanceof JSONArray);

    JSONArray jsonArray = (JSONArray) obj;
    assertEquals(value, jsonArray.size());
  }

  /**
   * Test response should contain a JSON element with value from feature
   *
   * @param value element from scenario in feature
   * @throws Throwable pass the exception
   */
  @Then("^one element of the JSON array must be (.*)$")
  public void one_element_of_the_json_array_must_be(String value) throws Throwable {
    JSONArray jsonArray = (JSONArray) JsonPath.read(responseAware.getBody(), "$");
    String arrayString = jsonArray.toJSONString();
    assertTrue(arrayString.contains(value));
  }

  /**
   * Test authentication
   *
   * @throws Throwable pass the exception
   */
  @Given("^valid basic authentication credentials are provided$")
  public void valid_basic_authentication_credentials_are_provided() throws Throwable {
    responseAware.enableBasicAuth(world.getProperty(BASIC_AUTH_USERNAME_PROPERTY_KEY),
        world.getProperty(BASIC_AUTH_PASSWORD_PROPERTY_KEY));
  }

  /**
   * Test response should contain the field from feature with boolean value
   *
   * @param field from scenario in feature
   * @param value of boolean to be tested against
   * @throws Throwable pass the exception
   */
  @Then("^the response should contain the field \"(.*?)\" with boolean value \"(.*?)\"$")
  public void the_response_should_contain_the_field_with_boolean_value(String field, Boolean value) throws Throwable {
    Object obj = JsonPath.read(responseAware.getBody(), "$." + field);
    assertTrue(obj instanceof Boolean);

    Boolean retrievedValue = (Boolean) obj;
    int result = retrievedValue.compareTo(value);
    assertTrue(result == 0);
  }

  /**
   * Test response should contain the field with array size from feature
   *
   * @param field from scenario in feature
   * @param size array from scenario in feature to be matched
   * @throws Throwable pass the exception
   */
  @Then("^the response should contain the field \"(.*?)\" with JSON array of size (\\d+)$")
  public void the_response_should_contain_the_field_with_JSON_array_of_size(String field, int size) throws Throwable {
    Object obj = JsonPath.read(responseAware.getBody(), "$." + field);
    assertTrue(obj instanceof JSONArray);

    JSONArray jsonArray = (JSONArray) obj;
    assertEquals(size, jsonArray.size());
  }

  /**
   * Test response should contain the field with array where the value of one
   * element should match from feature
   *
   * @param field from scenario in feature
   * @param value element from scenario in feature to be matched
   * @throws Throwable pass the exception
   */
  @Then("^the response should contain the field \"(.*?)\" with one element of the JSON array must be (.*)$")
  public void the_response_should_contain_the_field_with_one_element_of_the_JSON_array_must_be(String field,
      String value) throws Throwable {
    JSONArray jsonArray = (JSONArray) JsonPath.read(responseAware.getBody(), "$." + field);
    String arrayString = jsonArray.toJSONString();
    assertTrue(arrayString.contains(value));
  }

  /**
   * Test response should contain the field with list where the value should
   * match from feature
   *
   * @param field from scenario in feature
   * @param value element from scenario in feature to be matched
   * @throws Throwable pass the exception
   */
  @Then("^the response should contain the field \"(.*?)\" with list value \"(.*?)\"$")
  public void the_response_should_contain_the_field_with_list_value(String field, String value) throws Throwable {
    LinkedHashMap<?, ?> listArray = JsonPath.read(responseAware.getBody(), "$." + field);
    String listString = listArray.toString();
    assertTrue("List not match: " + listString, listString.contains(value));
  }

  /**
   * Test response should be of a specified length
   *
   * @param length of response to be tested against
   * @throws Throwable pass the exception
   */
  @Then("^the response length should be (\\d+) characters$")
  public void the_response_length_should_be_characters(int length) throws Throwable {
    String response = responseAware.getBody();
    assertTrue("Test length does not match response length: " + response, response.length() == length);
  }

  /**
   * Utility which adds a delay in the test flow
   *
   * @param seconds to be delay
   * @throws Throwable pass the exception
   */
  @Then("^after a delay of (\\d+) seconds$")
  public void after_a_delay_of_seconds(int seconds) throws Throwable {
    System.out.format("About to wait for %d seconds...", seconds);
    Thread.sleep(seconds * MILLI_TO_SECONDS);
  }

//  /**
//   * Utility which adds file reader
//   *
//   * @param location file location
//   * @param fileName file name
//   * @throws Throwable pass the exception
//   */
//  @Given("^get the contents of local file from \"(.*?)\" where the filename begins \"(.*?)\"$")
//  public void Get_the_contents_of_local_file_from_where_the_filename_begins(String location, String fileName)
//      throws Throwable {
//    fileContent = new File(location + "/" + fileName);
//    assertTrue("file does not exist: ", fileContent.exists());
//  }

//  /**
//   * Confirm the down loaded file contains corrected details
//   *
//   * @param location file location
//   * @param fileName file name
//   * @throws Throwable pass the exception
//   */
//  @When("^the contents of the file should equal \"(.*?)\" where the filename begins \"(.*?)\"$")
//  public void the_contents_of_the_file_should_equal_where_the_filename_begins(String location, String fileName)
//      throws Throwable {
//    File fileTest = new File(location + "/" + fileName);
//    assertTrue("file does not match downloaded file", FileUtils.contentEquals(fileContent, fileTest));
//  }

//  /**
//   * Utility which remove file from a location
//   *
//   * @param location file location
//   * @throws Throwable pass the exception
//   */
//  @Then("^remove file from \"(.*?)\"$")
//  public void remove_file_from(String location) throws Throwable {
//    fileContent.delete();
//  }
}
