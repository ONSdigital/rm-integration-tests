package uk.gov.ons.ctp.ui.specs;

import org.junit.runner.RunWith;

import cucumber.api.CucumberOptions;
import cucumber.api.junit.Cucumber;

/**
 * Created by Kieran Wardle and Edward Stevens on 13/12/16.
 */
@RunWith(Cucumber.class)
@CucumberOptions(features = { "classpath:uk/gov/ons/ctp/ui/generalActionEscalations.feature" },
        glue = {"uk.gov.ons.ctp.ui.steps", "uk.gov.ons.ctp.response.common.steps",
            "uk.gov.ons.ctp.response.casesvc.steps" },
        plugin = { "pretty", "html:build/generalactionescalations-cucumber-html-report",
                      "json:build/jenkins/genActEsc.json"})
public class GeneralActionEscalationTest {

}
