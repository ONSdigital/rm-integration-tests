package uk.gov.ons.ctp.ui.rm.ro.util;

import org.openqa.selenium.WebElement;

import uk.gov.ons.ctp.ui.rm.ro.pom.HomePOM;
import uk.gov.ons.ctp.ui.rm.ro.pom.ReportingUnitPOM;
import uk.gov.ons.ctp.ui.util.SeleniumAware;
import uk.gov.ons.ctp.ui.util.TableHelper;
import uk.gov.ons.ctp.util.World;

/**
 * Created by Stephen Goddard on 09/10/17.
 *
 */
public class UIResponseOperationsResponseAware extends SeleniumAware {

  /**
   * Constructor
   *
   * @param newWorld class with application and environment properties
   */
  public UIResponseOperationsResponseAware(final World newWorld) {
    super(newWorld);
  }

  /**
   * Navigate to the reporting unit page
   *
   * @param ruRef reporting unit to navigate to
   */
  public void navigateToRuRefPageForRef(String ruRef) {
    HomePOM homePage = new HomePOM(getWebDriver());
    homePage.ruRefSearch(ruRef);
  }

  /**
   * Get reporting unit reference
   *
   * @return reporting unit reference
   */
  public String getRUReference() {
    ReportingUnitPOM ruPage = new ReportingUnitPOM(getWebDriver());
    return ruPage.getRUReference();
  }

  /**
   * Get reporting company name
   *
   * @return company name
   */
  public String getName() {
    ReportingUnitPOM ruPage = new ReportingUnitPOM(getWebDriver());
    return ruPage.getName();
  }

  /**
   * Get reporting trading name
   *
   * @return trading name
   */
  public String getTradingName() {
    ReportingUnitPOM ruPage = new ReportingUnitPOM(getWebDriver());
    return ruPage.getTradingName();
  }

  /**
   * Determine if value is present on the event table
   *
   * @param eventValue to be found on table
   * @return result as boolean
   */
  public boolean isValueFoundInEventTable(String eventValue) {
    ReportingUnitPOM ruPage = new ReportingUnitPOM(getWebDriver());
    WebElement table = ruPage.getEventTable();

    TableHelper helper = new TableHelper();
    WebElement result = helper.navigateToTableRowBySearch(table, eventValue);

    return result != null;
  }

  /**
   * Determine if value is present on the action table
   *
   * @param actionValue to be found on table
   * @return result as boolean
   */
  public boolean isValueFoundInActionTable(String actionValue) {
    ReportingUnitPOM ruPage = new ReportingUnitPOM(getWebDriver());
    WebElement table = ruPage.getActionTable();

    TableHelper helper = new TableHelper();
    WebElement result = helper.navigateToTableRowBySearch(table, actionValue);

    return result != null;
  }
}
