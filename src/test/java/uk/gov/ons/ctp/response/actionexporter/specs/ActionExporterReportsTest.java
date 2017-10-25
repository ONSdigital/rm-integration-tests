package uk.gov.ons.ctp.response.actionexporter.specs;
import cucumber.api.CucumberOptions;
import cucumber.api.junit.Cucumber;
import org.junit.runner.RunWith;

/**
 * Created by Chirstopher Hardman on 10/02/17.
 */

@RunWith(Cucumber.class)
@CucumberOptions(
        features = {"classpath:uk/gov/ons/ctp/response/actionexporter/actionExporterReports.feature"},
        glue = {"uk.gov.ons.ctp.response.samplesvc.steps",
            "uk.gov.ons.ctp.response.collectionexercisesvc.steps",
            "uk.gov.ons.ctp.response.actionexporter.steps",
            "uk.gov.ons.ctp.response.common.steps"},
        plugin = {"pretty", "html:build/actionexporterEndpoint-cucumber-html-report",
            "json:build/jenkins/actionexporterEndpoint.json"}
)
public class ActionExporterReportsTest {
}
