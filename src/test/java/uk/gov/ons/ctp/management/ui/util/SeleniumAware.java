package uk.gov.ons.ctp.management.ui.util;

import org.apache.commons.lang.NotImplementedException;
import org.openqa.selenium.By;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.chrome.ChromeDriver;
import org.openqa.selenium.firefox.FirefoxDriver;
import org.openqa.selenium.htmlunit.HtmlUnitDriver;

import com.gargoylesoftware.htmlunit.BrowserVersion;

import uk.gov.ons.ctp.ui.rm.ro.pom.SignInPom;
import uk.gov.ons.ctp.util.World;

/**
 * Created  Chris Hardman on 18/08/17
 */
public abstract class SeleniumAware {
  private static final String CHROME_DRIVER_LOC_KEY = "cuc.collect.ui.chrome.driver.location";
  private static final String USERNAME_KEY = "integration.test.username";
  private static final String PASSWORD_KEY = "integration.test.password";
  private static final String SIGNIN_URL = "/signin";
  private static final String SERVICE = "ui";
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
      System.setProperty("webdriver.chrome.driver", world.getProperty(CHROME_DRIVER_LOC_KEY));
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
    String username = getWorld().getProperty(USERNAME_KEY);
    String password = getWorld().getProperty(PASSWORD_KEY);

    initialiseWebDriver(browser);

    invokeNavigateToPage(world.getUrl(SIGNIN_URL, SERVICE));

    SignInPom signIn = new SignInPom(webDriver);
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
