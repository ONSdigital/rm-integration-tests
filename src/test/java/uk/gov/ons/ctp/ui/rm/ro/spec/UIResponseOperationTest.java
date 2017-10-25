package uk.gov.ons.ctp.ui.rm.ro.spec;

import org.junit.runner.RunWith;

import cucumber.api.CucumberOptions;
import cucumber.api.junit.Cucumber;

/**
 * Created by stephen.goddard on 01/08/17.
 */
@RunWith(Cucumber.class)
@CucumberOptions(
  features = {"classpath:uk/gov/ons/ctp/ui/rm/ro/uiResponseOperation.feature"},
  glue = {"uk.gov.ons.ctp.response.samplesvc.steps",
      "uk.gov.ons.ctp.response.collectionexercisesvc.steps",
      "uk.gov.ons.ctp.response.casesvc.steps",
      "uk.gov.ons.ctp.response.actionexporter.steps",
      "uk.gov.ons.ctp.response.common.steps",
      "uk.gov.ons.ctp.ui.rm.ro.steps"},
  plugin = {"pretty", "html:build/uiRO-cuc-html-report", "json:build/jenkins/uiRO.json"}
)
public class UIResponseOperationTest {

}
