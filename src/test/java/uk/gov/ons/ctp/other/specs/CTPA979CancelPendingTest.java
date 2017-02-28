package uk.gov.ons.ctp.other.specs;

import org.junit.runner.RunWith;

import cucumber.api.CucumberOptions;
import cucumber.api.junit.Cucumber;

/**
 * Created by stephen.goddard on 17/01/17.
 */
@RunWith(Cucumber.class)
@CucumberOptions(
        features = {"classpath:uk/gov/ons/ctp/other/CTPA979CancelPending.feature"},
        glue = {"uk.gov.ons.ctp.ui.steps",
            "uk.gov.ons.ctp.response.casesvc.steps",
            "uk.gov.ons.ctp.response.sdx.steps",
            "uk.gov.ons.ctp.response.common.steps"},
        plugin = {"pretty", "html:build/CTPA979-cucumber-html-report", "json:build/jenkins/CTPA979.json"}
)
public class CTPA979CancelPendingTest {

}
