package uk.gov.ons.ctp.ui.specs;

import org.junit.runner.RunWith;

import cucumber.api.CucumberOptions;
import cucumber.api.junit.Cucumber;

/**
 * Created by Chris Hardman on 18/11/16.
 */
@RunWith(Cucumber.class)
@CucumberOptions(features = { "classpath:uk/gov/ons/ctp/ui/postCodeSearchAddressSelection.feature" },
        glue = {"uk.gov.ons.ctp.ui.steps", "uk.gov.ons.ctp.response.common.steps",
        "uk.gov.ons.ctp.response.casesvc.steps" },
        plugin = { "pretty", "html:build/pcodesearchaddsel-cucumber-html-report",
        "json:build/jenkins/pCodeSearchAddSel.json"})

public class PostCodeSearchAddressSelectionTest {
}
