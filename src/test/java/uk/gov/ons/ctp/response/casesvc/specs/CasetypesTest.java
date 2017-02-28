package uk.gov.ons.ctp.response.casesvc.specs;

import cucumber.api.CucumberOptions;
import cucumber.api.junit.Cucumber;
import org.junit.runner.RunWith;

/**
 * Created by Stephen Goddard on 8/3/16.
 */

@RunWith(Cucumber.class)
@CucumberOptions(
        features = {"classpath:uk/gov/ons/ctp/response/casesvc/casetypes.feature"},
        glue = {"uk.gov.ons.ctp.response.casesvc.steps", "uk.gov.ons.ctp.response.common.steps"},
        plugin = {"pretty", "html:build/casetypes-cucumber-html-report", "json:build/jenkins/casetypes.json"}
)
public class CasetypesTest {
}
