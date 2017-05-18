package uk.gov.ons.ctp.response.surveysvc.specs;

import org.junit.runner.RunWith;

import cucumber.api.CucumberOptions;
import cucumber.api.junit.Cucumber;

/**
 * Created by stephen.goddard on 16/5/17.
 */
@RunWith(Cucumber.class)
@CucumberOptions(
  features = {"classpath:uk/gov/ons/ctp/response/surveysvc/surveysvc.feature"},
  glue = {"uk.gov.ons.ctp.response.surveysvc.steps",
          "uk.gov.ons.ctp.response.common.steps"},
  plugin = {"pretty", "html:build/surveysvc-cucumber-html-report", "json:build/jenkins/surveysvc.json"}
)
public class SurveySvcTest {

}
