package uk.gov.ons.ctp.response.actionexporter.specs;
import cucumber.api.CucumberOptions;
import cucumber.api.junit.Cucumber;
import org.junit.runner.RunWith;

/**
 * Created by Kieran Wardle on 09/02/17.
 */

@RunWith(Cucumber.class)
@CucumberOptions(
        features = {"classpath:uk/gov/ons/ctp/response/actionexporter/reportMIReportListEndpointAE.feature"},
        glue = {"uk.gov.ons.ctp.response.actionexporter.steps", "uk.gov.ons.ctp.response.common.steps"},
        plugin = {"pretty", "html:build/actionexporterReportList-cucumber-html-report",
            "json:build/jenkins/actionexporterReportList.json"}
)
public class ReportMIReportListEndpointAETest {

}
