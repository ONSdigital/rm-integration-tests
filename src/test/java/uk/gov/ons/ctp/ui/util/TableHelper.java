package uk.gov.ons.ctp.ui.util;

import java.util.List;

import org.openqa.selenium.By;
import org.openqa.selenium.WebElement;

/**
 * Created by Stephen Goddard on 20/03/17.
 */
public class TableHelper {

  /**
   * Helper method to get row from table for search string
   *
   * @param table to be searched
   * @param search criteria to be found
   * @return WebElement for selected row
   */
  public WebElement navigateToTableRowBySearch(WebElement table, String search) {
    WebElement element = null;
    boolean found = false;

    List<WebElement> trCollection = table.findElements(By.xpath("//table/tbody/tr"));

    for (WebElement trElement : trCollection) {
      List<WebElement> tdCollection = trElement.findElements(By.xpath("td"));
      for (WebElement tdElement : tdCollection) {

        found = tdElement.getText().equalsIgnoreCase(search);
        if (found) {
          element = trElement;
          break;
        }
      }
      if (found) {
        break;
      }
    }
    return element;
  }

  /**
   * Extract a value from first data row of a table
   *
   * @param table to be interrogated
   * @param rowNumber Integer row number in the table, excluding the header
   * @param columnNumber Integer column number in the row
   * @return String cell value
   */
  public String extractValueFromTable(WebElement table, int rowNumber, int columnNumber) {
    WebElement tableBody = table.findElement(By.tagName("tbody"));

    List<WebElement> rows = tableBody.findElements(By.tagName("tr"));
    WebElement row = rows.get(rowNumber - 1);
    List<WebElement> values = row.findElements(By.tagName("td"));

    return values.get(columnNumber - 1).getText();
  }
}
