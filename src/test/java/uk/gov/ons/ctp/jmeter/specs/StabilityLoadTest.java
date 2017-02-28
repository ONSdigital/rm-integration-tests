package uk.gov.ons.ctp.jmeter.specs;

import org.junit.runner.RunWith;

import cucumber.api.CucumberOptions;
import cucumber.api.junit.Cucumber;

/**
 * Created by stephen.goddard on 27/01/17.
 */
@RunWith(Cucumber.class)
@CucumberOptions(
        features = {"classpath:uk/gov/ons/ctp/jmeter/stabilityLoadTest.feature"},
        glue = {"uk.gov.ons.ctp.jmeter.steps",
            "uk.gov.ons.ctp.response.common.steps"},
        plugin = {"pretty", "html:build/stabilityLoad-cucumber-html-report", "json:build/jenkins/stabilityLoad.json"}
)
public class StabilityLoadTest {

}
