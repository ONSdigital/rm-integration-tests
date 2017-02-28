package uk.gov.ons.ctp.ui.specs;

import org.junit.runner.RunWith;

import cucumber.api.CucumberOptions;
import cucumber.api.junit.Cucumber;

/**
 * Created by Chris Hardman on 17/01/17.
 */
@RunWith(Cucumber.class)
@CucumberOptions(features = { "classpath:uk/gov/ons/ctp/ui/ReportMI/ReportMITypeValidation.feature" },
        glue = {"uk.gov.ons.ctp.ui.steps", "uk.gov.ons.ctp.response.common.steps",
        "uk.gov.ons.ctp.response.casesvc.steps" },
        plugin = { "pretty", "html:build/reporttypes-cucumber-html-report",
        "json:build/jenkins/reporttypes.json"})

public class ReportMITypeValidationTest {
}
