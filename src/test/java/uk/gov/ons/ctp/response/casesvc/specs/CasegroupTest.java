package uk.gov.ons.ctp.response.casesvc.specs;

import cucumber.api.CucumberOptions;
import cucumber.api.junit.Cucumber;
import org.junit.runner.RunWith;

/**
 * Created by stephen.goddard on 29/9/16.
 */
@RunWith(Cucumber.class)
@CucumberOptions(
  features = {"classpath:uk/gov/ons/ctp/response/casesvc/casegroup.feature"},
  glue = {"uk.gov.ons.ctp.response.samplesvc.steps",
          "uk.gov.ons.ctp.response.casesvc.steps",
          "uk.gov.ons.ctp.response.collectionexercisesvc.steps",
          "uk.gov.ons.ctp.response.common.steps"},
  plugin = {"pretty", "html:build/casegroup-cucumber-html-report", "json:build/jenkins/casegroup.json"}
)
public class CasegroupTest {
}
