package uk.gov.ons.ctp.response.notify.specs;

import org.junit.runner.RunWith;

import cucumber.api.CucumberOptions;
import cucumber.api.junit.Cucumber;

/**
 * Created by stephen.goddard on 21/09/17.
 */
@RunWith(Cucumber.class)
@CucumberOptions(
  features = {"classpath:uk/gov/ons/ctp/response/notify/notifyGateway.feature"},
  glue = {"uk.gov.ons.ctp.response.notify.steps",
//          "uk.gov.ons.ctp.response.samplesvc.steps",
//          "uk.gov.ons.ctp.response.iacsvc.steps",
//          "uk.gov.ons.ctp.response.collectionexercisesvc.steps",
//          "uk.gov.ons.ctp.response.casesvc.steps",
          "uk.gov.ons.ctp.response.common.steps"},
  plugin = {"pretty", "html:build/notify-cucumber-html-report", "json:build/jenkins/notify.json"}
)
public class NotifyGatewayTest {

}
