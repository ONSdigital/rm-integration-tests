package uk.gov.ons.ctp.initial.response.specs;

import org.junit.runner.RunWith;

import cucumber.api.CucumberOptions;
import cucumber.api.junit.Cucumber;

/**
 * Created by stephen.goddard on 25/11/16.
 */
@RunWith(Cucumber.class)
@CucumberOptions(
        features = {"classpath:uk/gov/ons/ctp/initial/response/welshOnlineResponse.feature"},
        glue = {"uk.gov.ons.ctp.response.casesvc.steps",
            "uk.gov.ons.ctp.ui.steps",
            "uk.gov.ons.ctp.response.iacsvc.steps",
            "uk.gov.ons.ctp.response.sdx.steps",
            "uk.gov.ons.ctp.response.common.steps"},
        plugin = {"pretty", "html:build/welshOnlineResponse-cucumber-html-report",
            "json:build/jenkins/welshOnlineResponse.json"}
)
public class WelshOnlineResponseTest {

}
