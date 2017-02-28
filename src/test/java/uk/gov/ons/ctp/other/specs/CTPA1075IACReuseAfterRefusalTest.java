package uk.gov.ons.ctp.other.specs;

import org.junit.runner.RunWith;

import cucumber.api.CucumberOptions;
import cucumber.api.junit.Cucumber;

/**
 * Created by stephen.goddard on 24/01/17.
 */
@RunWith(Cucumber.class)
@CucumberOptions(
        features = {"classpath:uk/gov/ons/ctp/other/CTPA1075IACReuseAfterRefusal.feature"},
        glue = {"uk.gov.ons.ctp.ui.steps",
            "uk.gov.ons.ctp.response.sdx.steps",
            "uk.gov.ons.ctp.response.iacsvc.steps",
            "uk.gov.ons.ctp.response.drs.steps",
            "uk.gov.ons.ctp.response.action.steps",
            "uk.gov.ons.ctp.response.casesvc.steps",
            "uk.gov.ons.ctp.response.common.steps"},
        plugin = {"pretty", "html:build/CTPA1075-cucumber-html-report", "json:build/jenkins/CTPA1075.json"}
)
public class CTPA1075IACReuseAfterRefusalTest {

}
