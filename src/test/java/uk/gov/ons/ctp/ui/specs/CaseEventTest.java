package uk.gov.ons.ctp.ui.specs;

import org.junit.runner.RunWith;

import cucumber.api.CucumberOptions;
import cucumber.api.junit.Cucumber;

/**
 * Created by Stephen Goddard on 15/6/16.
 */
@RunWith(Cucumber.class)
@CucumberOptions(features = {"classpath:uk/gov/ons/ctp/ui/caseEvent.feature"},
        glue = {"uk.gov.ons.ctp.ui.steps",
            "uk.gov.ons.ctp.response.casesvc.steps",
            "uk.gov.ons.ctp.response.common.steps" },
        plugin = { "pretty", "html:build/caseevent-cucumber-html-report", "json:build/jenkins/caseEvent.json"})
public class CaseEventTest {

}
