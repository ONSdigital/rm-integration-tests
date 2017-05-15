package uk.gov.ons.ctp.response.collectionexercisesvc.specs;

import org.junit.runner.RunWith;

import cucumber.api.CucumberOptions;
import cucumber.api.junit.Cucumber;

/**
 * Created by Stephen Goddard on 11/5/17.
 */
@RunWith(Cucumber.class)
@CucumberOptions(
    features = {"classpath:uk/gov/ons/ctp/response/collectionexercisesvc/collectionexercisesvc.feature"},
    glue = {"uk.gov.ons.ctp.response.collectionexercisesvc.steps", "uk.gov.ons.ctp.response.common.steps"},
    plugin = {"pretty", "html:build/colletionex-cucumber-html-report", "json:build/jenkins/colletionex.json"}
)
public class CollectionExerciseSvcTest {

}
