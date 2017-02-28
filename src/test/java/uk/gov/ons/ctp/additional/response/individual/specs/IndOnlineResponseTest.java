package uk.gov.ons.ctp.additional.response.individual.specs;

import org.junit.runner.RunWith;

import cucumber.api.CucumberOptions;
import cucumber.api.junit.Cucumber;

/**
 * Created by stephen.goddard on 12/10/16.
 */
@RunWith(Cucumber.class)
@CucumberOptions(
        features = {"classpath:uk/gov/ons/ctp/additional/response/individual/indOnlineResponse.feature"},
        glue = {"uk.gov.ons.ctp.response.casesvc.steps",
            "uk.gov.ons.ctp.ui.steps",
            "uk.gov.ons.ctp.response.iacsvc.steps",
            "uk.gov.ons.ctp.response.sdx.steps",
            "uk.gov.ons.ctp.response.common.steps"},
        plugin = {"pretty", "html:build/indOnlineResponse-cucumber-html-report",
            "json:build/jenkins/indOnlineResponse.json"}
)
public class IndOnlineResponseTest {

}
