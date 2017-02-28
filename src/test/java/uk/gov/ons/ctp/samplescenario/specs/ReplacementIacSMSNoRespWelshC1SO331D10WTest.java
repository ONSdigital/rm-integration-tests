package uk.gov.ons.ctp.samplescenario.specs;

import cucumber.api.CucumberOptions;
import cucumber.api.junit.Cucumber;
import org.junit.runner.RunWith;

/**
 * Created by Kieran Wardle on 19/12/16.
 */
@RunWith(Cucumber.class)
@CucumberOptions(
        features = {"classpath:uk/gov/ons/ctp/sampleScenarios/"
              + "replacementIacSMSNoRespWelshC1SO331D10W.feature"},
        glue = {"uk.gov.ons.ctp.response.casesvc.steps",
            "uk.gov.ons.ctp.ui.steps",
            "uk.gov.ons.ctp.response.common.steps",
            "uk.gov.ons.ctp.response.action.steps",
            "uk.gov.ons.ctp.response.iacsvc.steps"
            },
        plugin = {"pretty", "html:build/replacementIACSMSWelsh1-cucumber-html-report",
            "json:build/jenkins/IACSMSWelsh1.json"}
)
public class ReplacementIacSMSNoRespWelshC1SO331D10WTest {

}
