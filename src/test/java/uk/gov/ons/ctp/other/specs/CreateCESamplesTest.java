package uk.gov.ons.ctp.other.specs;

import cucumber.api.CucumberOptions;
import cucumber.api.junit.Cucumber;
import org.junit.runner.RunWith;

/**
 * Created by Chris Hardman on 16/12/16.
 */
@RunWith(Cucumber.class)
@CucumberOptions(
        features = {"classpath:uk/gov/ons/ctp/other/createCEsamples.feature"},
        glue = {"uk.gov.ons.ctp.ui.steps", "uk.gov.ons.ctp.response.casesvc.steps",
                "uk.gov.ons.ctp.response.common.steps"},
        plugin = {"pretty", "html:build/createCEsamples-cucumber-html-report",
                  "json:build/jenkins/createCEsamples.json"}
)
public class CreateCESamplesTest {

}
