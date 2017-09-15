package uk.gov.ons.ctp.ui.rm.ro.pom;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindBy;
import org.openqa.selenium.support.PageFactory;

import static org.junit.Assert.assertEquals;


public class ActionStatusPom {
	/**
	 * Constructor
	 *
	 * @param webDriver Selenium web driver
	 */
	public ActionStatusPom(WebDriver webDriver) {
	  PageFactory.initElements(webDriver, this);
	}
}

