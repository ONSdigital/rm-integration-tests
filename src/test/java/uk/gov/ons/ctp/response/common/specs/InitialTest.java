package uk.gov.ons.ctp.response.common.specs;

import cucumber.api.CucumberOptions;
import cucumber.api.junit.Cucumber;
import org.junit.runner.RunWith;

/**
 * Created by Stephen Goddard on 29/7/16.
 */
@RunWith(Cucumber.class)
@CucumberOptions(
        features = {"classpath:uk/gov/ons/ctp/response/common/initial.feature"},
        glue = {"uk.gov.ons.ctp.response.common.steps"},
        plugin = {"pretty", "html:build/initial-cucumber-html-report", "json:build/jenkins/initial.json"}
)
public class InitialTest {

}
