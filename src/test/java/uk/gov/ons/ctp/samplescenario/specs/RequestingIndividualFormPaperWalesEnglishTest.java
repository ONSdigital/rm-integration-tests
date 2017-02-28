package uk.gov.ons.ctp.samplescenario.specs;

import cucumber.api.CucumberOptions;
import cucumber.api.junit.Cucumber;
import org.junit.runner.RunWith;

/**
 * Created by Edward Stevens on 22/12/16.
 */
@RunWith(Cucumber.class)
@CucumberOptions(
    features = {"classpath:uk/gov/ons/ctp/sampleScenarios/requestingIndividualFormPaperWalesEnglish.feature"},
    glue = {"uk.gov.ons.ctp.ui.steps", "uk.gov.ons.ctp.response.casesvc.steps",
        "uk.gov.ons.ctp.response.common.steps"},
    plugin = {"pretty", "html:build/rindfmppengwe", "json:build/jenkins/rIndFmPpEngwe.json"}
)
public class RequestingIndividualFormPaperWalesEnglishTest {

}
