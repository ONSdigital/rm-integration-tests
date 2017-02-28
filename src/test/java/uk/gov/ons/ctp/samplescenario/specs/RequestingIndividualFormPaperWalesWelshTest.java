package uk.gov.ons.ctp.samplescenario.specs;

import cucumber.api.CucumberOptions;
import cucumber.api.junit.Cucumber;
import org.junit.runner.RunWith;

/**
 * Created by Edward Stevens on 22/12/16.
 */
@RunWith(Cucumber.class)
@CucumberOptions(
    features = {"classpath:uk/gov/ons/ctp/sampleScenarios/requestingIndividualFormPaperWalesWelsh.feature"},
    glue = {"uk.gov.ons.ctp.ui.steps", "uk.gov.ons.ctp.response.casesvc.steps",
        "uk.gov.ons.ctp.response.common.steps"},
    plugin = {"pretty", "html:build/rindfmppengww", "json:build/jenkins/rIndFmPpEngww.json"}
)
public class RequestingIndividualFormPaperWalesWelshTest {

}
