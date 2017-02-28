package uk.gov.ons.ctp.samplescenario.specs;

import cucumber.api.CucumberOptions;
import cucumber.api.junit.Cucumber;
import org.junit.runner.RunWith;

/**
 * Created by Kieran Wardle on 21/12/16.
 */
@RunWith(Cucumber.class)
@CucumberOptions(
        features = {"classpath:uk/gov/ons/ctp/sampleScenarios/"
              + "requestingIndividualFormSMSWelshC2EP331W.feature"},
        glue = {"uk.gov.ons.ctp.response.casesvc.steps",
            "uk.gov.ons.ctp.ui.steps",
            "uk.gov.ons.ctp.response.common.steps",
            "uk.gov.ons.ctp.response.action.steps",
            "uk.gov.ons.ctp.response.iacsvc.steps"
            },
        plugin = {"pretty", "html:build/indivSMSWelsh-cucumber-html-report", "json:build/jenkins/indivSMSWelsh.json"}
)
public class RequestingIndividualFormSMSWelshC2EP331WTest {

}
