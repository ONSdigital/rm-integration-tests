package uk.gov.ons.ctp.ui.specs;

import org.junit.runner.RunWith;

import cucumber.api.CucumberOptions;
import cucumber.api.junit.Cucumber;

/**
 * Created by Kieran Wardle on 15/12/16.
 */
@RunWith(Cucumber.class)
@CucumberOptions(features = { "classpath:uk/gov/ons/ctp/ui/fieldActionEscalations.feature" },
        glue = {"uk.gov.ons.ctp.ui.steps", "uk.gov.ons.ctp.response.common.steps",
            "uk.gov.ons.ctp.response.casesvc.steps" },
        plugin = { "pretty", "html:build/fieldactionescalations-cucumber-html-report",
            "json:build/jenkins/fieldActEsc.json"})
public class FieldActionEscalationTest {

}
