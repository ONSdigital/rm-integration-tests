package uk.gov.ons.ctp.ui.rm.ro.pom;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindBy;
import org.openqa.selenium.support.PageFactory;

import static org.junit.Assert.assertEquals;


public class ActionStatusPom {
	
	@FindBy(xpath = "//*[@id=\"main\"]/table/tbody[1]/tr/td[2]")
	private WebElement enrolmentLetter;
	
	@FindBy(xpath = "//*[@id=\"main\"]/table/tbody[1]/tr/td[6]")
	private WebElement enrolmentActions;
	
	@FindBy(xpath = "//*[@id=\"main\"]/table/tbody[1]/tr/td[2]")
	private WebElement reminderLetter;

	@FindBy(xpath = "//*[@id=\"main\"]/table/tbody[2]/tr/td[6]")
	private WebElement reminderActions;
	
	@FindBy(xpath = "//*[@id=\"main\"]/table/tbody[7]/tr/td[6]")
	private WebElement surveyReminderNotification;
	/**
	 * Constructor
	 *
	 * @param webDriver Selenium web driver
	 */
	public ActionStatusPom(WebDriver webDriver) {
	  PageFactory.initElements(webDriver, this);
	}

	public void checkEnrolmentLetter(String name) {	
	  String retrivedActions= enrolmentLetter.getText();
	  assertEquals(name, retrivedActions);
	}
	
	public void checkEnrolmentActionCount(String count) {	
	  String retrivedActions= enrolmentActions.getText();
	  assertEquals(count, retrivedActions);
	}
	
	public void checkReminderLetter(String name) {	
	  String retrivedActions= reminderLetter.getText();
	  assertEquals(name, retrivedActions);
	}
	
	public void checkReminderActionCount(String count) {	
	  String retrivedActions= reminderActions.getText();
	  assertEquals(count, retrivedActions);
	}
	public void checkSurveyReminderNotification(String count) {	
	  String retrivedsurveyReminderNotififcation= surveyReminderNotification.getText();
	  assertEquals(count, retrivedsurveyReminderNotififcation);
    }
}

