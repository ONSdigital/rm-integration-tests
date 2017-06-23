package uk.gov.ons.ctp.journeys.send.enrolement.specs;

import org.junit.runner.RunWith;

import cucumber.api.CucumberOptions;
import cucumber.api.junit.Cucumber;

/**
 * Created by stephen.goddard on 19/06/17.
 */
@RunWith(Cucumber.class)
@CucumberOptions(features = {"classpath:uk/gov/ons/ctp/journeys/send/enrolement/lettersAndReminders.feature"},
  glue = {"uk.gov.ons.ctp.response.samplesvc.steps",
      "uk.gov.ons.ctp.response.collectionexercisesvc.steps",
      "uk.gov.ons.ctp.response.actionexporter.steps",
      "uk.gov.ons.ctp.response.common.steps"},
  plugin = {"pretty", "html:build/sendEnrole-cuc-html-report", "json:build/jenkins/sendEnrole.json"}
)
public class LettersAndRemindersTest {

}
