package uk.gov.ons.ctp.util;

//import java.util.concurrent.TimeUnit;

import org.apache.commons.lang.NotImplementedException;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.chrome.ChromeDriver;
import org.openqa.selenium.firefox.FirefoxDriver;
import org.openqa.selenium.htmlunit.HtmlUnitDriver;

import com.gargoylesoftware.htmlunit.BrowserVersion;

/**
 * Created by Stephen Goddard on 02/06/16.
 */
public abstract class SeleniumAware {
//  private static final long DELAY_IN_SECONDS = 120;
  private World world;
  protected static WebDriver webDriver;

  /**
   * Constructor
   *
   * @param newWorld class with application and environment properties
   */
  public SeleniumAware(final World newWorld) {
    this.world = newWorld;
  }

  /**
   * Get world
   *
   * @return World class with application and environment properties
   */
  public World getWorld() {
    return world;
  }

  /**
   * Get web driver
   *
   * @return WebDriver to run browser actions
   */
  public WebDriver getWebDriver() {
    return webDriver;
  }

  /**
   * Initialize a new WebDriver instance
   *
   * @param browser string representation of the browser to be used
   */
  public void initialiseWebDriver(String browser) {
    switch (browser.toLowerCase()) {
    case "chrome":
      webDriver = new HtmlUnitDriver(BrowserVersion.CHROME, true);
      break;
    case "firefox":
      webDriver = new HtmlUnitDriver(BrowserVersion.FIREFOX_38, true);
      break;
    case "test":
      webDriver = new FirefoxDriver();
      break;
    case "chromehead":
      webDriver = new ChromeDriver();
      break;
    default:
      throw new NotImplementedException("No valid browser specified");
    }
//    webDriver.manage().timeouts().implicitlyWait(DELAY_IN_SECONDS, TimeUnit.SECONDS);
  }

  /**
   * Navigate to specified page
   *
   * @param url go to page
   */
  public void invokeNavigateToPage(String url) {
    webDriver.get(url);
  }

  /**
   * Tidy the WebDriver and close all open browser open windows
   */
  public void closeWebDriver() {
    webDriver.quit();
  }
}
