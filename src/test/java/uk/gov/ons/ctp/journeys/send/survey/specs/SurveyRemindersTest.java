package uk.gov.ons.ctp.journeys.send.survey.specs;

import org.junit.runner.RunWith;

import cucumber.api.CucumberOptions;
import cucumber.api.junit.Cucumber;

/**
 * Created by stephen.goddard on 12/07/17.
 */
@RunWith(Cucumber.class)
@CucumberOptions(features = {"classpath:uk/gov/ons/ctp/journeys/send/survey/surveyReminders.feature"},
  glue = {"uk.gov.ons.ctp.response.samplesvc.steps",
      "uk.gov.ons.ctp.response.collectionexercisesvc.steps",
      "uk.gov.ons.ctp.response.iacsvc.steps",
      "uk.gov.ons.ctp.response.casesvc.steps",
      "uk.gov.ons.ctp.response.actionexporter.steps",
      "uk.gov.ons.ctp.response.common.steps",
      "uk.gov.ons.ctp.ui.rm.ro.steps"},
  plugin = {"pretty", "html:build/sendSurvey-cuc-html-report", "json:build/jenkins/sendSurvey.json"}
)
public class SurveyRemindersTest {

}
