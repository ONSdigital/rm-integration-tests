package uk.gov.ons.ctp.ui.specs;

import org.junit.runner.RunWith;

import cucumber.api.CucumberOptions;
import cucumber.api.junit.Cucumber;

/**
 * Created by Kieran Wardle on 16/01/17.
 */
@RunWith(Cucumber.class)
@CucumberOptions(features = { "classpath:uk/gov/ons/ctp/ui/ReportMI/correctReportContents.feature" },
        glue = {"uk.gov.ons.ctp.ui.steps", "uk.gov.ons.ctp.response.common.steps",
        "uk.gov.ons.ctp.response.casesvc.steps" },
        plugin = { "pretty", "html:build/pcodesearchaddsel-cucumber-html-report",
        "json:build/jenkins/reportsContents.json"})
public class CorrectReportContentsTest {

}
