package uk.gov.ons.ctp.ui.rm.ro.pom;


import static org.junit.Assert.assertEquals;

import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindBy;
import org.openqa.selenium.support.PageFactory;


public class CaseEventsPom {
  @FindBy(xpath = "//*[@id=\"main\"]/table/tbody[1]/tr/td[2]")
  private WebElement sampleUnitType;
  
  @FindBy(xpath = "//*[@id=\"main\"]/table/tbody[1]/tr/td[4]")
  private WebElement caseCreated;
  
  @FindBy(xpath = "//*[@id=\"main\"]/table/tbody[1]/tr/td[6]")
  private WebElement actionCompleted;

  @FindBy(xpath = "//*[@id=\"main\"]/table/tbody[1]/tr/td[7]")
  private WebElement respondentAccountCreated;
  
  @FindBy(xpath = "//*[@id=\"main\"]/table/tbody[1]/tr/td[8]")
  private WebElement respondentEnrolled;

  @FindBy(xpath = "//*[@id=\"main\"]/table/tbody[1]/tr/td[9]")
  private WebElement authenticationAttempt;
  
  @FindBy(xpath = "//*[@id=\"main\"]/table/tbody[1]/tr/td[10]")
  private WebElement collectionDownload;
  
  @FindBy(xpath = "//*[@id=\"main\"]/table/tbody[1]/tr/td[11]")
  private WebElement unsuccessfulResponse;
  
  @FindBy(xpath = "//*[@id=\"main\"]/table/tbody[1]/tr/td[12]")
  private WebElement successfulResponse;

  /**
   * Constructor
   *
   * @param webDriver Selenium web driver
   */
  public CaseEventsPom(WebDriver webDriver) {
    PageFactory.initElements(webDriver, this);
  }	 
  
  public void checkSampleUnitType(String sampleType) {
	  
    String retrivedSampleUnitType = sampleUnitType.getText();
    assertEquals(sampleType, retrivedSampleUnitType);
  }
  
  public void checkCaseCreated(String caseInit) {
	
    String retrivedCaseCreated = caseCreated.getText();
    assertEquals(caseInit, retrivedCaseCreated);
  }
  
  public void checkActionCompleted(String action) {
		
    String retrivedActionCompleted = actionCompleted.getText();
    assertEquals(action, retrivedActionCompleted);
  }
  
  public void checkAccountCreated(String accountCreated) {
		
    String retrivedAccountCreated = respondentAccountCreated.getText();
    assertEquals(accountCreated, retrivedAccountCreated);
  }
  
  public void checkEnrolled(String enrolled) {
		
    String retrivedEnrolled = respondentEnrolled.getText();
    assertEquals(enrolled, retrivedEnrolled);
  }
  
  public void checkAuthentication(String authentication) {
		
    String retrivedAuthentication = authenticationAttempt.getText();
    assertEquals(authentication, retrivedAuthentication);
  }
  
  public void checkOfflineResponse(String download) {
		
    String retrivedCollectionDownload = collectionDownload.getText();
    assertEquals(download, retrivedCollectionDownload);
  }
  
  public void checkCollectionDownload(String download) {
		
    String retrivedCollectionDownload = collectionDownload.getText();
    assertEquals(download, retrivedCollectionDownload);
  }
  
  public void checkSuccessfulResponse(String response) {
		
    String retrivedSuccessfulResponse = successfulResponse.getText();
    assertEquals(response, retrivedSuccessfulResponse);
  }
  
  public void checkUnsuccessfulResponse(String response) {
		
    String retrivedUnsuccessfulResponse = unsuccessfulResponse.getText();
    assertEquals(response, retrivedUnsuccessfulResponse);
  }
}

