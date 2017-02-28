package uk.gov.ons.ctp.response.casesvc.steps;

import cucumber.api.java.en.When;
import uk.gov.ons.ctp.response.casesvc.util.CaseResponseAware;

/**
 * Created by Stephen Goddard on 18/3/16.
 */
public class CategoriesSteps {
  private final CaseResponseAware responseAware;

  /**
   * Constructor
   *
   * @param caseResponseAware case frame end point runner
   */
  public CategoriesSteps(CaseResponseAware caseResponseAware) {
    this.responseAware = caseResponseAware;
  }

  /**
   * Test get request for /categories
   *
   * @throws Throwable pass the exception
   */
  @When("^I make the GET call to the caseservice for categories$")
  public void i_make_the_GET_call_to_the_caseservice_for_categories() throws Throwable {
    responseAware.invokeCategoriesEndpoint();
  }

  /**
   * Test get request for /categories/{categoryName}
   *
   * @param categoryName category id
   * @throws Throwable pass the exception
   */
  @When("^I make the GET call to the caseservice for category \"(.*?)\"$")
  public void i_make_the_GET_call_to_the_caseservice_for_category(String categoryName) throws Throwable {
    responseAware.invokeCategoriesEndpoint(categoryName);
  }

}
