package uk.gov.ons.ctp.journeys.execute.exercise.specs;

import org.junit.runner.RunWith;

import cucumber.api.CucumberOptions;
import cucumber.api.junit.Cucumber;

/**
 * Created by stephen.goddard on 25/05/17.
 */
@RunWith(Cucumber.class)
@CucumberOptions(features = {"classpath:uk/gov/ons/ctp/journeys/execute/exercise/executeCollectionExercise.feature"},
  glue = {"uk.gov.ons.ctp.response.samplesvc.steps",
          "uk.gov.ons.ctp.response.collectionexercisesvc.steps",
          "uk.gov.ons.ctp.response.common.steps",
          "uk.gov.ons.ctp.ui.rm.ro.steps"},
  plugin = {"pretty", "html:build/executeExercise-cuc-html-report", "json:build/jenkins/executeExercise.json"}
)
public class ExecuteCollectionExerciseTest {

}
