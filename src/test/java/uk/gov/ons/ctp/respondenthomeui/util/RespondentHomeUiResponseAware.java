package uk.gov.ons.ctp.respondenthomeui.util;

import java.util.logging.Level;

import org.apache.commons.lang.NotImplementedException;
import org.openqa.selenium.By;
import org.openqa.selenium.NoSuchElementException;
import org.openqa.selenium.htmlunit.HtmlUnitDriver;

import com.gargoylesoftware.htmlunit.BrowserVersion;

import uk.gov.ons.ctp.ui.util.SeleniumAware;
import uk.gov.ons.ctp.util.World;

/**
 * Created by Edward Stevens on 17/11/16.
 */
public class RespondentHomeUiResponseAware extends SeleniumAware {

  // Able to run tests in headless browser by changing from WebDriver to
  // HtmlUnitDriver
  private HtmlUnitDriver webDriver;
  private static final long DELAY_IN_MILLISECONDS = 5000;

  /**
   * Constructor
   *
   * @param newWorld class with application and environment properties
   */
  public RespondentHomeUiResponseAware(World newWorld) {
    super(newWorld);
  }

  /**
   * Initialise browser and login to UI.
   *
   * @param browser string representation of the browser to be used
   */
  public void invokeInitialNavigation(String browser) {
    // Removes verbose CSS logging
    java.util.logging.Logger.getLogger("com.gargoylesoftware").setLevel(Level.OFF);
    java.util.logging.Logger.getLogger("org.apache.commons.httpclient").setLevel(Level.OFF);

    if (browser.equalsIgnoreCase("Firefox")) {
      webDriver = new HtmlUnitDriver(BrowserVersion.FIREFOX_38, true);
      webDriver.setJavascriptEnabled(false);
    } else if (browser.equalsIgnoreCase("Chrome")) {
      webDriver = new HtmlUnitDriver(BrowserVersion.CHROME, true);
      webDriver.setJavascriptEnabled(false);
    } else {
      throw new NotImplementedException("No browser specified");
    }
    // webDriver.manage().timeouts().implicitlyWait(DELAY_IN_SECONDS,
    // TimeUnit.SECONDS);

    webDriver.get("http://192.168.12.138");
  }

  /**
   * Enter and submit IAC.
   *
   * @param iac1 IAC Part 1
   * @param iac2 IAC Part 2
   * @param iac3 IAC Part 3
   */
  public void invokeIACEntry(String iac1, String iac2, String iac3) {
    webDriver.findElement(By.name("iac1")).sendKeys(iac1);
    webDriver.findElement(By.name("iac2")).sendKeys(iac2);
    webDriver.findElement(By.name("iac3")).sendKeys(iac3);
    webDriver.findElement(By.xpath("//input[@type='submit']")).click();
  }

  /**
   * Enter and submit IAC consecutively until limit is reached
   *
   * @param iac1 IAC Part 1
   * @param iac2 IAC Part 2
   * @param iac3 IAC Part 3
   * @throws java.lang.InterruptedException pass the exception
   */
  public void invokeMultipleIACEntry(String iac1, String iac2, String iac3) throws InterruptedException {
    while (true) {

      if (ifElementExists(By.xpath("//input[@name='iac1']"))) {

        invokeIACEntry(iac1, iac2, iac3);
        Thread.sleep(DELAY_IN_MILLISECONDS);

      } else {

        break;

      }
    }
  }

  /**
   * Prints IAC Process status based on presence of element
   *
   * @throws InterruptedException pass the exception
   */
  public void responseCodeCheck() throws InterruptedException {
    // Wait 5 seconds for page to load
    Thread.sleep(DELAY_IN_MILLISECONDS);

    if (ifElementExists(By.xpath("//input[@name='iac1']"))) {

      if (ifElementExists(By.xpath("//h2[@class='alert__title']"))) {
        System.out.println("Incorrect IAC");
      }

    } else {

      if (ifElementExists(By.xpath("//h1[@class='header__title']"))) {
        System.out.println("Attempts Reached");
      } else {
        System.out.println("Correct IAC");
      }

    }

  }

  /**
   * Checks IAC Process response
   *
   * @throws InterruptedException pass the exception
   * @return returns responseCode to be checked
   */
  public String responseCodeAssertCheck() throws InterruptedException {

    String responseCode = "";

    // Wait 5 seconds for page to load
    Thread.sleep(DELAY_IN_MILLISECONDS);

    if (ifElementExists(By.xpath("//input[@name='iac1']"))) {

      if (ifElementExists(By.xpath("//h2[@class='alert__title']"))) {
        System.out.println("Incorrect IAC");
        responseCode = "Unsuccessful";
      }

    } else {

      if (ifElementExists(By.xpath("//h1[@class='header__title']"))) {
        System.out.println("Limit Reached");
        responseCode = "Limit Reached";
      } else {
        System.out.println("Correct IAC");
        responseCode = "Successful";
      }

    }

    webDriver.close();
    return responseCode;
  }

  /**
   * Checks if element exists
   *
   * @param by path of element
   * @return isExists Boolean whether element exists
   */
  public boolean ifElementExists(By by) {
    boolean isExists = true;
    try {
      webDriver.findElement(by);
    } catch (NoSuchElementException e) {
      isExists = false;
    }
    return isExists;
  }

}
