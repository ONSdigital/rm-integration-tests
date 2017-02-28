package uk.gov.ons.ctp.response.sdx.steps;

import java.io.File;
import java.io.PrintWriter;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.List;
import java.util.Properties;

import org.apache.commons.io.FileUtils;

import com.jayway.jsonpath.JsonPath;

import cucumber.api.DataTable;
import cucumber.api.java.en.Given;
import cucumber.api.java.en.Then;
import cucumber.api.java.en.When;
import uk.gov.ons.ctp.response.casesvc.util.CaseResponseAware;
import uk.gov.ons.ctp.response.sdx.util.SdxGatewayResponseAware;

/**
 * Created by Stephen Goddard on 30/9/16.
 */
public class SdxGatewaySteps {
  private final SdxGatewayResponseAware responseAware;
  private final CaseResponseAware caseResponseAware;

  /**
   * Constructor
   *
   * @param sdxResponseAware SDX Gateway end point runner
   * @param caseSvcResponseAware casesvc end point runner
   */
  public SdxGatewaySteps(SdxGatewayResponseAware sdxResponseAware, CaseResponseAware caseSvcResponseAware) {
    this.responseAware = sdxResponseAware;
    this.caseResponseAware = caseSvcResponseAware;
  }

  /**
   * Test post request for /questionnairereceipts
   *
   * @param caseRef case reference
   * @throws Throwable pass the exception
   */
  @When("^I make the POST call to the SDX Gateway online receipt for caseref \"(.*?)\"$")
  public void i_make_the_POST_call_to_the_SDX_Gateway_online_receipt_for_caseref(String caseRef) throws Throwable {
    Properties properties = new Properties();
    properties.put("caseRef", caseRef);
    responseAware.invokeSdxReceiptEndpoint(properties);
  }

  /**
   * Test post request for /questionnairereceipts where caseRef is taken from a previous get
   *
   * @throws Throwable pass the exception
   */
  @Then("^I make the POST call to the SDX Gateway online receipt for current case$")
  public void i_make_the_POST_call_to_the_SDX_Gateway_online_receipt_for_current_case() throws Throwable {
    String caseRef = JsonPath.read(caseResponseAware.getBody(), "$." + "caseRef");
    System.out.println(caseRef);

    Properties properties = new Properties();
    properties.put("caseRef", caseRef);
    responseAware.invokeSdxReceiptEndpoint(properties);
  }

  /**
   * Test post request for /questionnairereceipts - missing caseref
   *
   * @throws Throwable pass the exception
   */
  @When("^I make the POST call to the SDX Gateway online receipt for missing caseref$")
  public void i_make_the_POST_call_to_the_SDX_Gateway_online_receipt_for_missing_caseref() throws Throwable {
    Properties properties = new Properties();
    properties.put("caseRef", "");
    responseAware.invokeSdxReceiptEndpoint(properties);
  }

  /**
   * Test post request for /questionnairereceipts - invalid input
   *
   * @throws Throwable pass the exception
   */
  @When("^I make the POST call to the SDX Gateway online receipt for invalid input$")
  public void i_make_the_POST_call_to_the_SDX_Gateway_online_receipt_for_invalid_input() throws Throwable {
    Properties properties = new Properties();
    properties.put("input", "invalid input value");
    responseAware.invokeSdxReceiptEndpoint(properties);
  }

  /**
   * Test post request for /paperQuestionnairereceipts
   *
   * @param content to be in csv file
   * @throws Throwable pass the exception
   */
  @When("^I make the POST call to the SDX Gateway paper receipt for$")
  public void i_make_the_POST_call_to_the_SDX_Gateway_paper_receipt_for(DataTable content) throws Throwable {
    List<String> formContent = content.asList(String.class);

    File file = new File("cucumberTest.csv");
    List<String> lines = new ArrayList<String>();
    for (int i = 0; i < formContent.size(); i++) {
      lines.add(formContent.get(i));
    }
    FileUtils.writeLines(file, lines);

    responseAware.invokeSdxPaperReceiptEndpoint(file);

    FileUtils.deleteQuietly(file);
  }

  /**
   * Test post request for /paperQuestionnairereceipts with an empty file.
   * NOTE: when java creates a file it contains a single character so this is removed.
   *
   * @throws Throwable pass the exception
   */
  @When("^I make the POST call to the SDX Gateway paper receipt for empty file$")
  public void i_make_the_POST_call_to_the_SDX_Gateway_paper_receipt_for_empty_file() throws Throwable {
    File file = new File("cucumberTest.csv");
    PrintWriter writer = new PrintWriter(file);
    writer.print("");
    writer.close();

    responseAware.invokeSdxPaperReceiptEndpoint(file);

    FileUtils.deleteQuietly(file);
  }

  /**
   * Test post request for /paperQuestionnairereceipts
   *
   * @param caseRef case reference
   * @throws Throwable pass the exception
   */
  @Given("^I make the POST call to the SDX Gateway paper receipt for caseref \"(.*?)\"$")
  public void i_make_the_POST_call_to_the_SDX_Gateway_paper_receipt_for_caseref(String caseRef) throws Throwable {
    File file = new File("cucumberTest.csv");
    List<String> lines = new ArrayList<String>();

    Calendar cal = Calendar.getInstance();
    cal.setTime(new Date());
    Timestamp time = new Timestamp(cal.getTime().getTime());
    lines.add(time + "," + caseRef);

    FileUtils.writeLines(file, lines);

    responseAware.invokeSdxPaperReceiptEndpoint(file);

    FileUtils.deleteQuietly(file);
  }
}
