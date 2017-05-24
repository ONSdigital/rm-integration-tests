package uk.gov.ons.ctp.response.casesvc.specs;

import org.junit.runner.RunWith;

import cucumber.api.CucumberOptions;
import cucumber.api.junit.Cucumber;

/**
 * Created by Stephen Goddard on 19/5/17.
 */
@RunWith(Cucumber.class)
@CucumberOptions(
  features = {"classpath:uk/gov/ons/ctp/response/casesvc/casesvc.feature"},
  glue = {"uk.gov.ons.ctp.response.collectionexercisesvc.steps",
          "uk.gov.ons.ctp.response.casesvc.steps",
          "uk.gov.ons.ctp.response.common.steps"},
  plugin = {"pretty", "html:build/case-cucumber-html-report", "json:build/jenkins/case.json"}
)
public class CaseSvcTest {

}
