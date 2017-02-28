package uk.gov.ons.ctp.samplescenario.specs;

import cucumber.api.CucumberOptions;
import cucumber.api.junit.Cucumber;
import org.junit.runner.RunWith;

/**
 * Created by Gareth Turner on 20/12/16.
 */
@RunWith(Cucumber.class)
@CucumberOptions(
        features = {"classpath:uk/gov/ons/ctp/sampleScenarios/initialSetUpSHOUSING.feature"},
        glue = {"uk.gov.ons.ctp.response.casesvc.steps",
            "uk.gov.ons.ctp.ui.steps",
            "uk.gov.ons.ctp.response.common.steps"},
        plugin = {"pretty", "html:build/InitialSetUpSHOUSING-cucumber-html-report",
                  "json:build/jenkins/initialSetUpSHOUSING.json"}
)
public class InitialSetUpSHOUSINGTest {

}
