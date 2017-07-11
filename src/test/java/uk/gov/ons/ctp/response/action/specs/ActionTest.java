package uk.gov.ons.ctp.response.action.specs;

import cucumber.api.CucumberOptions;
import cucumber.api.junit.Cucumber;
import org.junit.runner.RunWith;

/**
 * Created by Stephen Goddard on 29/4/16.
 */
@RunWith(Cucumber.class)
@CucumberOptions(
        features = {"classpath:uk/gov/ons/ctp/response/action/action.feature"},
        glue = {"uk.gov.ons.ctp.response.action.steps",
            "uk.gov.ons.ctp.response.collectionexercisesvc.steps",
            "uk.gov.ons.ctp.ui.steps",
            "uk.gov.ons.ctp.response.casesvc.steps",
            "uk.gov.ons.ctp.response.common.steps",
            "uk.gov.ons.ctp.response.samplesvc.steps"},
        plugin = {"pretty", "html:build/action-cucumber-html-report", "json:build/jenkins/action.json"}
)
public class ActionTest {

}
