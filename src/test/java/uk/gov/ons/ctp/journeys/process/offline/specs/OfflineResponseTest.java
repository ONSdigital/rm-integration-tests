package uk.gov.ons.ctp.journeys.process.offline.specs;

import org.junit.runner.RunWith;

import cucumber.api.CucumberOptions;
import cucumber.api.junit.Cucumber;

/**
 * Created by stephen.goddard on 17/08/17.
 */
@RunWith(Cucumber.class)
@CucumberOptions(features = {"classpath:uk/gov/ons/ctp/journeys/process/offline/offlineResponse.feature"},
  glue = {"uk.gov.ons.ctp.response.samplesvc.steps",
      "uk.gov.ons.ctp.response.collectionexercisesvc.steps",
      "uk.gov.ons.ctp.response.iacsvc.steps",
      "uk.gov.ons.ctp.response.casesvc.steps",
      "uk.gov.ons.ctp.response.common.steps",
      "uk.gov.ons.ctp.ui.rm.ro.steps"},
  plugin = {"pretty", "html:build/OfflineResponse-report", "json:build/jenkins/OfflineResponse.json"}
)
public class OfflineResponseTest {

}
