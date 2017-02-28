package uk.gov.ons.ctp.response.iacsvc.steps;

import java.util.Properties;

import cucumber.api.java.en.Then;
import cucumber.api.java.en.When;
import uk.gov.ons.ctp.response.iacsvc.util.IacsvcResponseAware;

/**
 * Created by Stephen Goddard on 04/10/16.
 */
public class IacsvcSteps {
  private final IacsvcResponseAware responseAware;

  /**
   * Constructor
   *
   * @param iacsvcResponseAware iac service end point runner
   */
  public IacsvcSteps(IacsvcResponseAware iacsvcResponseAware) {
    this.responseAware = iacsvcResponseAware;
  }

  /**
   * Test post request for /iacs response
   *
   * @param count number of iac to be created
   * @throws Throwable pass the exception
   */
  @When("^I make the POST call to the iacsvc endpoint for count (.*?)$")
  public void i_make_the_POST_call_to_the_iacsvc_endpoint_for_count(int count) throws Throwable {
    Properties properties = new Properties();
    properties.put("count", count);
    properties.put("createdBy", "Cucumber Test");

    responseAware.invokePostIacEndpoint(properties);
  }

  /**
   * Test post request for /iacs response for invalid input
   *
   * @throws Throwable pass the exception
   */
  @When("^I make the POST call to the iacsvc endpoint with invalid input$")
  public void i_make_the_POST_call_to_the_iacsvc_endpoint_with_invalid_input() throws Throwable {
    Properties properties = new Properties();
    properties.put("input", "invalid input value");

    responseAware.invokePostIacEndpoint(properties);
  }

  /**
   * Test get request for /iacs/{iacs} response
   *
   * @param iac code to get details for
   * @throws Throwable pass the exception
   */
  @When("^I make the GET call to the iacsvc endpoint for IAC \"(.*?)\"$")
  public void i_make_the_GET_call_to_the_iacsvc_endpoint_for_IAC(String iac) throws Throwable {
    responseAware.invokeGetIacEndpoint(iac);
  }

  /**
   * Test get request for /iacs/{iacs} response when a previous call to case endpoint has retrieved an iac
   *
   * @throws Throwable pass the exception
   */
  @Then("^I make the GET call to the IAC service endpoint$")
  public void i_make_the_GET_call_to_the_IAC_service_endpoint() throws Throwable {
    String iac = responseAware.getIACFromPreviousResponse();
    responseAware.invokeGetIacEndpoint(iac);
  }

  /**
   * Test put request for /iacs/{iacs} response
   * Note: a previous run to get case is required so an IAC is available to test
   *
   * @throws Throwable pass the exception
   */
  @Then("^I make the PUT call to the IAC service endpoint$")
  public void i_make_the_PUT_call_to_the_IAC_service_endpoint() throws Throwable {
    String iac = responseAware.getIACFromPreviousResponse();

    System.out.println("IAC: " + iac);
    Properties properties = new Properties();
    properties.put("updatedBy", "Cucumber Test");
    System.out.println("Properties: " + properties);

    responseAware.invokePutIacEndpoint(iac, properties);
  }

  /**
   * Test put request for /iacs/{iacs} response for invalid input
   *
   * @throws Throwable pass the exception
   */
  @When("^I make the PUT call to the iacsvc endpoint with invalid input$")
  public void i_make_the_PUT_call_to_the_iacsvc_endpoint_with_invalid_input() throws Throwable {
    Properties properties = new Properties();
    properties.put("input", "invalid input value");

    responseAware.invokePutIacEndpoint(properties);
  }
}
