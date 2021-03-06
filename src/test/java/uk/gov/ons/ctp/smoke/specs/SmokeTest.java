package uk.gov.ons.ctp.smoke.specs;

import org.junit.runner.RunWith;

import cucumber.api.CucumberOptions;
import cucumber.api.junit.Cucumber;

/**
 * Created by stephen.goddard on 25/05/17.
 */
@RunWith(Cucumber.class)
@CucumberOptions(
  features = {"classpath:uk/gov/ons/ctp/smoke/smoke.feature"},
  glue = {"uk.gov.ons.ctp.response.samplesvc.steps",
          "uk.gov.ons.ctp.response.collectionexercisesvc.steps",
          "uk.gov.ons.ctp.response.actionexporter.steps",
          "uk.gov.ons.ctp.response.common.steps"},
  plugin = {"pretty", "html:build/smoke-cuc-html-report", "json:build/jenkins/smoke.json"}
)
public class SmokeTest {

}
