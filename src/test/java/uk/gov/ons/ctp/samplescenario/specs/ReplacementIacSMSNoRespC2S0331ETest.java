package uk.gov.ons.ctp.samplescenario.specs;

import cucumber.api.CucumberOptions;
import cucumber.api.junit.Cucumber;
import org.junit.runner.RunWith;

/**
 * Created by Edward Stevens on 19/12/16.
 */
@RunWith(Cucumber.class)
@CucumberOptions(
        features = {"classpath:uk/gov/ons/ctp/sampleScenarios/replacementIacSMSNoRespC2S0331E.feature"},
        glue = {"uk.gov.ons.ctp.response.action.steps",
            "uk.gov.ons.ctp.response.casesvc.steps",
            "uk.gov.ons.ctp.response.iacsvc.steps",
            "uk.gov.ons.ctp.ui.steps",
            "uk.gov.ons.ctp.response.common.steps"},
        plugin = {"pretty", "html:build/riacsmsc2s", "json:build/jenkins/rIACSMSC2S.json"}
)
public class ReplacementIacSMSNoRespC2S0331ETest {

}
