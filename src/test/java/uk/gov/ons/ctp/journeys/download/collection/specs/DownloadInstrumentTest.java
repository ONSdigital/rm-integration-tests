package uk.gov.ons.ctp.journeys.download.collection.specs;

import org.junit.runner.RunWith;

import cucumber.api.CucumberOptions;
import cucumber.api.junit.Cucumber;

/**
 * Created by stephen.goddard on 17/08/17.
 */
@RunWith(Cucumber.class)
@CucumberOptions(features = {"classpath:uk/gov/ons/ctp/journeys/download/collection/downloadInstrument.feature"},
  glue = {"uk.gov.ons.ctp.response.samplesvc.steps",
      "uk.gov.ons.ctp.response.collectionexercisesvc.steps",
      "uk.gov.ons.ctp.response.casesvc.steps",
      "uk.gov.ons.ctp.response.common.steps"},
  plugin = {"pretty", "html:build/download-report", "json:build/jenkins/download.json"}
)
public class DownloadInstrumentTest {

}
