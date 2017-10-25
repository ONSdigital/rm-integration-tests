package uk.gov.ons.ctp.ui.util;

import java.util.ArrayList;
import java.util.List;

import org.openqa.selenium.By;
import org.openqa.selenium.WebElement;

/**
 * Created  Chris Hardman on 18/08/17
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
   * count number of rows within a table
   *
   * @param table to be interrogated
   * @return int number of rows
   */
  public int extractNumberOfRowsFromTable(WebElement table) {
    List<WebElement> rows = table.findElements(By.tagName("tr"));
    return rows.size();
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
    List<WebElement> rows = table.findElements(By.tagName("tr"));
    WebElement row = rows.get(rowNumber);
    List<WebElement> values = row.findElements(By.tagName("td"));

    return values.get(columnNumber).getText();
  }

  /**
   * Extract all values from a table column
   *
   * @param table to be interrogated
   * @param columnNumber to extract values from
   * @return List of values
   */
  public List<String> extractColumnValuesFromTable(WebElement table, int columnNumber) {
    List<String> columnValues = new ArrayList<String>();

    List<WebElement> tableBody = table.findElements(By.tagName("tr"));


    for (WebElement row: tableBody) {
      List<WebElement> values = row.findElements(By.tagName("td"));
      if (values.size() != 0) {
        WebElement rowContent = values.get(columnNumber - 1);
        columnValues.add(rowContent.getText());
      }
    }
    return columnValues;
  }

  /**
   * Extract the heading from the table
   *
   * @param table to be interrogated
   * @return List of headings
   */
  public List<String> extractHeadingsFromTable(WebElement table) {
    List<String> headings = new ArrayList<String>();
    List<WebElement> trCollection = table.findElements(By.xpath("//table/thead/tr"));

    for (WebElement trElement : trCollection) {
      List<WebElement> tdCollection = trElement.findElements(By.xpath("th"));
      for (WebElement thElement : tdCollection) {
        headings.add(thElement.getText());
      }
    }
    return headings;
  }
}
