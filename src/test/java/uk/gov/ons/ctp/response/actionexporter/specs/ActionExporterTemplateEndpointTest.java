package uk.gov.ons.ctp.response.actionexporter.specs;
import cucumber.api.CucumberOptions;
import cucumber.api.junit.Cucumber;
import org.junit.runner.RunWith;

/**
 * Created by Edward Stevens on 10/07/17
 */

@RunWith(Cucumber.class)
@CucumberOptions(
        features = {"classpath:uk/gov/ons/ctp/response/actionexporter/actionExporterTemplateEndpoint.feature"},
        glue = {"uk.gov.ons.ctp.response.actionexporter.steps", "uk.gov.ons.ctp.response.common.steps"},
        plugin = {"pretty", "html:build/actionExporterTemplateEndpoint-cucumber-html-report",
            "json:build/jenkins/actionExporterTemplateEndpoint.json"}
)
public class ActionExporterTemplateEndpointTest {
}
