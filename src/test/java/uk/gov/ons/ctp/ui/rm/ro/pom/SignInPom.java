package uk.gov.ons.ctp.ui.rm.ro.pom;

import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindBy;
import org.openqa.selenium.support.PageFactory;

/**
 * Created by Stephen Goddard on 17/03/17.
 */
public class SignInPom {
  @FindBy(id = "username")
  private WebElement username;

  @FindBy(name = "password")
  private WebElement password;

  @FindBy(xpath = "//*[@id=\"yui-main\"]/div/form/fieldset/p[3]/input")
  private WebElement submit;

  /**
   * Constructor
   *
   * @param webDriver Selenium web driver
   */
  public SignInPom(WebDriver webDriver) {
    PageFactory.initElements(webDriver, this);
  }

  /**
   * Clear username field
   */
  public void clearUsername() {
    username.clear();
  }

  /**
   * Add username to username field
   *
   * @param strUsername string to be inserted into field
   */
  public void setUsername(String strUsername) {
    username.sendKeys(strUsername);
  }

  /**
   * Clear password field
   */
  public void clearPassword() {
    password.clear();
  }

  /**
   * Add password to password field
   *
   * @param strPassowrd string to be inserted into field
   */
  public void setPassword(String strPassowrd) {
    password.sendKeys(strPassowrd);
  }

  /**
   * Send sumbit event on form
   */
  public void submitLogin() {
    submit.click();
  }

  /**
   * Login to system
   *
   * @param user string to be inserted into field
   * @param pword string to be inserted into field
   */
  public void login(String user, String pword) {
    clearUsername();
    clearPassword();
    setUsername(user);
    setPassword(pword);
    submitLogin();
  }
}
