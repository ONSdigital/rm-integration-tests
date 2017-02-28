package uk.gov.ons.ctp.ui.specs;

import cucumber.api.CucumberOptions;
import cucumber.api.junit.Cucumber;
import org.junit.runner.RunWith;

/**
 * Created by Edward Stevens on 22/1/16.
 */
@RunWith(Cucumber.class)
@CucumberOptions(features = {"classpath:uk/gov/ons/ctp/ui/eventHistory.feature"},
        glue = {"uk.gov.ons.ctp.ui.steps", "uk.gov.ons.ctp.response.casesvc.steps",
        "uk.gov.ons.ctp.response.common.steps", "uk.gov.ons.ctp.response.sdx.steps" },
        plugin = {"pretty", "html:build/eventhistory-cucumber-html-report", "json:build/jenkins/eventHistory.json"})

public class EventHistoryTest {
}
