package uk.gov.ons.ctp.response.action.specs;

import cucumber.api.CucumberOptions;
import cucumber.api.junit.Cucumber;
import org.junit.runner.RunWith;

/**
 * Created by Stephen Goddard on 29/4/16.
 */
@RunWith(Cucumber.class)
@CucumberOptions(
        features = {"classpath:uk/gov/ons/ctp/response/action/actionplan.feature"},
        glue = {"uk.gov.ons.ctp.response.action.steps", "uk.gov.ons.ctp.response.common.steps"},
        plugin = {"pretty", "html:build/actionplan-cucumber-html-report", "json:build/jenkins/actionPlan.json"}
)
public class ActionPlanTest {

}
