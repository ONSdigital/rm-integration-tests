package uk.gov.ons.ctp.response.samplesvc.specs;

import org.junit.runner.RunWith;

import cucumber.api.CucumberOptions;
import cucumber.api.junit.Cucumber;

/**
 * Created by stephen.goddard on 3/4/17.
 */
@RunWith(Cucumber.class)
@CucumberOptions(
        features = {"classpath:uk/gov/ons/ctp/response/samplesvc/xsdValidation.feature"},
        glue = {"uk.gov.ons.ctp.response.samplesvc.steps"},
        plugin = {"pretty", "html:build/samplesvc-cucumber-html-report", "json:build/jenkins/samplesvc.json"}
)
public class XsdValidationTest {

}
