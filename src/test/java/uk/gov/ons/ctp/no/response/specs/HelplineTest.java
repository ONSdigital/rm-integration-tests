package uk.gov.ons.ctp.no.response.specs;

import org.junit.runner.RunWith;

import cucumber.api.CucumberOptions;
import cucumber.api.junit.Cucumber;

/**
 * Created by stephen.goddard on 07/10/16.
 */
@RunWith(Cucumber.class)
@CucumberOptions(
        features = {"classpath:uk/gov/ons/ctp/no/response/helpline.feature"},
        glue = {"uk.gov.ons.ctp.ui.steps",
            "uk.gov.ons.ctp.response.casesvc.steps",
            "uk.gov.ons.ctp.response.common.steps"},
        plugin = {"pretty", "html:build/helpline-cucumber-html-report", "json:build/jenkins/helpline.json"}
)
public class HelplineTest {

}
