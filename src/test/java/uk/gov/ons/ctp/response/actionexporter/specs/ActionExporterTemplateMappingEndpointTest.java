package uk.gov.ons.ctp.response.actionexporter.specs;
import cucumber.api.CucumberOptions;
import cucumber.api.junit.Cucumber;
import org.junit.runner.RunWith;

/**
 * Created by Edward Stevens on 11/07/17
 */

@RunWith(Cucumber.class)
@CucumberOptions(
        features = {"classpath:uk/gov/ons/ctp/response/actionexporter/actionExporterTemplateMappingEndpoint.feature"},
        glue = {"uk.gov.ons.ctp.response.actionexporter.steps", "uk.gov.ons.ctp.response.common.steps"},
        plugin = {"pretty", "html:build/actionExporterTemplateMappingEndpoint-cucumber-html-report",
            "json:build/jenkins/actionExporterTemplateMappingEndpoint.json"}
)
public class ActionExporterTemplateMappingEndpointTest {
}
