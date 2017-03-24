package uk.gov.ons.ctp.ui.util;

import org.apache.commons.lang.NotImplementedException;
import org.openqa.selenium.By;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.chrome.ChromeDriver;
import org.openqa.selenium.firefox.FirefoxDriver;
import org.openqa.selenium.htmlunit.HtmlUnitDriver;

import com.gargoylesoftware.htmlunit.BrowserVersion;

import uk.gov.ons.ctp.ui.util.ro.pom.SignInResponseOperation;
import uk.gov.ons.ctp.util.World;

/**
 * Created by Stephen Goddard on 02/06/16.
 */
public abstract class SeleniumAware {
  private World world;
  private static WebDriver webDriver;

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
   * Initialise a new WebDriver instance
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
  }

  /**
   * Login to UI using the user
   *
   * @param user string representation of the user
   * @param browser string representation of the browser to be used
   */
  public void invokeUILogin(String user, String browser) {
    String username = "";
    String password = "";

    switch (user.toLowerCase()) {
      case "test":
        username = getWorld().getProperty("integration.test.username");
        password = getWorld().getProperty("integration.test.password");
        break;
      case "cso":
        username = getWorld().getProperty("integration.test.cso.username");
        password = getWorld().getProperty("integration.test.cso.password");
        break;
      case "general":
        username = getWorld().getProperty("integration.test.general.username");
        password = getWorld().getProperty("integration.test.general.password");
        break;
      case "field":
        username = getWorld().getProperty("integration.test.field.username");
        password = getWorld().getProperty("integration.test.field.password");
        break;
      case "report":
        username = getWorld().getProperty("integration.test.report.username");
        password = getWorld().getProperty("integration.test.report.password");
        break;
      case "error":
        username = getWorld().getProperty("integration.test.error.username");
        password = getWorld().getProperty("integration.test.error.password");
        break;
      default:
        username = getWorld().getProperty("integration.test.username");
        password = getWorld().getProperty("integration.test.password");
    }

    initialiseWebDriver(browser);

    invokeNavigateToPage(getWorld().getUiUrl("/signin"));

    SignInResponseOperation signIn = new SignInResponseOperation(webDriver);
    signIn.login(username, password);
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
   * Log out of UI
   */
  public void invokeLogout() {
    webDriver.findElement(By.id("signoutlink")).click();
  }

  /**
   * Tidy the WebDriver and close all open browser open windows
   */
  public void closeWebDriver() {
    webDriver.quit();
  }
}
